import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/model/viewer_model.dart';
import 'package:securite_mobile/services/file_upload_service.dart';
import 'package:securite_mobile/utils/dio_util.dart';

class UploadDocumentResponse {
  final int statusCode;
  final String message;
  final Document document;

  const UploadDocumentResponse({
    required this.statusCode,
    required this.message,
    required this.document,
  });

  factory UploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    return UploadDocumentResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      document: Document.fromJson(json['document'] as Map<String, dynamic>),
    );
  }
}

class Document {
  final String id;
  final String originalName;
  final int fileSize;
  final String fileMimeType;
  final String fileType;
  final String accessLevel;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Viewer>? viewers;
  final User owner;
  final bool? isOwner;

  const Document({
    required this.id,
    required this.originalName,
    required this.fileSize,
    required this.fileMimeType,
    required this.fileType,
    required this.accessLevel,
    required this.isDeleted,
    this.deletedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.viewers,
    required this.owner,
    this.isOwner,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      id: json['id'] as String,
      originalName: json['originalName'] as String,
      fileSize: json['fileSize'] as int,
      fileMimeType: json['fileMimeType'] as String,
      fileType: json['fileType'] as String,
      accessLevel: json['accessLevel'] as String,
      isDeleted: json['isDeleted'] as bool,
      deletedAt: json['deletedAt'] != null
          ? DateTime.parse(json['deletedAt'] as String)
          : null,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      viewers: (json['viewers'] as List<dynamic>?)
          ?.map((e) => Viewer.fromJson(e))
          .toList(),
      owner: json['user'] != null
          ? User.fromJson(json['user'])
          : json['ownerUser'] != null
          ? User.fromJson(json['ownerUser'])
          : json['userId'] != null
          ? User.none().copyWith(uuid: json['userId'])
          : User.none(),
      isOwner: json['isOwner'] as bool?,
    );
  }

  Document copyWith({
    String? id,
    String? originalName,
    int? fileSize,
    String? fileMimeType,
    String? fileType,
    String? accessLevel,
    bool? isDeleted,
    DateTime? deletedAt,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Viewer>? viewers,
    User? owner,
    bool? isOwner,
  }) {
    return Document(
      id: id ?? this.id,
      originalName: originalName ?? this.originalName,
      fileSize: fileSize ?? this.fileSize,
      fileMimeType: fileMimeType ?? this.fileMimeType,
      fileType: fileType ?? this.fileType,
      accessLevel: accessLevel ?? this.accessLevel,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewers: viewers ?? this.viewers?.map((v) => v).toList(),
      owner: owner ?? this.owner,
      isOwner: isOwner ?? this.isOwner,
    );
  }
}

class DocumentModel {
  final _uploadService = FileUploadService();
  final _dio = DioClient.dio;

  Future<List<Document>> getUserDocuments() async {
    final response = await _dio.get('/v1/api/document');

    final List data = response.data['documents'];

    return data
        .map((json) => Document.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<Document>?> getSharedDocuments() async {
    final response = await _dio.get('/v1/api/document/shared-documents');
    
    final List data = response.data['sharedDocuments']; 
    
    return data.map((json) {
      final Map<String, dynamic> adaptedJson = {
        ...json,
        'user': json['ownerUser'],
        'viewers': json['viewers'] ?? [],
      };
      
      return Document.fromJson(adaptedJson);
    }).toList();
  }

  Future<List<Document>?> getTrashDocuments() async {
    return null;
  }

  Future<void> openFile(Document document) async {}

Future<void> shareFile(
  Document document, {
  required String email,
}) async {
  try {
    await _dio.post(
      '/v1/api/document-shares/share/${document.id}',
      data: {'invitedEmail': email},
    );
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      throw Exception('USER_NOT_FOUND');
    }
    rethrow;
  }
}

  Future<void> downloadFile(Document document) async {}

  Future<Document> uploadFile({
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
                  final shouldUpdate =
                      lastUpdate == null ||
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
      debugPrint(e.toString());
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> renameDocument(
    Document document, {
    required String newName,
  }) async {
    try {
      final response = await _dio.patch(
        '/v1/api/document/${document.id}',
        data: {'fileName': newName},
      );
      return (response.data['statusCode'] as int) == 200;
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> deleteDocument(Document document) async {
    try {
      await _dio.delete('/v1/api/document/${document.id}');
      return true;
    } catch (e) {
      debugPrintStack();
      debugPrint(e.toString());
      return false;
    }
  }

  Future<void> restoreFile(Document document) async {}

  Future<void> deleteFilePermanently(Document document) async {}

  Future<void> restoreFiles(List<String> fileIds) async {}

  Future<void> deleteFilesPermanently(List<String> fileIds) async {}

  Future<void> emptyTrash() async {}
}