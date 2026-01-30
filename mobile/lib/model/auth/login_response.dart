class LoginResponse {
  final String verificationToken;
  final String message;

  LoginResponse({
    required this.verificationToken,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      verificationToken: json['verificationToken'],
      message: json['message'],
    );
  }
}
