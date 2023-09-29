import 'package:flutter/cupertino.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class MyAppModel extends ChangeNotifier {
  var _isAuth = false;
  bool get isAuth => _isAuth;

  Future<void> checkAuth() async {
    final sessionId = await SessionDataProvider().getSessionId();
    // Если null, то вернет false иначе true
    _isAuth = sessionId != null;
  }
}

class MyAppModelProvider extends InheritedNotifier {
  final MyAppModel model;
  const MyAppModelProvider({
    Key? key,
    required Widget child,
    required this.model,
  }) : super(
          key: key,
          child: child,
          notifier: model,
        );

  static MyAppModelProvider? watch(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyAppModelProvider>();
  }

  static MyAppModelProvider? read(BuildContext context) {
    final widget = context
        .getElementForInheritedWidgetOfExactType<MyAppModelProvider>()
        ?.widget;
    return widget is MyAppModelProvider ? widget : null;
  }
}
