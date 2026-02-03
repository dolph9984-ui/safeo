import 'package:dio/dio.dart';
import '../../model/auth/signup_credentials.dart';
import '../../model/auth/signup_response.dart';
import '../../utils/dio_util.dart';

class SignupService {
  final Dio _dio = DioClient.dio;

  Future<SignupResponse> sendOtp(SignupCredentials credentials) async {
    final response = await _dio.post(
      '/v1/api/auth/signup/send-otp',
      data: credentials.toJson(),
    );

    return SignupResponse.fromJson(response.data);
  }

}