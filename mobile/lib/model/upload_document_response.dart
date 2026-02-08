class UploadDocumentResponse {
  final int statusCode;
  final String message;
  final DocumentData document;

  const UploadDocumentResponse({
    required this.statusCode,
    required this.message,
    required this.document,
  });

  factory UploadDocumentResponse.fromJson(Map<String, dynamic> json) {
    return UploadDocumentResponse(
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      document: DocumentData.fromJson(json['document'] as Map<String, dynamic>),
    );
  }
}

class DocumentData {
  final String id;
  final String originalName;
  final int fileSize;
  final String fileMimeType;
  final String fileType;
  final String accessLevel;
  final bool isDeleted;
  final DateTime? deletedAt;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DocumentData({
    required this.id,
    required this.originalName,
    required this.fileSize,
    required this.fileMimeType,
    required this.fileType,
    required this.accessLevel,
    required this.isDeleted,
    this.deletedAt,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DocumentData.fromJson(Map<String, dynamic> json) {
    return DocumentData(
      id: json['id'] as String,
      originalName: json['originalName'] as String,
      fileSize: json['fileSize'] as int,
      fileMimeType: json['fileMimeType'] as String,
      fileType: json['fileType'] as String,
      accessLevel: json['accessLevel'] as String,
      isDeleted: json['isDeleted'] as bool,
      deletedAt: json['deletedAt'] != null 
          ? DateTime.parse(json['deletedAt'] as String) 
          : null,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}