import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/services/cache/file_cache_service.dart';

class AppFile {
  final String id;
  final String name;
  final int size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String category;
  final User owner;
  final bool isShared;
  final List<String>? viewersName;

  const AppFile({
    required this.id,
    required this.name,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.owner,
    required this.isShared,
    this.viewersName,
  });
}

class FileModel {
  const FileModel({required FileCacheService cacheService})
    : _cacheService = cacheService;

  final FileCacheService _cacheService;

  Future<void> openFile(AppFile file) async {}

  Future<void> shareFile(AppFile file, {required List<User> shareTo}) async {}

  Future<void> renameFile(AppFile file, {required String newName}) async {}

  Future<void> downloadFile(AppFile file) async {}

  Future<void> uploadFile({
    required AppFile file,
    required String path,
  }) async {}

  Future<void> deleteFile(AppFile file) async {}
}
