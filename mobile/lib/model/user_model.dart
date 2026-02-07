import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/services/cache/user_cache_service.dart';

class User {
  final String uuid;
  final String fullName;
  final String email;
  final int storageLimit;
  final int storageUsed;
  final DateTime createdAt;

  const User({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.storageLimit,
    required this.storageUsed,
    required this.createdAt,
  });
}

class UserModel {
  final UserCacheService _cacheService;
  User? _currentUser;

  UserModel({User? initialUser, required UserCacheService cacheService})
    : _cacheService = cacheService,
      _currentUser = initialUser;

  Future<User?> getCurrentUser() async {
    if (_currentUser != null) return _currentUser;

    // verify cache
    final cachedUser = await _cacheService.getUserOrNull();
    if (cachedUser != null) {
      _currentUser = cachedUser;
      return cachedUser;
    }

    // get from server if no cache
    final userFromServer = await getUserFromServer();
    if (userFromServer != null) {
      _currentUser = userFromServer;
      await _cacheService.saveUser(userFromServer);
    }

    return _currentUser;
  }

  Future<void> logUserWithCredentials(LoginCredentials credentials) async {
    // TODO : stocker les tokens
    // TODO : utiliser les méthodes de service, pas dans le viewModel
  }

  Future<void> logUserWithOAuth() async {
    // TODO : stocker les tokens
    // TODO : utiliser les méthodes de service, pas dans le viewModel
  }

  Future<void> logUserOut() async {
    // TODO: effacer les tokens
  }

  Future<User?> getUserFromServer() async {
    // TODO: implémenter call serveur
    return null;
  }

  Future<bool> get isLoggedIn async {
    // TODO : vérifier token utilisateur
    // TODO : si possible vérifier sur server
    return true;
  }

  void clearCache() {
    _cacheService.clear();
  }
}
