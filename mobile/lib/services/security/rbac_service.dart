enum Role {
  viewer,   
  owner,    
}

enum Permission {
  addDocument,
  readDocument,
  deleteDocument,
  modifyDocument,
  shareDocument,
  downloadDocument,
}

/// Module 2, pages 40-49
class RBACService {
  static final RBACService _instance = RBACService._internal();
  factory RBACService() => _instance;
  RBACService._internal();

  static final Map<Role, Set<Permission>> _permissions = {
    Role.owner: {
      Permission.addDocument,
      Permission.readDocument,
      Permission.deleteDocument,
      Permission.modifyDocument,
      Permission.shareDocument,
      Permission.downloadDocument,
    },
    Role.viewer: {
      Permission.readDocument,
    },
  };

  bool hasPermission(Role role, Permission permission) {
    return _permissions[role]?.contains(permission) ?? false;
  }

  bool canAccess(Role userRole, Permission permission) {
    final rolePermissions = _permissions[userRole] ?? {};
    return rolePermissions.contains(permission);
  }

  Set<Permission> getPermissions(Role role) {
    return _permissions[role] ?? {};
  }

  bool hasAllPermissions(Role role, List<Permission> requiredPermissions) {
    final rolePermissions = _permissions[role] ?? {};
    return requiredPermissions.every((p) => rolePermissions.contains(p));
  }

  bool hasAnyPermission(Role role, List<Permission> requiredPermissions) {
    final rolePermissions = _permissions[role] ?? {};
    return requiredPermissions.any((p) => rolePermissions.contains(p));
  }

  Role? roleFromString(String roleStr) {
    switch (roleStr.toLowerCase()) {
      case 'owner':
        return Role.owner;
      case 'viewer':
        return Role.viewer;
      default:
        return null;
    }
  }

  String roleToString(Role role) {
    return role.toString().split('.').last;
  }
}

extension RoleExtension on Role {
  bool can(Permission permission) {
    return RBACService().hasPermission(this, permission);
  }

  String get displayName {
    switch (this) {
      case Role.owner:
        return 'Propriétaire';
      case Role.viewer:
        return 'Lecteur';
    }
  }
}