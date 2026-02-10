import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:securite_mobile/constants/api_request_keys.dart';
import 'package:securite_mobile/constants/oauth_constants.dart';
import 'package:securite_mobile/model/auth/session_token.dart';
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
    try {
      final response = await _dio.post(
        OAuthConstants.exchangeTokenUri,
        data: {
          ApiRequestKeys.codeVerifier: codeVerifier,
          ApiRequestKeys.authorizationCode: authCode,
        },
      );

      // Conversion explicite en String
      final data = response.data as Map<String, dynamic>;

      return {
        ApiRequestKeys.accessToken:
            data[ApiRequestKeys.accessToken]?.toString() ?? '',
        ApiRequestKeys.refreshToken:
            data[ApiRequestKeys.refreshToken]?.toString() ?? '',
      };
    } catch (e) {
      rethrow;
    }
  }

  Future<SessionToken> login() async {
    final pkceCodes = await getAuthCodes();
    final codeChallenge = pkceCodes[ApiRequestKeys.codeChallenge]!;
    final codeVerifier = pkceCodes[ApiRequestKeys.codeVerifier]!;

    final googleAuthUrl = await getAuthUrl(codeChallenge);

    final result = await FlutterWebAuth2.authenticate(
      url: googleAuthUrl,
      callbackUrlScheme: OAuthConstants.urlScheme,
    );

    final uri = Uri.parse(result);
    String? authCode = uri.queryParameters['code'];

    if (authCode == null || authCode.isEmpty) {
      if (uri.fragment.isNotEmpty) {
        final fragmentParams = Uri.splitQueryString(uri.fragment);
        authCode = fragmentParams['code'];
      }
    }

    if (authCode == null || authCode.isEmpty) {
      throw Exception('Code d\'autorisation manquant');
    }

    final tokens = await exchangeTokens(codeVerifier, authCode);
    return SessionToken(
      accessToken: tokens[ApiRequestKeys.accessToken]!,
      refreshToken: tokens[ApiRequestKeys.refreshToken]!,
    );
  }
}
