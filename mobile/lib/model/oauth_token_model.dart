class OAuthToken {
  final String accessToken;
  final String refreshToken;
  final DateTime expiry;

  OAuthToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiry,
  });
}

class OAuthTokenModel {}
