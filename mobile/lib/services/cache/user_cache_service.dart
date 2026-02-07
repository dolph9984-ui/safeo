import 'package:securite_mobile/model/user_model.dart';

class UserCacheService {
  final Duration? ttl;

  UserCacheService({required this.ttl});

  Future<User?> getUserOrNull() async {
    final cacheTime = await _getCacheTime();
    if (ttl != null && DateTime.now().difference(cacheTime) > ttl!) {
      return null;
    }
    return await _loadCachedUser();
  }

  Future<void> saveUser(User user) async {}

  Future<DateTime> _getCacheTime() async {
    // TODO: changer
    return DateTime.now();
  }

  Future<User?> _loadCachedUser() async {
    return null;
  }

  Future<void> clear() async {}
}
