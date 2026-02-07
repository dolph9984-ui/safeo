import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:securite_mobile/constants/storage_keys.dart';

class SecureStorageService {
  static final SecureStorageService _instance =
      SecureStorageService._internal();

  factory SecureStorageService() => _instance;

  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      keyCipherAlgorithm:
          KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
      storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<void> initialize() async {
    try {
      await _storage.containsKey(key: StorageKeys.accessToken);
      print('SecureStorageService initialisé');
    } catch (e) {
      print('Erreur initialisation SecureStorage: $e');
    }
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Erreur lors de l’écriture dans secure storage');
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Erreur lors de la lecture dans secure storage');
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Erreur lors de la suppression dans secure storage : $e');
    }
  }
}
