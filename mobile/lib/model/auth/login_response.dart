class LoginResponse {
  final int statusCode;
  final String verificationToken;
  final String message;

  LoginResponse({
    required this.statusCode,
    required this.verificationToken,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      statusCode: json['statusCode'] ?? 200,
      verificationToken: json['verificationToken'],
      message: json['message'],
    );
  }
}
