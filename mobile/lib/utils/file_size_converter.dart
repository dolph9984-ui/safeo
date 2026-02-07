import 'dart:math';

class FileSizeConverter {
  static double bytesToMb(int bytes, [int decimals = 2]) {
    final mb = bytes / (1024 * 1024);
    final mod = pow(10, decimals);
    return (mb * mod).round() / mod;
  }

  static double bytesToGb(int bytes, [int decimals = 2]) {
    final gb = bytes / (1024 * 1024 * 1024);
    final mod = pow(10, decimals);
    return (gb * mod).round() / mod;
  }
}
