import 'package:securite_mobile/model/login_credentials.dart';

class FormAuthService {
  Future<bool> login(LoginCredentials credentials) async {
    // Simulation d'un appel réseau
    await Future.delayed(const Duration(seconds: 2));

    // Credentials de test valides
    const validEmail = 'test@gmail.com';
    const validPassword = 'password';

    if (credentials.email == validEmail && credentials.password == validPassword) {
      // Pour stocker le token reçu
      return true;
    }

    throw Exception('Email ou mot de passe incorrect');
  }

  // A utiliser quand le backend sera prêt
  /*
  Future<bool> login(LoginCredentials credentials) async {
    final response = await http.post(
      Uri.parse('https://ton-api.com/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(credentials.toJson()),
    );

    if (response.statusCode == 200) {
      // Gérer le token ici
      return true;
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Erreur de connexion';
      throw Exception(error);
    }
  }
  */
}