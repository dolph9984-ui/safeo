class SignupResponse {
  final int statusCode;
  final String message;
  final String verificationToken;

  SignupResponse({
    required this.statusCode,
    required this.message,
    required this.verificationToken,
  });

  factory SignupResponse.fromJson(Map<String, dynamic> json) {
    return SignupResponse(
      statusCode: json['statusCode'] ?? 200,
      message: json['message'] ?? '',
      verificationToken: json['verificationToken'] ?? '',
    );
  }
}