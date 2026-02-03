import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../model/auth/signup_credentials.dart';
import '../../model/auth/signup_response.dart';
import '../../services/auth/signup_service.dart';

class SignupViewModel extends ChangeNotifier {
  final SignupService _signupService = SignupService();

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

  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void updateEmail(String v) {
    _email = v.trim();
    _emailError = _email.isEmpty
        ? null
        : RegExp(r'^[^@]+@[^@]+\.[^@]+$').hasMatch(_email)
            ? null
            : 'Email invalide';
    _clearError();
    notifyListeners();
  }

  void updateFullName(String v) {
    _fullName = v.trim();
    _fullNameError =
        _fullName.isEmpty || _fullName.length >= 3 ? null : 'Nom trop court';
    _clearError();
    notifyListeners();
  }

  void updatePassword(String v) {
    _password = v;
    _passwordError = _validatePassword(v);
    if (_confirmPassword.isNotEmpty) {
      _confirmPasswordError =
          _confirmPassword == _password ? null : 'Les mots de passe ne correspondent pas';
    }
    _clearError();
    notifyListeners();
  }

  void updateConfirmPassword(String v) {
    _confirmPassword = v;
    _confirmPasswordError =
        v.isEmpty || v == _password ? null : 'Les mots de passe ne correspondent pas';
    _clearError();
    notifyListeners();
  }

  String? _validatePassword(String v) {
    if (v.isEmpty) return null;
    if (v.length < 8) return 'Minimum 8 caractères';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Une majuscule requise';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Une minuscule requise';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Un chiffre requis';
    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(v)) {
      return 'Un caractère spécial requis';
    }
    return null;
  }

  Future<SignupResponse?> submit() async {
    if (!canSubmit) return null;

    _setLoading(true);
    _clearError();

    try {
      return await _signupService.sendOtp(
        SignupCredentials(
          email: _email,
          fullName: _fullName,
          password: _password,
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final serverMessage =
          e.response?.data is Map ? e.response?.data['message']?.toString() : null;

      if (kDebugMode) {
        print('Signup error | code=$code | type=${e.type}');
      }

      switch (code) {
        case 409:
          _errorMessage = serverMessage ??
              'Un compte avec cette adresse email existe déjà';
          break;
        default:
          _errorMessage = e.type == DioExceptionType.connectionError
              ? 'Problème réseau'
              : 'Une erreur est survenue';
      }
      return null;
    } catch (e) {
      if (kDebugMode) print('Erreur inattendue: $e');
      _errorMessage = 'Une erreur inattendue est survenue';
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
