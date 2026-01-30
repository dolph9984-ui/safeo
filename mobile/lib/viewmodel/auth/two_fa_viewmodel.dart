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
  });

  String _code = '';
  bool _isLoading = false;
  String? _errorMessage;
  bool _isResending = false;
  String? _email; // 👈 AJOUTÉ : stockage de l'email

  // Getters
  String get code => _code;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isResending => _isResending;
  bool get canSubmit => _code.length == 6 && !_isLoading;
  String? get email => _email; // 👈 AJOUTÉ : getter pour l'email

  // 👇 AJOUTÉ : Méthode pour définir l'email
  void setEmail(String? email) {
    _email = email;
    notifyListeners();
  }

  // Update code
  void updateCode(String value) {
    _code = value;
    _errorMessage = null;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Vérifier le code OTP
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
      
      // Appeler la bonne méthode selon le mode
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

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Renvoyer le code OTP
  Future<bool> resendCode() async {
    _isResending = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Appeler la bonne méthode selon le mode
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