import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/services/auth/form_auth_service.dart';
import 'package:securite_mobile/services/security/audit_service.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class LoginViewModel extends ChangeNotifier {
  final FormAuthService _authService = FormAuthService();
  final AuditService _audit = AuditService();
  final SecureStorageService _storage = SecureStorageService();

  static const int _maxAttempts = 5;
  static const Duration _lockoutDuration = Duration(minutes: 5);

  String _email = '';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  String get email => _email;
  String get password => _password;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get canSubmit => _email.isNotEmpty && _password.isNotEmpty && !_isLoading;

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

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ────────────────────────────────────────────────────────────
  // Rate Limiting PERSISTANT
  // ────────────────────────────────────────────────────────────
  String get _failedAttemptsKey => 'rate_limit_failed_$_email';
  String get _lastAttemptKey => 'rate_limit_last_$_email';

  Future<int> _getFailedAttempts() async {
    try {
      final value = await _storage.read(_failedAttemptsKey);
      return value != null ? int.tryParse(value) ?? 0 : 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> _setFailedAttempts(int attempts) async {
    try {
      if (attempts <= 0) {
        await _storage.delete(_failedAttemptsKey);
      } else {
        await _storage.write(_failedAttemptsKey, attempts.toString());
      }
    } catch (e) {
      print('⚠️ Erreur sauvegarde tentatives: $e');
    }
  }

  Future<DateTime?> _getLastAttemptTime() async {
    try {
      final value = await _storage.read(_lastAttemptKey);
      return value != null ? DateTime.tryParse(value) : null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _setLastAttemptTime(DateTime time) async {
    try {
      await _storage.write(_lastAttemptKey, time.toIso8601String());
    } catch (e) {
      print('⚠️ Erreur sauvegarde timestamp: $e');
    }
  }

  Future<bool> _isAccountLocked() async {
    final attempts = await _getFailedAttempts();
    if (attempts < _maxAttempts) return false;

    final last = await _getLastAttemptTime();
    if (last == null) return false;

    return DateTime.now().difference(last) < _lockoutDuration;
  }

  Future<Duration?> getRemainingLockoutTime() async {
    final last = await _getLastAttemptTime();
    if (last == null) return null;

    final elapsed = DateTime.now().difference(last);
    return elapsed >= _lockoutDuration ? null : _lockoutDuration - elapsed;
  }

  // ────────────────────────────────────────────────────────────
  // Login
  // ────────────────────────────────────────────────────────────
  Future<LoginResponse?> submit() async {
    if (_email.isEmpty || _password.isEmpty) {
      _errorMessage = 'Veuillez remplir tous les champs';
      notifyListeners();
      return null;
    }

    setLoading(true);
    _clearError();

    // Vérification lockout
    if (await _isAccountLocked()) {
      final remaining = await getRemainingLockoutTime();
      _errorMessage = 'Trop de tentatives échouées.\nRéessayez dans ${remaining!.inMinutes}m ${remaining.inSeconds % 60}s';
      setLoading(false);
      notifyListeners();
      await _audit.logAccountLockout(_email);
      return null;
    }

    try {
      final response = await _authService.login(
        LoginCredentials(email: _email, password: _password)
      );

      // SUCCÈS : Reset rate limiting
      await _setFailedAttempts(0);
      await _setLastAttemptTime(DateTime.now());
      await _audit.logLogin(_email);

      setLoading(false);
      return response;

    } catch (e) {
      final statusCode = e is DioException && e.response != null
          ? e.response!.statusCode ?? 500
          : 500;

      final rawError = (e is DioException && e.response != null
          ? e.response!.data['message']?.toString()
          : e.toString().replaceFirst('Exception: ', '').trim()) ?? '';

      final lowerError = rawError.toLowerCase();

      // Cas sans incrémentation (email invalide/inexistant)
      final noIncrement = [400, 404].contains(statusCode) ||
          ['utilisateur inexistant', 'user not found', 'aucun utilisateur',
           'compte inexistant', 'not found', 'unknown user',
           'email not registered', 'email must be an email',
           'invalid email format', 'email invalide']
              .any((msg) => lowerError.contains(msg));

      if (noIncrement) {
        _errorMessage = lowerError.contains('email must be an email') ||
                       lowerError.contains('email invalide') ||
                       lowerError.contains('invalid email format')
            ? 'Veuillez saisir un email valide'
            : 'Aucun compte trouvé avec cet email';
        setLoading(false);
        notifyListeners();
        return null;
      }

      // Incrémentation des tentatives
      final currentAttempts = await _getFailedAttempts();
      final newAttempts = currentAttempts + 1;
      await _setFailedAttempts(newAttempts);
      await _setLastAttemptTime(DateTime.now());
      await _audit.logFailedLogin(_email);

      if (newAttempts >= _maxAttempts) {
        _errorMessage = 'Compte verrouillé après $_maxAttempts tentatives échouées.\nRéessayez dans 5 minutes.';
        await _audit.logAccountLockout(_email);
      } else {
        final remaining = _maxAttempts - newAttempts;
        _errorMessage = 'Mot de passe incorrect\n$remaining tentative${remaining > 1 ? 's' : ''} restante${remaining > 1 ? 's' : ''}';
      }

      setLoading(false);
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
