import 'package:dio/dio.dart';
import 'package:securite_mobile/model/login_credentials.dart';

class FormAuthService {
  //final Dio _dio;
  //FormAuthService(this._dio);

  // ✅ Simulates a login network call
  Future<bool> login(LoginCredentials credentials) async {
    // Network simulation
    await Future.delayed(const Duration(seconds: 2));

    // Valid test credentials
    const validEmail = 'test@gmail.com';
    const validPassword = 'password';

    if (credentials.email == validEmail &&
        credentials.password == validPassword) {
      // Token would be stored here later
      return true;
    }

    throw Exception('Email ou mot de passe incorrect');
  }

  // to be used 
  /*
  Future<bool> login(LoginCredentials credentials) async {
    try {
      final response = await _dio.post(
        '/api/auth/login', // Relative endpoint (baseUrl already defined)
        data: credentials.toJson(),
      );

      if (response.statusCode == 200) {
        // The backend can:
        // - Return a token directly (login without 2FA)
        // - Or indicate that 2FA is required (current flow)
        final data = response.data;

        if (data['requires2FA'] == true) {
          return true; // → frontend navigates to the 2FA screen
        }

        // If a token is returned directly
        // final token = data['token'];
        // await FlutterSecureStorage().write(key: 'jwt_token', value: token);
        return true;
      } else {
        throw Exception('Erreur de connexion');
      }
    } on DioException catch (e) {
      // Proper Dio error handling
      String message = 'Erreur réseau';
      if (e.response != null) {
        message =
            e.response?.data['message'] ?? 'Email ou mot de passe incorrect';
      }
      throw Exception(message);
    }
  }
  */
}
