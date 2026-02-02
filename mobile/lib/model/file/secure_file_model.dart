// lib/model/file/secure_file_model.dart

import 'package:securite_mobile/constants/permissions.dart';
import 'package:securite_mobile/services/security/rbac_service.dart';

/// Classification des données selon Module 3, pages 69-70
enum DataClassification {
  public, // Aucun chiffrement nécessaire
  internal, // Chiffrement basique
  confidential, // Chiffrement fort + contrôle d'accès
  restricted // Chiffrement fort + biométrie requise
}

/// Métadonnées de fichier sécurisé
class SecureFile {
  final String id;
  final String name;
  final String extension;
  final int sizeInBytes;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String ownerId;
  final DataClassification classification;
  final String encryptedPath; // Chemin du fichier chiffré
  final String? thumbnailPath; // Miniature si disponible
  final Map<String, dynamic> metadata; // Métadonnées additionnelles

  SecureFile({
    required this.id,
    required this.name,
    required this.extension,
    required this.sizeInBytes,
    required this.createdAt,
    required this.modifiedAt,
    required this.ownerId,
    required this.classification,
    required this.encryptedPath,
    this.thumbnailPath,
    this.metadata = const {},
  });

  String get displayName => '$name.$extension';

  String get formattedSize {
    if (sizeInBytes < 1024) return '$sizeInBytes B';
    if (sizeInBytes < 1024 * 1024) {
      return '${(sizeInBytes / 1024).toStringAsFixed(2)} KB';
    }
    if (sizeInBytes < 1024 * 1024 * 1024) {
      return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(sizeInBytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get fileTypeIcon {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return '📄';
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return '🖼️';
      case 'doc':
      case 'docx':
        return '📝';
      case 'xls':
      case 'xlsx':
      case 'csv':
        return '📊';
      case 'zip':
      case 'rar':
        return '🗜️';
      default:
        return '📁';
    }
  }

  /// Vérifie si le fichier nécessite l'authentification biométrique
  bool get requiresBiometry =>
      classification == DataClassification.restricted;

  /// Permissions requises selon la classification
  Set<Permission> get requiredPermissions {
    switch (classification) {
      case DataClassification.public:
        return {Permission.readDocument};
      case DataClassification.internal:
        return {Permission.readDocument};
      case DataClassification.confidential:
        return {Permission.readDocument};
      case DataClassification.restricted:
        return {Permission.readDocument};
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'extension': extension,
      'sizeInBytes': sizeInBytes,
      'createdAt': createdAt.toIso8601String(),
      'modifiedAt': modifiedAt.toIso8601String(),
      'ownerId': ownerId,
      'classification': classification.name,
      'encryptedPath': encryptedPath,
      'thumbnailPath': thumbnailPath,
      'metadata': metadata,
    };
  }

  factory SecureFile.fromJson(Map<String, dynamic> json) {
    return SecureFile(
      id: json['id'] as String,
      name: json['name'] as String,
      extension: json['extension'] as String,
      sizeInBytes: json['sizeInBytes'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      ownerId: json['ownerId'] as String,
      classification: DataClassification.values.firstWhere(
        (e) => e.name == json['classification'],
        orElse: () => DataClassification.internal,
      ),
      encryptedPath: json['encryptedPath'] as String,
      thumbnailPath: json['thumbnailPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  SecureFile copyWith({
    String? id,
    String? name,
    String? extension,
    int? sizeInBytes,
    DateTime? createdAt,
    DateTime? modifiedAt,
    String? ownerId,
    DataClassification? classification,
    String? encryptedPath,
    String? thumbnailPath,
    Map<String, dynamic>? metadata,
  }) {
    return SecureFile(
      id: id ?? this.id,
      name: name ?? this.name,
      extension: extension ?? this.extension,
      sizeInBytes: sizeInBytes ?? this.sizeInBytes,
      createdAt: createdAt ?? this.createdAt,
      modifiedAt: modifiedAt ?? this.modifiedAt,
      ownerId: ownerId ?? this.ownerId,
      classification: classification ?? this.classification,
      encryptedPath: encryptedPath ?? this.encryptedPath,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Fichier partagé avec permissions
class SharedFile {
  final SecureFile file;
  final String sharedWithUserId;
  final String sharedByUserId;
  final Role sharedRole;
  final DateTime sharedAt;
  final DateTime? expiresAt;

  SharedFile({
    required this.file,
    required this.sharedWithUserId,
    required this.sharedByUserId,
    required this.sharedRole,
    required this.sharedAt,
    this.expiresAt,
  });

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);

  Map<String, dynamic> toJson() {
    return {
      'file': file.toJson(),
      'sharedWithUserId': sharedWithUserId,
      'sharedByUserId': sharedByUserId,
      'sharedRole': sharedRole.name,
      'sharedAt': sharedAt.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  factory SharedFile.fromJson(Map<String, dynamic> json) {
    return SharedFile(
      file: SecureFile.fromJson(json['file'] as Map<String, dynamic>),
      sharedWithUserId: json['sharedWithUserId'] as String,
      sharedByUserId: json['sharedByUserId'] as String,
      sharedRole: Role.values.firstWhere(
        (e) => e.name == json['sharedRole'],
        orElse: () => Role.viewer,
      ),
      sharedAt: DateTime.parse(json['sharedAt'] as String),
      expiresAt: json['expiresAt'] != null
          ? DateTime.parse(json['expiresAt'] as String)
          : null,
    );
  }
}