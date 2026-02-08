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

  AppFile copyWith({
    String? id,
    String? name,
    int? size,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    User? owner,
    bool? isShared,
    List<String>? viewersName,
  }) {
    return AppFile(
      id: id ?? this.id,
      name: name ?? this.name,
      size: size ?? this.size,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      category: category ?? this.category,
      owner: owner ?? this.owner,
      isShared: isShared ?? this.isShared,
      viewersName: viewersName ?? this.viewersName,
    );
  }
}

class FileModel {
  FileModel({FileCacheService? cacheService})
    : _cacheService = cacheService ?? FileCacheService(ttl: null);

  final FileCacheService _cacheService;

  Future<List<AppFile>?> getUserFiles() async {
    final cachedFiles = await _cacheService.getFilesOrNull();

    final serverFiles = await _getFilesFromServer();
    if (serverFiles != null) {
      await _cacheService.syncFiles(cachedFiles, serverFiles);
      return serverFiles;
    }

    final ext = ['pdf', 'doc', 'docx', 'csv', 'jpg', 'jpeg'];
    return List.generate(
      8,
      (index) => AppFile(
        id: '${index + 1}',
        name: 'file_name_example.${ext[index % ext.length]}',
        size: 10000,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        category: 'test',
        isShared: index % 2 == 0,
        owner: User(
          uuid: '',
          fullName: '',
          email: '',
          filesNbr: 0,
          sharedFilesNbr: 0,
          storageLimit: 0,
          storageUsed: 0,
          createdAt: DateTime.now(),
          imageUrl: '',
        ),
      ),
    );

    return cachedFiles;
  }

  Future<List<AppFile>?> getSharedFiles() async {
    return null;
  }

  Future<List<AppFile>?> getTrashFiles() async {
    return null;
  }

  Future<List<AppFile>?> _getFilesFromServer() async {
    return null;
  }

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