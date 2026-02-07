import 'package:securite_mobile/enum/file_type_enum.dart';

class TrashedFile {
  final String id;
  final String fileName;
  final double fileSize;
  final FileTypeEnum fileType;
  final DateTime deletedAt;
  final DateTime deletionDate;

  TrashedFile({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    required this.deletedAt,
    required this.deletionDate,
  });

  factory TrashedFile.fromJson(Map<String, dynamic> json) {
    return TrashedFile(
      id: json['id'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      fileType: FileTypeEnum.values.firstWhere(
        (e) => e.name == json['fileType'],
        orElse: () => FileTypeEnum.other,
      ),
      deletedAt: DateTime.parse(json['deletedAt']),
      deletionDate: DateTime.parse(json['deletionDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileType': fileType.name,
      'deletedAt': deletedAt.toIso8601String(),
      'deletionDate': deletionDate.toIso8601String(),
    };
  }
}