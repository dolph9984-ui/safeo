import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:securite_mobile/model/auth/oauth_token_model.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';
import '../../constants/api_request_keys.dart';
import '../../constants/oauth_constants.dart';
import '../../services/security/audit_service.dart';

class OAuthViewModel extends ChangeNotifier {
  final OAuthService _oAuthService = OAuthService();
  final AuditService _audit = AuditService();

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
      // PKCE codes
      final pkceCodes = await _oAuthService.getAuthCodes();
      final codeChallenge = pkceCodes[ApiRequestKeys.codeChallenge]!;
      final codeVerifier = pkceCodes[ApiRequestKeys.codeVerifier]!;

      // Obtenir l'URL Google Auth
      final googleAuthUrl = await _oAuthService.getAuthUrl(codeChallenge);

      // Ouvrir le navigateur et récupérer le code
      final result = await FlutterWebAuth2.authenticate(
        url: googleAuthUrl,
        callbackUrlScheme: OAuthConstants.urlScheme,
      );

      // Extraction du code
      final code = Uri.parse(result).queryParameters[ApiRequestKeys.authorizationCode];
      
      if (code == null) {
        throw Exception('Code d\'autorisation manquant');
      }

      // Échanger et stocker les tokens
      final tokens = await _oAuthService.exchangeTokens(codeVerifier, code);
      await _oAuthService.storeTokens(
        OAuthToken(
          accessToken: tokens[ApiRequestKeys.accessToken]!,
          refreshToken: tokens[ApiRequestKeys.refreshToken]!,
        ),
      );

      // ✅ Log succès OAuth
      await _audit.logSecurityEvent(
        event: 'OAUTH_SUCCESS',
        userId: 'OAuth Google',
        details: 'Authentification réussie via Google - Context: $context',
      );

      _setLoading(false);
      return true;

    } on PlatformException catch (e) {
      _errorMessage = (e.code == 'CANCELED')
          ? 'Connexion annulée.'
          : 'Authentification échouée. Veuillez réessayer.';

      await _audit.logSecurityEvent(
        event: 'OAUTH_FAILED',
        userId: 'OAuth Google',
        details: 'Code: ${e.code} - Message: ${e.message} - Context: $context',
      );

      _setLoading(false);
      return false;

    } catch (e) {
      _errorMessage = 'Une erreur est survenue lors de l\'authentification.';

      await _audit.logSecurityEvent(
        event: 'OAUTH_ERROR',
        userId: 'OAuth Google',
        details: '${e.toString()} - Context: $context',
      );

      _setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}