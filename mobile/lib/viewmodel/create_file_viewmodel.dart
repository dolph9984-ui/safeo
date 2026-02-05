import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class CreateFileViewModel extends ChangeNotifier {
  bool loading = false;
  FilePickerResult? selectedFile;

  double get fileSizeInMB => selectedFile != null
      ? double.parse(
          (selectedFile!.files.first.size / (1024 * 1024)).toStringAsFixed(2),
        )
      : 0;

  String get fileName =>
      selectedFile != null ? selectedFile!.files.first.name : '';

  void setLoading(bool val) {
    loading = val;
    notifyListeners();
  }

  void unselectFile() {
    selectedFile = null;
    FilePicker.platform.clearTemporaryFiles();
    notifyListeners();
  }

  Future<void> selectFile() async {
    setLoading(true);

    selectedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf, doc, docx, csv, jpg, jpeg'],
    );

    setLoading(false);

    if (selectedFile != null) {
      Uint8List fileBytes = selectedFile!.files.first.bytes!;
      String fileName = selectedFile!.files.first.name;
    }
  }
}
