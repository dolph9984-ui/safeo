import 'package:securite_mobile/constants/storage_keys.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class OAuthToken {
  final String accessToken;
  final String refreshToken;

  OAuthToken({required this.accessToken, required this.refreshToken});

  @override
  String toString() {
    return 'OAuthToken(accessToken: $accessToken, refreshToken: $refreshToken)';
  }
}

class OAuthTokenModel {
  static Future<void> storeTokens(OAuthToken token) async {
    await SecureStorageService().write(
      StorageKeys.accessToken,
      token.accessToken,
    );
    await SecureStorageService().write(
      StorageKeys.refreshToken,
      token.refreshToken,
    );
  }

  static Future<void> deleteTokens() async {
    await SecureStorageService().delete(StorageKeys.accessToken);
  }
}