import 'package:dio/dio.dart';
import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class FormAuthService {
  final Dio _dio = DioClient.dio;

  Future<LoginResponse> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/login',
        data: credentials.toJson(),
      );

      if (response.statusCode == 200) {
        return LoginResponse.fromJson(response.data);
      }

      throw Exception('Erreur de connexion');
    } on DioException catch (e) {
      String message = 'Erreur réseau';

      if (e.response != null) {
        final status = e.response!.statusCode;

        if (status == 401) {
          message = 'Mot de passe incorrect';
        } else if (status == 404) {
          message = 'Aucun utilisateur trouvé avec cet email';
        } else {
          message = e.response?.data['message'] ?? 'Erreur inconnue';
        }
      }

      throw Exception(message);
    }
  }
}
