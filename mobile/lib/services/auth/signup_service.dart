import 'package:dio/dio.dart';
import '../../model/auth/signup_credentials.dart';
import '../../model/auth/signup_response.dart';
import '../../utils/dio_client.dart';

class SignupService {
  final Dio _dio = DioClient.dio;

  /// Envoyer le code OTP pour l'inscription
  Future<SignupResponse> sendOtp(SignupCredentials credentials) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/signup/send-otp',
        data: credentials.toJson(),
      );

      if (response.statusCode == 200) {
        return SignupResponse.fromJson(response.data);
      }

      throw Exception('Erreur lors de l\'inscription');
    } on DioException catch (e) {
      String message = 'Erreur réseau';

      if (e.response != null) {
        final status = e.response!.statusCode;

        if (status == 409) {
          message = 'Un compte avec cette adresse email existe déjà';
        } else if (status == 400) {
          message = e.response?.data['message'] ?? 'Données invalides';
        } else {
          message = e.response?.data['message'] ?? 'Erreur inconnue';
        }
      }

      throw Exception(message);
    }
  }

  /// Vérifier le code OTP et finaliser l'inscription
  Future<Map<String, dynamic>> verifyOtp({
    required String code,
    required String verificationToken,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/signup/verify-otp',
        data: {
          'code': code,
          'verificationToken': verificationToken,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      }

      throw Exception('Erreur de vérification');
    } on DioException catch (e) {
      String message = 'Erreur réseau';

      if (e.response != null) {
        final status = e.response!.statusCode;

        if (status == 401 || status == 400) {
          message = 'Code OTP invalide ou expiré';
        } else {
          message = e.response?.data['message'] ?? 'Erreur inconnue';
        }
      }

      throw Exception(message);
    }
  }
}