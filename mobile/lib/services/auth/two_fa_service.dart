// lib/services/two_fa_service.dart

import 'package:dio/dio.dart';
import 'package:securite_mobile/model/auth/twofa_response.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class TwoFAService {
  final Dio _dio = DioClient.dio;

  /// Vérifie le code OTP pour le LOGIN
  Future<TwoFAResponse> verifyLoginCode({
    required String code,
    required String verificationToken,
  }) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/login/verify-otp',
        data: {
          'code': code,
          'verificationToken': verificationToken,
        },
      );

      // ✅ CORRECTION ICI
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TwoFAResponse.fromJson(response.data);
      }

      throw Exception('Code invalide');
    } on DioException catch (e) {
      String message = 'Erreur réseau';
      if (e.response != null && e.response!.statusCode == 401) {
        message = 'Code invalide ou expiré';
      } else if (e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      }
      throw Exception(message);
    }
  }

  /// Vérifie le code OTP pour le SIGNUP
  Future<TwoFAResponse> verifySignupCode({
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

      // ✅ CORRECTION ICI
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TwoFAResponse.fromJson(response.data);
      }

      throw Exception('Code invalide');
    } on DioException catch (e) {
      String message = 'Erreur réseau';
      if (e.response != null && e.response!.statusCode == 401) {
        message = 'Code invalide ou expiré';
      } else if (e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      }
      throw Exception(message);
    }
  }

  /// Renvoyer le code OTP pour le LOGIN
  Future<void> resendLoginCode({required String verificationToken}) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/login/resend-otp',
        data: {'verificationToken': verificationToken},
      );

      if (response.statusCode != 200) {
        throw Exception('Impossible de renvoyer le code');
      }
    } on DioException catch (e) {
      String message = 'Erreur réseau';
      if (e.response != null && e.response!.statusCode == 401) {
        message = 'Session expirée, veuillez vous reconnecter';
      } else if (e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      }
      throw Exception(message);
    }
  }

  /// Renvoyer le code OTP pour le SIGNUP
  Future<void> resendSignupCode({required String verificationToken}) async {
    try {
      final response = await _dio.post(
        '/v1/api/auth/signup/resend-otp',
        data: {'verificationToken': verificationToken},
      );

      if (response.statusCode != 200) {
        throw Exception('Impossible de renvoyer le code');
      }
    } on DioException catch (e) {
      String message = 'Erreur réseau';
      if (e.response != null && e.response!.statusCode == 401) {
        message = 'Session expirée, veuillez vous reconnecter';
      } else if (e.response?.data['message'] != null) {
        message = e.response!.data['message'];
      }
      throw Exception(message);
    }
  }
}