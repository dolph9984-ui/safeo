import 'dart:async';
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
  
  bool _isCancelling = false;

  Timer? _debounceTimer;

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
  bool get isCancelling => _isCancelling;

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
    
    _debounceTimer?.cancel();
    
    if (progress == 0 || progress == 100) {
      notifyListeners();
      return;
    }
    

    _debounceTimer = Timer(Duration(milliseconds: 50), () {
      notifyListeners();
    });
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void cancelUpload() {
    if (_isCancelling) return; 
    if (cancelToken == null || cancelToken!.isCancelled) return;
    
    _isCancelling = true;
    notifyListeners();
    
    try {
      cancelToken!.cancel("Annulé par l'utilisateur");
    } catch (e) {
      debugPrint('Erreur lors de l\'annulation: $e');
    }
  }

  void unselectFile() {
    selectedFile = null;
    _fileName = '';
    _uploadProgress = 0;
    _errorMessage = null;
    cancelToken = null;
    _isCancelling = false;
    _debounceTimer?.cancel();
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
    } catch (e) {
      _setErrorMessage('Erreur lors de la sélection du fichier');
      debugPrint('Erreur selectFile: $e');
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
      } catch (e) {
        debugPrint('Erreur lecture fichier: $e');
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
      _isCancelling = false; 

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
        _setErrorMessage('Erreur lors de l\'upload');
        debugPrint('DioException uploadFile: $e');
      }
      setLoading(false);
      _setUploadProgress(0);
      return false;
    } catch (e) {
      setLoading(false);
      _setUploadProgress(0);
      _setErrorMessage('Erreur inattendue');
      debugPrint('Exception uploadFile: $e');
      return false;
    } finally {
      _isCancelling = false;
    }
  }

  void reset() {
    _debounceTimer?.cancel();
    _isCancelling = false;
    unselectFile();
    fileVisibility = FileVisibilityEnum.private;
    setLoading(false);
    _setUploadProgress(0);
    _setErrorMessage(null);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    cancelToken?.cancel();
    FilePicker.platform.clearTemporaryFiles();
    super.dispose();
  }
}