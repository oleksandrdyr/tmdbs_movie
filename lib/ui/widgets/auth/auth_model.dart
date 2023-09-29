import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  Future<void> auth(BuildContext context) async {
    // Сперва проверитм не пустые ли поля
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      _errorMessage = 'Заполните логин и пароль';
      notifyListeners();
      return;
    }
    // Если поля не пустые обнуляем ошибку
    _errorMessage = null;
    // чтобы кнопку задизейблить
    _isAuthProgress = true;
    notifyListeners();
    String? sessionId;
    int? accountId;
    try {
      // Пытаемся получить sessionId
      sessionId = await _apiClient.auth(
        userName: login,
        password: password,
      );
      // Пытаемся получить accountId
      accountId = await _apiClient.getAccountId(sessionId);
    } on Exception catch (e) {
      _errorMessage = e.toString();
    }
    _isAuthProgress = false;
    if (_errorMessage != null || sessionId == null || accountId == null) {
      notifyListeners();
      return;
    }
// Если sessionId и  accountId есть, то сохраняем в secureStorage
    await SessionDataProvider().setSessionId(sessionId);
    await SessionDataProvider().setAccountId(accountId);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);
  }
}

class AuthModelProvider extends InheritedNotifier {
  final AuthModel model;
  const AuthModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static AuthModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthModelProvider>();
  }

  static AuthModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<AuthModelProvider>()
        ?.widget;
    return widget is AuthModelProvider ? widget : null;
  }
}
