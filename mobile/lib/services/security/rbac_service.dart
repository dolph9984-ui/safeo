import 'package:securite_mobile/model/file_model.dart';
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
    Role.viewer: {
      Permission.readDocument,
      Permission.downloadDocument,
    },
  };

  // Vérifie si un user peut faire une action sur un fichier
  bool canAccess(AppFile file, User user, Permission permission) {
    final role = _getUserRoleForFile(file, user);
    if (role == null) return false;
    return _permissions[role]?.contains(permission) ?? false;
  }

  // Détermine le rôle du user sur ce fichier
  Role? _getUserRoleForFile(AppFile file, User user) {
    if (file.owner.uuid == user.uuid) return Role.owner;
    if (file.isShared && file.viewersName?.contains(user.email) == true) {
      return Role.viewer;
    }
    return null;
  }
}

extension UserPermissionExtension on User {
  bool canAccess(AppFile file, Permission permission) {
    return RBACService().canAccess(file, this, permission);
  }

  bool canRead(AppFile file) => canAccess(file, Permission.readDocument);
  bool canModify(AppFile file) => canAccess(file, Permission.modifyDocument);
  bool canDelete(AppFile file) => canAccess(file, Permission.deleteDocument);
  bool canShare(AppFile file) => canAccess(file, Permission.shareDocument);
  bool canDownload(AppFile file) => canAccess(file, Permission.downloadDocument);

  Role? getRole(AppFile file) {
    return RBACService()._getUserRoleForFile(file, this);
  }
}