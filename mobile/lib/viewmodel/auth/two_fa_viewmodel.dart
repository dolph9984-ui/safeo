// lib/viewmodel/auth/two_fa_viewmodel.dart

import 'package:flutter/material.dart';
import '../../model/auth/twofa_response.dart';
import '../../services/auth/two_fa_service.dart';
import '../../services/security/audit_service.dart'; // ✅ AJOUTER

enum TwoFAMode {
  login,
  signup,
}

class TwoFAViewModel extends ChangeNotifier {
  final TwoFAService _twoFAService = TwoFAService();
  final AuditService _audit = AuditService(); // ✅ AJOUTER
  
  final String verificationToken;
  final TwoFAMode mode;

  TwoFAViewModel({
    required this.verificationToken,
    this.mode = TwoFAMode.login,
  });

  String _code = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isResending = false;
  String? _email;

  String get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isResending => _isResending;
  bool get canSubmit => _code.length == 6 && !_isLoading;
  String? get email => _email;

  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  void updateCode(String value) {
    _code = value;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<TwoFAResponse?> verifyCode() async {
    if (_code.length != 6) {
      _errorMessage = 'Le code doit contenir 6 chiffres';
      notifyListeners();
      return null;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final TwoFAResponse response;
      
      if (mode == TwoFAMode.signup) {
        response = await _twoFAService.verifySignupCode(
          code: _code,
          verificationToken: verificationToken,
        );

        // ✅ AUDIT : Signup 2FA réussi
        await _audit.logSecurityEvent(
          event: 'SIGNUP_2FA_SUCCESS',
          userId: _email ?? 'unknown',
          details: 'Code OTP vérifié - Inscription complétée',
        );
      } else {
        response = await _twoFAService.verifyLoginCode(
          code: _code,
          verificationToken: verificationToken,
        );

        // ✅ AUDIT : Login 2FA réussi
        // 2FA réussi
        await _audit.logSecurityEvent(
          event: '2FA_SUCCESS',
          userId: _email ?? 'unknown',
          details: 'Code OTP vérifié - Authentification réussie',
        );
      }

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // ✅ AUDIT : 2FA échoué
      await _audit.logSecurityEvent(
        event: '2FA_FAILED',
        userId: _email ?? 'unknown',
        details: 'Code OTP incorrect ou expiré',
      );

      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<bool> resendCode() async {
    _isResending = true;
    _errorMessage = null;
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

      // ✅ AUDIT : Code renvoyé
      await _audit.logSecurityEvent(
        event: '2FA_CODE_SENT',
        userId: _email ?? 'unknown',
        details: 'Code 2FA renvoyé par email',
        metadata: {
          'method': 'email',
        },
      );


      _isResending = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isResending = false;
      notifyListeners();
      return false;
    }
  }
}