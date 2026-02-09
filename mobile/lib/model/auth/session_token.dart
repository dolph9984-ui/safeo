import 'package:flutter/cupertino.dart';
import 'package:securite_mobile/constants/storage_keys.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class SessionToken {
  final String accessToken;
  final String refreshToken;

  SessionToken({required this.accessToken, required this.refreshToken});

  @override
  String toString() {
    return 'SessionToken(accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

class SessionTokenModel {
  static Future<void> storeAccessToken(String accessToken) async {
    debugPrint('Access token : $accessToken');
    await SecureStorageService().write(StorageKeys.accessToken, accessToken);
  }

  static Future<void> storeRefreshToken(String accessToken) async {
    await SecureStorageService().write(StorageKeys.refreshToken, accessToken);
  }

  static Future<void> storeTokens(SessionToken token) async {
    await storeAccessToken(token.accessToken);
    await storeRefreshToken(token.refreshToken);
  }

  static Future<void> deleteTokens() async {
    await SecureStorageService().delete(StorageKeys.accessToken);
    await SecureStorageService().delete(StorageKeys.refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await SecureStorageService().read(StorageKeys.accessToken);
  }

  static Future<String?> getRefreshToken() async {
    return await SecureStorageService().read(StorageKeys.refreshToken);
  }

  static Future<SessionToken?> getTokens() async {
    final accessToken = await getAccessToken();
    final refreshToken = await getRefreshToken();
    if (accessToken == null || refreshToken == null) return null;
    return SessionToken(accessToken: accessToken, refreshToken: refreshToken);
  }
}
