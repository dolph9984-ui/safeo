import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/services/auth/form_auth_service.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final model = SessionModel();
  final _formAuthService = FormAuthService();

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;

  String get email => _email;

  String get password => _password;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get canSubmit =>
      _email.isNotEmpty && _password.isNotEmpty && !_isLoading;

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

  void updateEmail(String value) {
    _email = value.trim().toLowerCase();
    _clearError();
    notifyListeners();
  }

  void updatePassword(String value) {
    _password = value;
    _clearError();
    notifyListeners();
  }

  Future<CredentialLoginResponse?> submit() async {
    if (!canSubmit) {
      _errorMessage = 'Veuillez remplir tous les champs';
      notifyListeners();
      return null;
    }

    _setLoading(true);
    _clearError();

    try {
      return await _formAuthService.login(
        LoginCredentials(email: _email, password: _password),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      final serverMessage = e.response?.data is Map
          ? e.response?.data['message']?.toString()
          : null;

      if (kDebugMode) {
        print('Login error | code=$code | type=${e.type}');
      }

      switch (code) {
        case 400:
          _errorMessage = serverMessage ?? 'Veuillez saisir un email valide';
          break;
        case 401:
          _errorMessage = serverMessage ?? 'Mot de passe incorrect';
          break;
        case 404:
          _errorMessage = serverMessage ?? 'Aucun compte trouvé avec cet email';
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
