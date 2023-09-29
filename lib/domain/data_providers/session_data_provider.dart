import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class _Keys {
  static const sessionId = 'session-id';
  static const accountId = 'account-id';
}

class SessionDataProvider {
  // Сохраняем sessionId
  Future<void> setSessionId(String? sessionId) {
    if (sessionId != null) {
      return const FlutterSecureStorage()
          .write(key: _Keys.sessionId, value: sessionId);
    } else {
      return const FlutterSecureStorage().delete(key: _Keys.sessionId);
    }
  }

  Future<String?> getSessionId() {
    return const FlutterSecureStorage().read(key: _Keys.sessionId);
  }

  Future<void> setAccountId(int? accountId) {
    if (accountId != null) {
      return const FlutterSecureStorage()
          .write(key: _Keys.accountId, value: accountId.toString());
    } else {
      return const FlutterSecureStorage().delete(key: _Keys.accountId);
    }
  }

  Future<int?> getAccountId() async {
    final id = await const FlutterSecureStorage().read(key: _Keys.accountId);
    return id != null ? int.tryParse(id) : null;
  }
}
