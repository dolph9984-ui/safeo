import 'package:dio/dio.dart';
import 'package:securite_mobile/constants/oauth_constants.dart';
import 'package:securite_mobile/constants/api_request_keys.dart';
import 'package:securite_mobile/model/auth/oauth_token_model.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class OAuthService {
final Dio _dio = DioClient.dio;

  Future<Map<String, String>> getAuthCodes() async {
    final response = await _dio.get(OAuthConstants.pkceGeneratorUri);
    return Map<String, String>.from(response.data);
  }

  Future<String> getAuthUrl(String codeChallenge) async {
    final response = await _dio.post(
      OAuthConstants.getGoogleAuthUri,
      data: {ApiRequestKeys.codeChallenge: codeChallenge},
    );
    return response.data[ApiRequestKeys.googleAuthUrl];
  }

  Future<Map<String, String>> exchangeTokens(
    String codeVerifier,
    String authCode,
  ) async {
    final response = await _dio.post(
      OAuthConstants.exchangeTokenUri,
      data: {
        ApiRequestKeys.codeVerifier: codeVerifier,
        ApiRequestKeys.authorizationCode: authCode,
      },
    );
    return Map<String, String>.from(response.data);
  }

  Future<void> storeTokens(OAuthToken token) async {
    OAuthTokenModel.storeTokens(token);
  }

  Future<void> removeTokens() async {
    OAuthTokenModel.deleteTokens();
  }
}
