// lib/services/security/biometric_auth_service.dart

import 'package:local_auth/local_auth.dart';

class BiometricAuthService {
  static final BiometricAuthService _instance =
      BiometricAuthService._internal();

  factory BiometricAuthService() => _instance;

  BiometricAuthService._internal();

  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } catch (e) {
      print('⚠️ Erreur biométrie: $e');
      return false;
    }
  }

  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } catch (e) {
      print('⚠️ Erreur biométries: $e');
      return [];
    }
  }

  Future<bool> authenticate({
    required String reason,
  }) async {
    try {
      final canCheck = await canCheckBiometrics();
      if (!canCheck) return false;

      final biometrics = await getAvailableBiometrics();
      if (biometrics.isEmpty) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true, // ✅ seul paramètre accepté
      );
    } catch (e) {
      print('❌ Erreur auth biométrique: $e');
      return false;
    }
  }

  Future<bool> isBiometricAvailable() async {
    return await canCheckBiometrics() &&
        (await getAvailableBiometrics()).isNotEmpty;
  }
}
