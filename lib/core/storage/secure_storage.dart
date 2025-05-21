import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();
  static const _keyToken = 'jwt_token';
  static const _keyRoleId = 'role_id';
  // Tambahkan konfigurasi platform-specific
  static const _androidOptions = AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static const _iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static Future<void> saveToken(String token) async {
    await _storage.write(
      key: _keyToken,
      value: token,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<String?> getToken() async {
    return await _storage.read(
      key: _keyToken,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<void> deleteToken() async {
    await _storage.delete(
      key: _keyToken,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<void> saveInt(String key, int value) async {
    await _storage.write(
      key: key,
      value: value.toString(),
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<int?> getInt(String key) async {
    final value = await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
    return value != null ? int.tryParse(value) : null;
  }

  static Future<void> saveString(String key, String value) async {
    await _storage.write(
      key: key,
      value: value,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<String?> getString(String key) async {
    return await _storage.read(
      key: key,
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<Map<String, dynamic>> getAuthStatus() async {
    final results = await Future.wait([
      _storage.read(
        key: _keyToken,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      ),
      _storage.read(
        key: _keyRoleId,
        aOptions: _androidOptions,
        iOptions: _iosOptions,
      ),
    ]);

    return {
      'hasToken': results[0] != null && results[0]!.isNotEmpty,
      'roleId': results[1] != null ? int.tryParse(results[1]!) : null,
    };
  }

  static Future<void> clearAll() async {
    await _storage.deleteAll(aOptions: _androidOptions, iOptions: _iosOptions);
  }

  static Future<void> clearAuthData() async {
    await _storage.delete(
      key: 'auth_token',
      aOptions: _androidOptions,
      iOptions: _iosOptions,
    );
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
