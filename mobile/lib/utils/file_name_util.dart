class FileNameUtil {
  static String? getExtension(String fileName) {
    return fileName.contains('.') == true ? fileName.split('.').last : null;
  }
}
