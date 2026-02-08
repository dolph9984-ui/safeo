import 'dart:ui';

enum FileTypeEnum {
  image(
    name: "image",
    bgColor: Color(0xFFC7D7FE),
    assetName: 'assets/icons/document.svg',
  ),
  pdf(
    name: "pdf",
    bgColor: Color(0xFFFECDCA),
    assetName: 'assets/icons/pdf.svg',
  ),
  csv(
    name: "csv",
    bgColor: Color(0xFFABEFC6),
    assetName: 'assets/icons/csv.svg',
  ),
  document(
    name: "document",
    bgColor: Color(0xFFC7D7FE),
    assetName: 'assets/icons/document.svg',
  ),
  other(
    name: 'autre',
    bgColor: Color(0xFFC7D7FE),
    assetName: 'assets/icons/document.svg',
  );

  final String name;
  final Color bgColor;
  final String assetName;

  const FileTypeEnum({
    required this.name,
    required this.bgColor,
    required this.assetName,
  });

  static FileTypeEnum fromExtension(String? ext) {
    switch (ext?.toLowerCase()) {
      case 'png':
      case 'jpg':
      case 'jpeg':
        return FileTypeEnum.image;
      case 'pdf':
        return FileTypeEnum.pdf;
      case 'csv':
        return FileTypeEnum.csv;
      case 'doc':
      case 'docx':
      case 'txt':
        return FileTypeEnum.document;
      default:
        return FileTypeEnum.other;
    }
  }
}
