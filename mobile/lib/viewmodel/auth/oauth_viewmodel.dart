import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:securite_mobile/main.dart'; // AJOUTEZ CETTE LIGNE
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';

class OAuthViewModel extends ChangeNotifier {
  final sessionModel = SessionModel();
  final userModel = UserModel();
  final _oAuthService = OAuthService();

  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  Future<bool> googleLogin({required String context}) async {
    _setLoading(true);
    _clearError();

    try {
      final token = await _oAuthService.login();
      final userResponse = await userModel.getUserFromServer();

      await sessionModel.createSession(
        userResponse.data?.first ?? User.none(),
        token,
      );
      return true;
    } on PlatformException catch (e) {
      _errorMessage = (e.code == 'CANCELED')
          ? 'Connexion annulée.'
          : 'Authentification échouée';

      _setLoading(false);
      return false;
    } catch (e) {
      _errorMessage = 'Authentification échouée.';
      return false;
    } finally {
      _setLoading(false);
    }
  }
}