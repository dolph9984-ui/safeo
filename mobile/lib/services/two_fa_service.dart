import 'package:dio/dio.dart';

class TwoFAService {
  //final Dio _dio;
  //TwoFAService(this._dio);

  //Simulates 2FA code validation
  Future<bool> verifyCode(String code) async {
    await Future.delayed(const Duration(seconds: 2)); // Network simulation

    if (code == '123456') {
      return true;
    }

    throw Exception('Invalid code');
  }

  // ✅ Simulates resending the 2FA code
  Future<bool> resendCode() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  //to be enabled later
  /*
  Future<bool> verifyCode(String code) async {
    try {
      final response = await _dio.post(
        '/api/auth/2fa/verify',
        data: {
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        // TODO: store token securely
        return true;
      }

      throw Exception('Invalid code');
    } on DioException catch (e) {
      throw Exception(
        e.response?.data['message'] ?? 'Verification error',
      );
    }
  }

  Future<bool> resendCode() async {
    try {
      final response = await _dio.post('/api/auth/2fa/resend');
      return response.statusCode == 200;
    } on DioException catch (_) {
      throw Exception('Unable to resend code');
    }
  }
  */
}
