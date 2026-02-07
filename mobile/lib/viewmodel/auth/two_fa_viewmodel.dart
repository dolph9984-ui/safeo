import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/auth/session_token.dart';
import '../../model/auth/twofa_response.dart';
import '../../services/auth/two_fa_service.dart';
import '../../services/security/secure_storage_service.dart';

enum TwoFAMode { login, signup }

class TwoFAViewModel extends ChangeNotifier {
  final TwoFAService _twoFAService;

  final String verificationToken;
  final TwoFAMode mode;

  TwoFAViewModel({
    required this.verificationToken,
    this.mode = TwoFAMode.login,
    TwoFAService? twoFAService,
    SecureStorageService? storage,
  }) : _twoFAService = twoFAService ?? TwoFAService() {
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

  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  void updateCode(String value) {
    _code = value;
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
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

  Future<bool> verifyAndPersist() async {
    if (_code.length != 6) {
      _errorMessage = 'Le code doit contenir 6 chiffres';
      notifyListeners();
      return false;
    }

    _setLoading(true);

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

      await SessionTokenModel.storeTokens(
        SessionToken(
          accessToken: response.accessToken,
          refreshToken: response.refreshToken,
        ),
      );
      _setLoading(false);
      return true;
    } on DioException catch (e) {
      final statusCode = e.response?.statusCode;
      final serverMessage = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;

      if (statusCode == 400 || statusCode == 401) {
        _errorMessage = serverMessage ?? 'Code invalide ou expiré';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Délai de connexion dépassé';
      } else {
        _errorMessage = 'Erreur réseau';
      }

      _setLoading(false);
      return false;
    } catch (_) {
      _errorMessage = 'Erreur inattendue';
      _setLoading(false);
      return false;
    }
  }

  Future<bool> resendCode() async {
    if (!canResend) return false;

    _isResending = true;
    notifyListeners();

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
      return true;
    } catch (_) {
      _errorMessage = 'Impossible de renvoyer le code';
      _isResending = false;
      notifyListeners();
      return false;
    }
  }
}
