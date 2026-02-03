class SignupCredentials {
  final String email;
  final String fullName;
  final String password;

  SignupCredentials({
    required this.email,
    required this.fullName,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'fullName': fullName,
      'password': password,
    };
  }
}