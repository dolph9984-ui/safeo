import 'package:securite_mobile/services/auth/form_auth_service.dart';
import 'package:securite_mobile/services/auth/oauth_service.dart';
import 'package:securite_mobile/services/cache/user_cache_service.dart';
import 'package:securite_mobile/services/user_service.dart';

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
    this.imageUrl,
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
      imageUrl: json['imageUrl'] as String?,
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
  final UserService _userService;

  UserModel({
    UserCacheService? cacheService,
    UserService? userService,
    OAuthService? oAuthService,
    FormAuthService? formAuthService,
  })  : _cacheService = cacheService ?? UserCacheService(ttl: null),
        _userService = userService ?? UserService();


  Future<User?> getUserFromServer() async {
    try {
      return await _userService.getCurrentUser();
    } catch (e) {
      print('Erreur lors de la récupération de l\'utilisateur: $e');
      return null;
    }
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

  //Récupérer tous les utilisateurs
  Future<List<User>?> getAllUsers() async {
    try {
      return await _userService.getAllUsers();
    } catch (e) {
      print('Erreur lors de la récupération des utilisateurs: $e');
      return null;
    }
  }
}