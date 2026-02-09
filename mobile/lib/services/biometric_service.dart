import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Vérifie si la biométrie est utilisable
  Future<bool> canAuthenticate() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print('Erreur biométrie: $e');
      return false;
    }
  }

  // Authentification biométrique
  Future<bool> authenticate() async {
    try {
      final bool canAuth = await _auth.canCheckBiometrics;

      if (!canAuth) {
        print('Biométrie non disponible');
        return false;
      }

      return await _auth.authenticate(
        localizedReason: 'Authentifiez-vous pour continuer',
      );
    } on PlatformException catch (e) {
      print('Erreur d\'authentification: $e');
      return false;
    }
  }
}
