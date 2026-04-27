import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationLocalStorage {
  static const _tokenKey = 'auth_token';

  final FlutterSecureStorage _storage;

  const AuthenticationLocalStorage(this._storage);

  Future<void> saveToken(String token) {
    return _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() {
    return _storage.read(key: _tokenKey);
  }

  Future<void> clearToken() {
    return _storage.delete(key: _tokenKey);
  }
}