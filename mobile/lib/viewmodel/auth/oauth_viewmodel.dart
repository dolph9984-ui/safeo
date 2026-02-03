import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:securite_mobile/model/auth/oauth_token_model.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';
import '../../constants/api_request_keys.dart';
import '../../constants/oauth_constants.dart';

class OAuthViewModel extends ChangeNotifier {
  final OAuthService _oAuthService = OAuthService();

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
      final pkceCodes = await _oAuthService.getAuthCodes();
      final codeChallenge = pkceCodes[ApiRequestKeys.codeChallenge]!;
      final codeVerifier = pkceCodes[ApiRequestKeys.codeVerifier]!;

      final googleAuthUrl = await _oAuthService.getAuthUrl(codeChallenge);

      final result = await FlutterWebAuth2.authenticate(
        url: googleAuthUrl,
        callbackUrlScheme: OAuthConstants.urlScheme,
      );

      final uri = Uri.parse(result);
      String? authCode = uri.queryParameters['code'];

      if (authCode == null || authCode.isEmpty) {
        if (uri.fragment.isNotEmpty) {
          final fragmentParams = Uri.splitQueryString(uri.fragment);
          authCode = fragmentParams['code'];
        }
      }

      if (authCode == null || authCode.isEmpty) {
        throw Exception('Code d\'autorisation manquant');
      }

      final tokens = await _oAuthService.exchangeTokens(
        codeVerifier,
        authCode,
      );

      await _oAuthService.storeTokens(
        OAuthToken(
          accessToken: tokens[ApiRequestKeys.accessToken]!,
          refreshToken: tokens[ApiRequestKeys.refreshToken]!,
        ),
      );

      _setLoading(false);
      return true;

    } on PlatformException catch (e) {
      _errorMessage = (e.code == 'CANCELED')
          ? 'Connexion annulée.'
          : 'Authentification échouée';

      _setLoading(false);
      return false;

    } catch (e) {
      _errorMessage = 'Authentification échouée.';
      _setLoading(false);
      return false;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}