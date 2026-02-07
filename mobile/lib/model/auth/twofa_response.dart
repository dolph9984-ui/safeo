class TwoFAResponse {
  final int statusCode;
  final String message;
  final String accessToken;
  final String refreshToken; 

  TwoFAResponse({
    required this.statusCode,
    required this.message,
    required this.accessToken,
    required this.refreshToken, 
  });

  factory TwoFAResponse.fromJson(Map<String, dynamic> json) {
    return TwoFAResponse(
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '', 
    );
  }
}