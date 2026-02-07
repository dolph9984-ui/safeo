import 'package:dio/dio.dart';
import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class FormAuthService {
  final Dio _dio = DioClient.dio;

  Future<CredentialLoginResponse> login(LoginCredentials credentials) async {
    final response = await _dio.post(
      '/v1/api/auth/login',
      data: credentials.toJson(),
    );

    return CredentialLoginResponse.fromJson(response.data);
  }
}