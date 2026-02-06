import 'dart:ui';

enum FileTypeEnum {
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
    name: "other",
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
}
