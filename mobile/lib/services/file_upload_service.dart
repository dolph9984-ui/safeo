import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:securite_mobile/utils/dio_util.dart';
import 'package:securite_mobile/utils/file_name_util.dart';
import 'package:securite_mobile/utils/file_size_util.dart';

class FileUploadService {
  final Dio _dio;

  FileUploadService({Dio? dio}) : _dio = dio ?? DioClient.dio;

  Future<Map<String, dynamic>> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String accessLevel,
    ProgressCallback? onProgress,
    CancelToken? cancelToken,
  }) async {
    _validateFile(fileBytes, fileName);

    try {
      final multipartFile = MultipartFile.fromBytes(
        fileBytes,
        filename: fileName,
      );

      final formData = FormData.fromMap({
        'file': multipartFile,
        'accessLevel': accessLevel,
      });

      final response = await _dio.post(
        'v1/api/document/upload',
        data: formData,
        onSendProgress: onProgress,
        cancelToken: cancelToken,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );

      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: 'Upload failed with status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      _handleDioException(e);
      rethrow;
    }
  }

  void _validateFile(Uint8List fileBytes, String fileName) {
    if (fileBytes.isEmpty) {
      throw Exception('Le fichier est vide');
    }

    final extension = FileNameUtil.getExtension(fileName);
    if (extension == null) {
      throw Exception('Le fichier doit avoir une extension');
    }

    const allowedExtensions = [
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'csv',
      'jpg',
      'jpeg',
      'png',
    ];

    if (!allowedExtensions.contains(extension.toLowerCase())) {
      throw Exception(
        'Extension non autorisée. Extensions acceptées: ${allowedExtensions.join(", ")}',
      );
    }

    final sizeInMb = FileSizeUtil.bytesToMb(fileBytes.length);
    if (sizeInMb > 40) {
      throw Exception(
        'Le fichier dépasse la taille maximale de 40MB (${sizeInMb.toStringAsFixed(2)}MB)',
      );
    }
  }

  void _handleDioException(DioException e) {
    if (e.response?.statusCode == 404) {
      throw Exception('Endpoint introuvable (404). Vérifiez l\'URL de l\'API');
    } else if (e.response?.statusCode == 413) {
      throw Exception('Espace de stockage insuffisant ou plein');
    } else if (e.response?.statusCode == 427) {
      throw Exception('Fichier invalide (type non autorisé ou taille > 40MB)');
    } else if (e.response?.statusCode == 401) {
      throw Exception('Session expirée. Veuillez vous reconnecter');
    } else if (e.response?.statusCode == 403) {
      throw Exception('Accès refusé');
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw Exception('Délai d\'attente dépassé. Vérifiez votre connexion');
    } else if (e.type == DioExceptionType.connectionError) {
      throw Exception('Erreur de connexion. Vérifiez votre réseau');
    }
  }
}
