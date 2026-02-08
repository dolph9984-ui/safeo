import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:securite_mobile/enum/file_visibility_enum.dart';
import 'package:securite_mobile/model/file_model.dart';

class CreateFileViewModel extends ChangeNotifier {
  final FileModel model = FileModel();

  bool loading = false;
  FilePickerResult? selectedFile;
  String _fileName = '';
  FileVisibilityEnum fileVisibility = FileVisibilityEnum.private;

  int _uploadProgress = 0;
  String? _errorMessage;

  CancelToken? cancelToken;

  String get fileName => _fileName;

  String get filePath =>
      selectedFile != null ? selectedFile!.files.first.path ?? '' : '';

  double get fileSizeInMB => selectedFile != null
      ? double.parse(
          (selectedFile!.files.first.size / (1024 * 1024)).toStringAsFixed(2),
        )
      : 0;

  int get uploadProgress => _uploadProgress;
  String? get errorMessage => _errorMessage;

  void setFileVisibility(FileVisibilityEnum newVisibility) {
    if (newVisibility == fileVisibility) return;
    fileVisibility = newVisibility;
    notifyListeners();
  }

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void setFileName(String newName) {
    if (newName.trim().isEmpty) return;
    _fileName = newName;
    notifyListeners();
  }

  void _setUploadProgress(int progress) {
    _uploadProgress = progress;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void unselectFile() {
    selectedFile = null;
    _fileName = '';
    _uploadProgress = 0;
    _errorMessage = null;
    cancelToken = null;
    FilePicker.platform.clearTemporaryFiles();
    notifyListeners();
  }

  Future<void> selectFile() async {
    try {
      selectedFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'csv', 'jpg', 'jpeg', 'png', 'xls', 'xlsx'],
        withData: true,
      );

      if (selectedFile != null) {
        setFileName(selectedFile!.files.first.name);
        _setErrorMessage(null);
      }
    } catch (_) {
      _setErrorMessage('Erreur lors de la sélection du fichier');
    }
  }

  Future<Uint8List?> _readFileBytes() async {
    if (selectedFile == null) return null;

    final platformFile = selectedFile!.files.first;
    if (kIsWeb) return platformFile.bytes;

    if (platformFile.path != null) {
      try {
        final file = File(platformFile.path!);
        return await file.readAsBytes();
      } catch (_) {
        return null;
      }
    }
    return platformFile.bytes;
  }

  Future<bool> uploadFile() async {
    if (selectedFile == null) {
      _setErrorMessage('Aucun fichier sélectionné');
      return false;
    }

    final fileBytes = await _readFileBytes();
    if (fileBytes == null || fileBytes.isEmpty) {
      _setErrorMessage('Impossible de lire le fichier');
      return false;
    }

    if (fileSizeInMB > 40) {
      _setErrorMessage('Le fichier dépasse la taille maximale de 40MB');
      return false;
    }

    try {
      setLoading(true);
      _setUploadProgress(0);
      _setErrorMessage(null);

      cancelToken = CancelToken();

      final accessLevel =
          fileVisibility == FileVisibilityEnum.private ? 'private' : 'shareable';

      await model.uploadFile(
        bytes: fileBytes,
        fileName: _fileName,
        visibility: accessLevel,
        onProgress: (percent) => _setUploadProgress(percent),
        cancelToken: cancelToken,
      );

      setLoading(false);
      _setUploadProgress(100);
      return true;
    } on DioException catch (e) {
      if (CancelToken.isCancel(e)) {
        _setErrorMessage('Upload annulé');
      } else {
        _setErrorMessage('Erreur lors de l’upload');
      }
      setLoading(false);
      _setUploadProgress(0);
      return false;
    } catch (_) {
      setLoading(false);
      _setUploadProgress(0);
      _setErrorMessage('Erreur inattendue');
      return false;
    }
  }

  void reset() {
    unselectFile();
    fileVisibility = FileVisibilityEnum.private;
    setLoading(false);
    _setUploadProgress(0);
    _setErrorMessage(null);
  }

  @override
  void dispose() {
    FilePicker.platform.clearTemporaryFiles();
    super.dispose();
  }
}
