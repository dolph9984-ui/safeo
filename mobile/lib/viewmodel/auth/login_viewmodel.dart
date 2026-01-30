import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/services/auth/form_auth_service.dart';

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




  bool get canSubmit {
    return _email.isNotEmpty &&
        _password.isNotEmpty &&
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

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<LoginResponse?> submit() async {
    if (!canSubmit) return null;

    setLoading(true);

    try {
      final credentials = LoginCredentials(email: _email, password: _password);

      final response = await _authService.login(credentials);

      setLoading(false);
      return response; //verificationToken
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      setLoading(false);
      return null;
    }
  }
}