class OAuthConstants {
  static final clientID = 'app-safeo';
  static final redirectURI = 'safeo://auth-callback';

  static final pkceGeneratorUri = '/v1/api/oauth/pkce-generator';
  static final getGoogleAuthUri = '/v1/api/oauth/google/authorize-url';
  static final exchangeTokenUri = '/v1/api/oauth/google/exchange-token';
}
