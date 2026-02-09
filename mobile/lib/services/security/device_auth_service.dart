import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

enum AuthMethod { biometric, devicePassword }

class DeviceAuthService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> canUseBiometrics() async {
    try {
      return await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
    } catch (e) {
      debugPrint('Erreur vérification biométrie : $e');
      return false;
    }
  }

  Future<bool> authenticateBiometric({
    String reason = 'Veuillez vous authentifier',
  }) async {
    try {
      bool available = await canUseBiometrics();
      if (!available) return false;

      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      debugPrint('Erreur biométrie : $e');
      return false;
    }
  }
}
