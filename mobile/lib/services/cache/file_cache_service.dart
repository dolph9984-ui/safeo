import 'package:securite_mobile/model/file_model.dart';

class FileCacheService {
  final Duration? ttl;

  const FileCacheService({required this.ttl});

  Future<List<AppFile>?> getFilesOrNull() async {
    final cacheTime = await _getCacheTime();
    if (ttl != null && DateTime.now().difference(cacheTime) > ttl!) {
      return null;
    }
    return await _loadCachedFiles();
  }

  Future<void> syncFiles(
    List<AppFile>? cachedFiles,
    List<AppFile> serverFiles,
  ) async {
    if (cachedFiles == null) {
      await _saveNewFiles(serverFiles);
      return;
    }

    final Map<String, AppFile> cacheMap = {for (var f in cachedFiles) f.id: f};

    final List<AppFile> newFiles = [];
    final List<AppFile> filesToUpdate = [];

    for (var serverFile in serverFiles) {
      final localFile = cacheMap[serverFile.id];
      if (localFile == null) {
        newFiles.add(serverFile);
      } else if (localFile.updatedAt != serverFile.updatedAt) {
        filesToUpdate.add(serverFile);
      }
    }

    await _saveNewFiles(newFiles);
    await _updateFiles(filesToUpdate);
  }

  Future<void> _saveNewFiles(List<AppFile> files) async {}

  Future<void> _updateFiles(List<AppFile> files) async {}

  Future<void> clear() async {}

  Future<DateTime> _getCacheTime() async {
    // TODO: changer
    return DateTime.now();
  }

  Future<List<AppFile>> _loadCachedFiles() async {
    return [];
  }
}
