class LoginCredentials {
  final String _email;
  final String _password;

  LoginCredentials({
    required String email,
    required String password,
  })  : _email = email.trim().toLowerCase(),
        _password = password;

  String get email => _email;
  String get password => _password;

  Map<String, dynamic> toJson() {
    return {
      'email': _email,
      'password': _password,
    };
  }

}