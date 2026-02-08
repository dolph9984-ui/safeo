import 'package:securite_mobile/services/auth/form_auth_service.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uuid: json['uuid'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      filesNbr: json['filesNbr'] as int,
      sharedFilesNbr: json['sharedFilesNbr'] as int,
      storageLimit: json['storageLimit'] as int,
      storageUsed: json['storageUsed'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'fullName': fullName,
      'email': email,
      'filesNbr': filesNbr,
      'sharedFilesNbr': sharedFilesNbr,
      'storageLimit': storageLimit,
      'storageUsed': storageUsed,
      'createdAt': createdAt.toIso8601String(),
      'imageUrl': imageUrl,
    };
  }

  factory User.none() => User(
    uuid: '0',
    fullName: '',
    email: '',
    filesNbr: 0,
    sharedFilesNbr: 0,
    storageLimit: 0,
    storageUsed: 0,
    createdAt: DateTime.now(),
    imageUrl: null,
  );
}

class UserModel {
  final UserCacheService _cacheService;

  UserModel({
    UserCacheService? cacheService,
    OAuthService? oAuthService,
    FormAuthService? formAuthService,
  }) : _cacheService = cacheService ?? UserCacheService(ttl: null);

  Future<User?> getUserFromServer() async {
    return User(
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
  }

  Future<User?> getUserFromCache() async {
    return await _cacheService.getUserOrNull();
  }

  Future<void> saveUserToCache(User user) async {
    await _cacheService.saveUser(user);
  }

  Future<void> clearUserFromCache() async {
    await _cacheService.clear();
  }
}
