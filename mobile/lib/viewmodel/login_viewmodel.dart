import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/login_credentials.dart';
import 'package:securite_mobile/services/form_auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FormAuthService _authService = FormAuthService();

  String _email = '';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;

  String? get emailError {
    if (_email.isEmpty) return null;
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(_email) ? null : 'Email invalide';
  }

  String? get passwordError {
    if (_password.isEmpty) return null;
    return _password.length >= 6 ? null : 'Minimum 6 caractères';
  }

  bool get canSubmit {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
        emailError == null &&
        passwordError == null &&
        !_isLoading;
  }

  void updateEmail(String value) {
    _email = value.trim().toLowerCase();
    _clearServerError();
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    _clearServerError();
    notifyListeners();
  }

  void _clearServerError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Méthode publique pour contrôler le loading depuis la View (OAuth)
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;

    setLoading(true);

    try {
      final credentials = LoginCredentials(email: _email, password: _password);
      final success = await _authService.login(credentials);

      setLoading(false);
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return false;
    }
  }
}