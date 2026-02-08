import 'dart:convert';

import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

class UserCacheService {
  static const _userKey = 'cached_user';
  static const _cacheTimeKey = 'cached_user_time';

  final _storageService = SecureStorageService();
  final Duration? ttl;

  UserCacheService({this.ttl});

  /// Récupère l'utilisateur du cache ou null si expiré / absent
  Future<User?> getUserOrNull() async {
    final cacheTime = await _getCacheTime();

    if (ttl != null && DateTime.now().difference(cacheTime) > ttl!) {
      await clear();
      return null;
    }

    return await _loadCachedUser();
  }

  /// Sauvegarde l'utilisateur et l'heure de cache
  Future<void> saveUser(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await _storageService.write(_userKey, jsonString);
    await _storageService.write(
      _cacheTimeKey,
      DateTime.now().toIso8601String(),
    );
  }

  /// Supprime l'utilisateur du cache
  Future<void> clear() async {
    await _storageService.delete(_userKey);
    await _storageService.delete(_cacheTimeKey);
  }

  /// Charge l'utilisateur depuis le cache
  Future<User?> _loadCachedUser() async {
    final jsonString = await _storageService.read(_userKey);
    if (jsonString == null) return null;

    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return User.fromJson(jsonMap);
  }

  /// Récupère la date du cache
  Future<DateTime> _getCacheTime() async {
    final cacheTimeStr = await _storageService.read(_cacheTimeKey);
    if (cacheTimeStr == null) return DateTime.fromMillisecondsSinceEpoch(0);
    return DateTime.parse(cacheTimeStr);
  }
}
