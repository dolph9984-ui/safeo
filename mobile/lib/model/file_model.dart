import 'dart:typed_data';

import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/user_model.dart';

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
  final FileTypeEnum type;

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
    required this.type,
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
    FileTypeEnum? type,
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
      type: type ?? this.type,
    );
  }
}

class FileModel {
  FileModel();

  Future<List<AppFile>?> getUserFiles() async {
    return null;
  }

  Future<List<AppFile>?> getSharedFiles() async {
    return null;
  }

  Future<List<AppFile>?> getTrashFiles() async {
    return null;
  }

  Future<void> openFile(AppFile file) async {}

  Future<void> shareFile(AppFile file, {required List<User> shareTo}) async {}

  Future<void> renameFile(AppFile file, {required String newName}) async {}

  Future<void> downloadFile(AppFile file) async {}

  Future<void> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required String visibility,
  }) async {}

  Future<void> deleteFile(AppFile file) async {}
}
