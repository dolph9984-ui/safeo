class CredentialLoginResponse {
  final int statusCode;
  final String verificationToken;
  final String message;

  CredentialLoginResponse({
    required this.statusCode,
    required this.verificationToken,
    required this.message,
  });

  factory CredentialLoginResponse.fromJson(Map<String, dynamic> json) {
    return CredentialLoginResponse(
      statusCode: json['statusCode'] ?? 200,
      verificationToken: json['verificationToken'],
      message: json['message'],
    );
  }
}
