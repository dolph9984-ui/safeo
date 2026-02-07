import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:securite_mobile/enum/file_visibility_enum.dart';

class CreateFileViewModel extends ChangeNotifier {
  bool loading = false;
  FilePickerResult? selectedFile;
  String _fileName = '';
  FileVisibilityEnum fileVisibility = FileVisibilityEnum.private;

  String get fileName => _fileName;

  String get filePath =>
      selectedFile != null ? selectedFile!.files.first.path ?? '' : '';

  double get fileSizeInMB => selectedFile != null
      ? double.parse(
          (selectedFile!.files.first.size / (1024 * 1024)).toStringAsFixed(2),
        )
      : 0;

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

  void unselectFile() {
    selectedFile = null;
    FilePicker.platform.clearTemporaryFiles();
    notifyListeners();
  }

  Future<void> selectFile() async {
    selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'csv', 'jpg', 'jpeg'],
    );

    if (selectedFile != null) {
      Uint8List fileBytes = selectedFile!.files.first.bytes ?? Uint8List(0);
      setFileName(selectedFile!.files.first.name);
    }
  }
}
