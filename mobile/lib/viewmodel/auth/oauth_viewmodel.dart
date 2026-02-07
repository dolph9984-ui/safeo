import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:securite_mobile/model/user_model.dart';

class OAuthViewModel extends ChangeNotifier {
  final model = UserModel();

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
      await model.loginWithOAuth();
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
