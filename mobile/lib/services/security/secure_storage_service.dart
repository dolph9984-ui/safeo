// lib/services/security/secure_storage_service.dart

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      keyCipherAlgorithm: KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _keyAccessToken = 'access_token';
  static const String _keyRefreshToken = 'refresh_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserRole = 'user_role';

  Future<void> initialize() async {
    try {
      await _storage.containsKey(key: _keyAccessToken);
      print('✅ SecureStorageService initialisé');
    } catch (e) {
      print('⚠️ Erreur initialisation SecureStorage: $e');
    }
  }

  // ==================== TOKENS ====================

  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _keyAccessToken, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _keyAccessToken);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _keyRefreshToken, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  // ==================== USER INFO ====================

  Future<void> saveUserInfo({
    required String userId,
    required String email,
    String? role,
    String? refreshToken,
  }) async {
    await _storage.write(key: _keyUserId, value: userId);
    await _storage.write(key: _keyUserEmail, value: email);
    
    if (role != null) {
      await _storage.write(key: _keyUserRole, value: role);
    }
    
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  // ==================== AUTH STATE ====================

  Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ==================== LOGOUT ====================

  Future<void> logout() async {
    await _storage.delete(key: _keyAccessToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyUserEmail);
    await _storage.delete(key: _keyUserRole);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  // ==================== MÉTHODES GÉNÉRIQUES ====================
  // ✅ Pour le rate limiting et autres usages

  /// Lit une valeur du stockage sécurisé
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Écrit une valeur dans le stockage sécurisé
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Supprime une valeur du stockage sécurisé
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }
}