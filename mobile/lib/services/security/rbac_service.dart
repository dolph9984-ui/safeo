import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/user_model.dart';

enum Role { viewer, owner }

enum Permission {
  addDocument,
  readDocument,
  modifyDocument,
  deleteDocument,
  shareDocument,
  downloadDocument,
}

class RBACService {
  static final RBACService _instance = RBACService._internal();

  factory RBACService() => _instance;

  RBACService._internal();

  static final Map<Role, Set<Permission>> _permissions = {
    Role.owner: {
      Permission.addDocument,
      Permission.readDocument,
      Permission.modifyDocument,
      Permission.deleteDocument,
      Permission.shareDocument,
      Permission.downloadDocument,
    },
    Role.viewer: {Permission.readDocument, Permission.downloadDocument},
  };

  // Vérifie si un user peut faire une action sur un fichier
  bool canAccess(Document file, User user, Permission permission) {
    final role = _getUserRoleForFile(file, user);
    if (role == null) return false;
    return _permissions[role]?.contains(permission) ?? false;
  }

  // Détermine le rôle du user sur ce fichier
  Role? _getUserRoleForFile(Document document, User user) {
    if (document.userId == user.uuid) return Role.owner;

    final viewers = document.viewers ?? [];
    if (document.accessLevel == 'shareable' &&
        viewers.any((viewer) => viewer.id == user.uuid)) {
      return Role.viewer;
    }

    return null;
  }
}

extension UserPermissionExtension on User {
  bool canAccess(Document file, Permission permission) {
    return RBACService().canAccess(file, this, permission);
  }

  bool canRead(Document file) => canAccess(file, Permission.readDocument);

  bool canModify(Document file) => canAccess(file, Permission.modifyDocument);

  bool canDelete(Document file) => canAccess(file, Permission.deleteDocument);

  bool canShare(Document file) => canAccess(file, Permission.shareDocument);

  bool canDownload(Document file) =>
      canAccess(file, Permission.downloadDocument);

  Role? getRole(Document file) {
    return RBACService()._getUserRoleForFile(file, this);
  }
}
