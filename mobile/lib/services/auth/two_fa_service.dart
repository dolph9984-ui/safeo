import 'package:dio/dio.dart';
import 'package:securite_mobile/model/auth/twofa_response.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class TwoFAService {
  final Dio _dio = DioClient.dio;

  Future<TwoFAResponse> verifyLoginCode({
    required String code,
    required String verificationToken,
  }) async {
    final response = await _dio.post(
      '/v1/api/auth/login/verify-otp',
      data: {
        'code': code,
        'verificationToken': verificationToken,
      },
    );

    return TwoFAResponse.fromJson(response.data);
  }

  Future<TwoFAResponse> verifySignupCode({
    required String code,
    required String verificationToken,
  }) async {
    final response = await _dio.post(
      '/v1/api/auth/signup/verify-otp',
      data: {
        'code': code,
        'verificationToken': verificationToken,
      },
    );

    return TwoFAResponse.fromJson(response.data);
  }

  Future<String> refreshAccessToken({required String refreshToken}) async {
    final response = await _dio.post(
      '/v1/api/auth/refresh-access-token',
      data: {'refreshToken': refreshToken},
    );

    return response.data['accessToken'] as String;
  }
  
  Future<void> resendLoginCode({required String verificationToken}) async {
    await _dio.post(
      '/v1/api/auth/login/resend-otp',
      data: {'verificationToken': verificationToken},
    );
  }

  Future<void> resendSignupCode({required String verificationToken}) async {
    await _dio.post(
      '/v1/api/auth/signup/resend-otp',
      data: {'verificationToken': verificationToken},
    );
  }
}