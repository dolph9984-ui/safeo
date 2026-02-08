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

  Future<void> syncFiles(List<AppFile> serverFiles) async {
    final List<AppFile> newFiles = [];
    await _saveNewFiles(newFiles);
  }

  Future<void> _saveNewFiles(List<AppFile> files) async {}

  Future<void> clear() async {}

  Future<DateTime> _getCacheTime() async {
    // TODO: changer
    return DateTime.now();
  }

  Future<List<AppFile>> _loadCachedFiles() async {
    return [];
  }
}
