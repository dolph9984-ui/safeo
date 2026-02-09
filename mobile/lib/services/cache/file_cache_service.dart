import 'package:securite_mobile/model/document_model.dart';

class FileCacheService {
  final Duration? ttl;

  const FileCacheService({required this.ttl});

  Future<List<Document>?> getFilesOrNull() async {
    final cacheTime = await _getCacheTime();
    if (ttl != null && DateTime.now().difference(cacheTime) > ttl!) {
      return null;
    }
    return await _loadCachedFiles();
  }

  Future<void> syncFiles(List<Document> serverFiles) async {
    final List<Document> newFiles = [];
    await _saveNewFiles(newFiles);
  }

  Future<void> _saveNewFiles(List<Document> files) async {}

  Future<void> clear() async {}

  Future<DateTime> _getCacheTime() async {
    // TODO: changer
    return DateTime.now();
  }

  Future<List<Document>> _loadCachedFiles() async {
    return [];
  }
}
