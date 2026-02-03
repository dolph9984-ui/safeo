import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../model/auth/twofa_response.dart';
import '../../services/auth/two_fa_service.dart';

enum TwoFAMode {
  login,
  signup,
}

class TwoFAViewModel extends ChangeNotifier {
  final TwoFAService _twoFAService = TwoFAService();

  final String verificationToken;
  final TwoFAMode mode;

  TwoFAViewModel({
    required this.verificationToken,
    this.mode = TwoFAMode.login,
  }) {
    _startResendTimer();
  }

  String _code = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isResending = false;
  String? _email;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  String get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isResending => _isResending;
  bool get canSubmit => _code.length == 6 && !_isLoading;
  String? get email => _email;
  int get resendCountdown => _resendCountdown;
  bool get canResend => _resendCountdown == 0 && !_isResending;

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  void updateCode(String value) {
    _code = value;
    _clearError();
    notifyListeners();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    notifyListeners();

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        _resendCountdown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<TwoFAResponse?> verifyCode() async {
    if (_code.length != 6) {
      _errorMessage = 'Le code doit contenir 6 chiffres';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _clearError();

    try {
      final TwoFAResponse response;

      if (mode == TwoFAMode.signup) {
        response = await _twoFAService.verifySignupCode(
          code: _code,
          verificationToken: verificationToken,
        );
      } else {
        response = await _twoFAService.verifyLoginCode(
          code: _code,
          verificationToken: verificationToken,
        );
      }

      _setLoading(false);
      return response;

    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // Récupérer le message du serveur si disponible
      String? serverMessage;
      if (e.response?.data != null && e.response!.data is Map) {
        serverMessage = e.response!.data['message']?.toString();
      }

      // Debug
      if (kDebugMode) {
        print('Erreur 2FA verify: $e');
        print('Status Code: $statusCode');
        print('Server Message: $serverMessage');
      }

      // Définir le message d'erreur selon le code
      if (statusCode == 401 || statusCode == 400) {
        _errorMessage = serverMessage ?? 'Code invalide ou expiré';
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Délai de connexion dépassé';
      } else if (e.type == DioExceptionType.connectionError) {
        _errorMessage = 'Impossible de se connecter au serveur';
      } else {
        _errorMessage = serverMessage ?? 'Une erreur est survenue';
      }

      _setLoading(false);
      return null;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur inattendue verify: $e');
      }

      _errorMessage = 'Une erreur inattendue est survenue';
      _setLoading(false);
      return null;
    }
  }

  Future<bool> resendCode() async {
    if (!canResend) return false;

    _isResending = true;
    _clearError();

    try {
      if (mode == TwoFAMode.signup) {
        await _twoFAService.resendSignupCode(
          verificationToken: verificationToken,
        );
      } else {
        await _twoFAService.resendLoginCode(
          verificationToken: verificationToken,
        );
      }

      _isResending = false;
      _startResendTimer();
      notifyListeners();
      return true;

    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;

      // Récupérer le message du serveur si disponible
      String? serverMessage;
      if (e.response?.data != null && e.response!.data is Map) {
        serverMessage = e.response!.data['message']?.toString();
      }

      // Debug
      if (kDebugMode) {
        print('Erreur 2FA resend: $e');
        print('Status Code: $statusCode');
        print('Server Message: $serverMessage');
      }

      // Définir le message d'erreur selon le code
      if (statusCode == 401) {
        _errorMessage = serverMessage ?? 'Session expirée, veuillez vous reconnecter';
      } else if (statusCode == 429) {
        _errorMessage = serverMessage ?? 'Trop de tentatives, veuillez patienter';
      } else if (e.type == DioExceptionType.connectionTimeout ||
                 e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Délai de connexion dépassé';
      } else if (e.type == DioExceptionType.connectionError) {
        _errorMessage = 'Impossible de se connecter au serveur';
      } else {
        _errorMessage = serverMessage ?? 'Impossible de renvoyer le code';
      }

      _isResending = false;
      notifyListeners();
      return false;

    } catch (e) {
      if (kDebugMode) {
        print('Erreur inattendue resend: $e');
      }

      _errorMessage = 'Une erreur inattendue est survenue';
      _isResending = false;
      notifyListeners();
      return false;
    }
  }
}