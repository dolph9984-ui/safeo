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

  // ✅ Vérifie si un user peut faire une action sur un fichier
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
extension FilePermissionExtension on AppFile {
  bool canRead(User user) => RBACService().canAccess(this, user, Permission.readDocument);
  bool canModify(User user) => RBACService().canAccess(this, user, Permission.modifyDocument);
  bool canDelete(User user) => RBACService().canAccess(this, user, Permission.deleteDocument);
  bool canShare(User user) => RBACService().canAccess(this, user, Permission.shareDocument);
  bool canDownload(User user) => RBACService().canAccess(this, user, Permission.downloadDocument);

  Role? getUserRole(User user) => RBACService()._getUserRoleForFile(this, user);
}
