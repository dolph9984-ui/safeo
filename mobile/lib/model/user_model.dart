import 'package:securite_mobile/model/auth/login_credentials.dart';
import 'package:securite_mobile/model/auth/login_response.dart';
import 'package:securite_mobile/services/auth/form_auth_service.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';
import 'package:securite_mobile/services/auth/session_service.dart';
import 'package:securite_mobile/services/cache/user_cache_service.dart';

class User {
  final String uuid;
  final String fullName;
  final String email;
  final int filesNbr;
  final int sharedFilesNbr;
  final int storageLimit;
  final int storageUsed;
  final DateTime createdAt;
  final String? imageUrl;

  const User({
    required this.uuid,
    required this.fullName,
    required this.email,
    required this.filesNbr,
    required this.sharedFilesNbr,
    required this.storageLimit,
    required this.storageUsed,
    required this.createdAt,
    required this.imageUrl,
  });
}

class UserModel {
  final UserCacheService _cacheService;
  final FormAuthService _formAuthService;
  final OAuthService _oAuthService;
  final SessionService _sessionService;

  UserModel({
    UserCacheService? cacheService,
    OAuthService? oAuthService,
    FormAuthService? formAuthService,
    SessionService? sessionService,
  }) : _cacheService = cacheService ?? UserCacheService(ttl: null),
       _oAuthService = oAuthService ?? OAuthService(),
       _formAuthService = formAuthService ?? FormAuthService(),
       _sessionService = sessionService ?? SessionService();

  Future<User?> getCurrentUser() async {
    // get from server
    final userFromServer = await _getUserFromServer();
    if (userFromServer != null) {
      await _cacheService.saveUser(userFromServer);
      return userFromServer;
    }

    User? user;
    // else verify cache
    final cachedUser = await _cacheService.getUserOrNull();
    if (cachedUser != null) return cachedUser;

    user = User(
      uuid: '',
      fullName: 'Kirito EM',
      email: 'kirito@gmail.com',
      storageLimit: 1024 * 1024 * 1024 * 5,
      storageUsed: 1024 * 1024 * 1024 * 2,
      createdAt: DateTime.now(),
      imageUrl: null,
      filesNbr: 5,
      sharedFilesNbr: 0,
    );

    return user;
  }

  Future<CredentialLoginResponse> loginWithCredentials(
    LoginCredentials credentials,
  ) async {
    return await _formAuthService.login(credentials);
  }

  Future<void> loginWithOAuth() async {
    final sessionToken = await _oAuthService.login();
    final user = User(
      uuid: '',
      fullName: 'Kirito EM',
      email: 'test@gmail.com',
      storageLimit: 100,
      storageUsed: 100,
      createdAt: DateTime.now(),
      imageUrl: null,
      filesNbr: 0,
      sharedFilesNbr: 0,
    );

    await _sessionService.startSession(user, sessionToken);
  }

  Future<void> logUserOut() async {
    _sessionService.endSession();
  }

  Future<User?> _getUserFromServer() async {
    // TODO: implémenter call serveur
    return null;
  }

  Future<bool> get isLoggedIn async {
    return await _sessionService.isLoggedIn;
  }

  void clearCache() {
    _cacheService.clear();
  }
}
