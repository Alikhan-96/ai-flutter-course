import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for secure storage operations
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final _storage = const FlutterSecureStorage();

  // Keys
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUsername = 'username';

  /// Save authentication token
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  /// Get authentication token
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  /// Delete authentication token
  Future<void> deleteAuthToken() async {
    await _storage.delete(key: _keyAuthToken);
  }

  /// Save username
  Future<void> saveUsername(String username) async {
    await _storage.write(key: _keyUsername, value: username);
  }

  /// Get username
  Future<String?> getUsername() async {
    return await _storage.read(key: _keyUsername);
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user is authenticated (has token)
  Future<bool> isAuthenticated() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }
}
