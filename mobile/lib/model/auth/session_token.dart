import 'package:securite_mobile/constants/storage_keys.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class SessionToken {
  final String accessToken;
  final String refreshToken;

  SessionToken({required this.accessToken, required this.refreshToken});

  @override
  String toString() {
    return 'OAuthToken(accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

class SessionTokenModel {
  static Future<void> storeAccessToken(String accessToken) async {
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
  }
}
