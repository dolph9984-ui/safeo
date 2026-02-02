// lib/viewmodel/auth/signup_viewmodel.dart

import 'package:flutter/material.dart';
import '../../model/auth/signup_credentials.dart';
import '../../model/auth/signup_response.dart';
import '../../services/auth/signup_service.dart';
import '../../services/security/audit_service.dart'; // ✅ AJOUTER

class SignupViewModel extends ChangeNotifier {
  final SignupService _signupService = SignupService();
  final AuditService _audit = AuditService(); // ✅ AJOUTER

  String _email = '';
  String _fullName = '';
  String _password = '';
  String _confirmPassword = '';

  bool _isLoading = false;
  String? _emailError;
  String? _fullNameError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _errorMessage;

  String get email => _email;
  String get fullName => _fullName;
  String get password => _password;
  String get confirmPassword => _confirmPassword;

  bool get isLoading => _isLoading;
  String? get emailError => _emailError;
  String? get fullNameError => _fullNameError;
  String? get passwordError => _passwordError;
  String? get confirmPasswordError => _confirmPasswordError;
  String? get errorMessage => _errorMessage;

  bool get canSubmit =>
      _email.isNotEmpty &&
      _fullName.isNotEmpty &&
      _password.isNotEmpty &&
      _confirmPassword.isNotEmpty &&
      _password == _confirmPassword &&
      !_isLoading &&
      _emailError == null &&
      _fullNameError == null &&
      _passwordError == null &&
      _confirmPasswordError == null;

  void updateEmail(String value) {
    _email = value.trim();
    _emailError = _validateEmail(value);
    _errorMessage = null;
    notifyListeners();
  }

  void updateFullName(String value) {
    _fullName = value.trim();
    _fullNameError = _validateFullName(value);
    _errorMessage = null;
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    _passwordError = _validatePassword(value);
    if (_confirmPassword.isNotEmpty) {
      _confirmPasswordError = _validateConfirmPassword(_confirmPassword);
    }
    _errorMessage = null;
    notifyListeners();
  }

  void updateConfirmPassword(String value) {
    _confirmPassword = value;
    _confirmPasswordError = _validateConfirmPassword(value);
    _errorMessage = null;
    notifyListeners();
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) return null;

    // Regex plus stricte
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Email invalide';
    }

    return null;
  }


  String? _validateFullName(String value) {
    if (value.isEmpty) return null;
    if (value.length < 3) {
      return 'Le nom doit contenir au moins 3 caractères';
    }
    return null;
  }

  String? _validatePassword(String value) {
    if (value.isEmpty) return null;
    if (value.length < 8) {
      return 'Minimum 8 caractères';
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Une majuscule requise';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Une minuscule requise';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Un chiffre requis';
    }
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Un caractère spécial requis';
    }
    return null;
  }


  String? _validateConfirmPassword(String value) {
    if (value.isEmpty) return null;
    if (value != _password) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<SignupResponse?> submit() async {
    if (!canSubmit) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credentials = SignupCredentials(
        email: _email,
        fullName: _fullName,
        password: _password,
      );

      final response = await _signupService.sendOtp(credentials);

      // ✅ AUDIT : Inscription initiée
      await _audit.logSecurityEvent(
        event: 'SIGNUP_INITIATED',
        userId: _email,
        details: 'Code OTP envoyé pour inscription',
      );

      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');

      // ✅ AUDIT : Échec inscription
      await _audit.logSecurityEvent(
        event: 'SIGNUP_FAILED',
        userId: _email,
        details: _errorMessage,
      );

      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}