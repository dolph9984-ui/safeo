import 'package:securite_mobile/constants/storage_keys.dart';
import 'package:securite_mobile/model/auth/session_token.dart';

import '../../model/user_model.dart';
import '../cache/file_cache_service.dart';
import '../cache/user_cache_service.dart';
import '../security/secure_storage_service.dart';

class SessionService {
  // Singleton
  static final SessionService _instance = SessionService._internal(
    userCacheService: UserCacheService(ttl: null),
    fileCacheService: FileCacheService(ttl: null),
    storageService: SecureStorageService(),
  );

  factory SessionService() => _instance;

  final UserCacheService _userCacheService;
  final FileCacheService _fileCacheService;
  final SecureStorageService _storageService;

  SessionService._internal({
    required UserCacheService userCacheService,
    required FileCacheService fileCacheService,
    required SecureStorageService storageService,
  }) : _userCacheService = userCacheService,
       _fileCacheService = fileCacheService,
       _storageService = storageService;

  UserCacheService get userCache => _userCacheService;

  FileCacheService get fileCache => _fileCacheService;

  Future<bool> get isLoggedIn async {
    final token = await getAccessToken();
    return token != null;
  }

  Future<void> startSession(User user, SessionToken sessionToken) async {
    await SessionTokenModel.storeTokens(sessionToken);
    await _userCacheService.saveUser(user);
  }

  Future<void> endSession() async {
    await _storageService.deleteAll();
    await _userCacheService.clear();
    await _fileCacheService.clear();
  }

  Future<String?> getAccessToken() async {
    return await _storageService.read(StorageKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storageService.read(StorageKeys.refreshToken);
  }
}
