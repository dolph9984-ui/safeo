class FileSizeConverter {
  static double bytesToMb(int bytes) {
    return double.parse((bytes / (1024 * 1024)).toStringAsFixed(2));
  }

  static double bytesToGb(int bytes) {
    return double.parse((bytes / 1024).toStringAsFixed(2));
  }
}
