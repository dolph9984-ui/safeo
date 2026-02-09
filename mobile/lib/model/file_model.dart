import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/model/upload_document_response.dart';
import 'package:securite_mobile/services/file_upload_service.dart';

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
  final FileUploadService _uploadService;

  FileModel({FileUploadService? uploadService})
      : _uploadService = uploadService ?? FileUploadService();

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

  Future<DocumentData> uploadFile({
    required Uint8List bytes,
    required String fileName,
    required String visibility,
    Function(int)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      DateTime? lastUpdate;
      int lastPercent = 0;
      const throttleDuration = Duration(milliseconds: 100);

      final response = await _uploadService.uploadFile(
        fileBytes: bytes,
        fileName: fileName,
        accessLevel: visibility,
        cancelToken: cancelToken,
        onProgress: onProgress != null
            ? (sent, total) {
                if (total > 0) {
                  final percent = ((sent / total) * 100).round();
                  final now = DateTime.now();
                  final shouldUpdate = lastUpdate == null ||
                      now.difference(lastUpdate!).inMilliseconds >= 
                          throttleDuration.inMilliseconds ||
                      (percent - lastPercent).abs() >= 1 ||
                      percent == 100;

                  if (shouldUpdate) {
                    lastUpdate = now;
                    lastPercent = percent;
                    onProgress(percent);
                  }
                }
              }
            : null,
      );

      final uploadResponse = UploadDocumentResponse.fromJson(response);
      return uploadResponse.document;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(AppFile file) async {}

  Future<void> restoreFile(AppFile file) async {}

  Future<void> deleteFilePermanently(AppFile file) async {}

  Future<void> restoreFiles(List<String> fileIds) async {}

  Future<void> deleteFilesPermanently(List<String> fileIds) async {}

  Future<void> emptyTrash() async {}
}