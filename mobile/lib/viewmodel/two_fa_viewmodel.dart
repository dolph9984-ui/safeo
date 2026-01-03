import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/services/two_fa_service.dart';

class TwoFAViewModel extends ChangeNotifier {
  final TwoFAService _service = TwoFAService();

  String _code = '';
  String? _errorMessage;
  bool _isLoading = false;
  int _timerSeconds = 60;
  bool _canResend = false;
  Timer? _timer;


  String get code => _code;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  int get timerSeconds => _timerSeconds;
  bool get canResend => _canResend;
  bool get canSubmit => _code.length == 6 && !_isLoading;

  void updateCode(String value) {
    if (value.length <= 6) {
      _code = value;
      _clearError();
      notifyListeners();
    }
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void startTimer() {
    _canResend = false;
    _timerSeconds = 60;
    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        _timerSeconds--;
        notifyListeners();
      } else {
        _canResend = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Future<bool> submit() async {
    if (!canSubmit) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await _service.verifyCode(_code);
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = 'Code invalide. Veuillez réessayer.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resend() async {
    if (!_canResend) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _service.resendCode();
      _isLoading = false;
      startTimer(); // Redémarre le timer
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Erreur lors du renvoi';
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}