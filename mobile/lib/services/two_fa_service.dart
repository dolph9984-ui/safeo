class TwoFAService {
  // Simule la validation du code 2FA et retourne true si succès (reçoit JWT)
  Future<bool> verifyCode(String code) async {
    await Future.delayed(const Duration(seconds: 2)); // Simulation réseau

    if (code == '123456') {
      return true;
    }

    throw Exception('Code invalide');
  }

  // Simule le renvoi du code 
  Future<bool> resendCode() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  // plus tard :
  /*
  Future<bool> verifyCode(String code) async {
    final response = await http.post(
      Uri.parse('https://ton-api.com/api/auth/2fa/verify'),
      body: {'code': code},
    );
    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      // Stocker token
      return true;
    }
    throw Exception('Code invalide');
  }
  */
}