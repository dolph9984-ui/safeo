import 'package:flutter/material.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class ShareHandlingViewModel extends ChangeNotifier {
  final DocumentModel _documentModel;
  final UserModel _userModel;
  final SessionModel _sessionModel;

  Document? _currentFile;
  User? _currentUser;
  List<User> _availableUsers = [];
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;

  Document? get currentFile => _currentFile;

  List<Map<String, dynamic>> get allMembers => _members;

  bool get isLoading => _isLoading;

  ShareHandlingViewModel({
    required String fileId,
    DocumentModel? fileModel,
    UserModel? userModel,
    SessionModel? sessionModel,
  })  : _documentModel = fileModel ?? DocumentModel(),
        _userModel = userModel ?? UserModel(),
        _sessionModel = sessionModel ?? SessionModel() {
    _init(fileId);
  }

  Future<void> _init(String fileId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _initUser();
      await _loadAvailableUsers();
      await _loadCurrentFile(fileId);
      await _loadMembers();
    } catch (e) {
      debugPrint('Error initializing ShareHandlingViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _initUser() async {
    if (_sessionModel.session == null) {
      _sessionModel.destroySession();
      _currentUser = User.none();
      return;
    }
    _currentUser = _sessionModel.session!.user;
    notifyListeners();
  }

  Future<void> _loadAvailableUsers() async {
    try {
      final usersResponse = await _userModel.getAllUsers();
      final users = usersResponse.data;
      if (users != null) {
        _availableUsers = users;
      }
    } catch (e) {
      debugPrint('Error loading available users: $e');
    }
  }

  Future<void> _loadCurrentFile(String fileId) async {
    try {
      final files = await _documentModel.getUserDocuments();
      _currentFile = files.firstWhere(
        (f) => f.id == fileId,
        orElse: () => files.first,
      );
    } catch (e) {
      debugPrint('Error loading file: $e');
    }
  }

  Future<void> _loadMembers() async {
    if (_currentFile == null || _currentUser == null) return;

    _members = [];

    // Trouver le propriétaire du fichier parmi les utilisateurs disponibles
    final owner = _availableUsers.firstWhere(
      (user) => user.uuid == _currentFile!.userId,
      orElse: () => _currentUser!, // Fallback sur l'utilisateur actuel
    );

    // Ajouter le propriétaire
    _members.add({
      'id': owner.uuid,
      'name': owner.fullName,
      'email': owner.email,
      'isOwner': true,
    });

    // Ajouter les viewers
    if (_currentFile!.viewers != null && _currentFile!.viewers!.isNotEmpty) {
      for (final viewerData in _currentFile!.viewers!) {
        final viewer = _availableUsers.firstWhere(
          (user) => user.uuid == viewerData.id, // Utiliser l'ID du viewer
          orElse: () => User(
            uuid: viewerData.id,
            fullName: viewerData.email.split('@').first,
            email: viewerData.email,
            filesNbr: 0,
            sharedFilesNbr: 0,
            storageLimit: 0,
            storageUsed: 0,
            createdAt: DateTime.now(),
            imageUrl: null,
          ),
        );

        _members.add({
          'id': viewer.uuid,
          'name': viewer.fullName,
          'email': viewer.email,
          'isOwner': false,
        });
      }
    }

    notifyListeners();
  }

  Future<String?> removeUserAccess(String userId) async {
    if (_currentFile == null) return 'Erreur';

    final memberToRemove = _members.firstWhere(
      (m) => m['id'] == userId,
      orElse: () => {},
    );

    if (memberToRemove.isEmpty) {
      return 'Utilisateur non trouvé';
    }

    if (memberToRemove['isOwner'] == true) {
      return 'Impossible de retirer le propriétaire';
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _documentModel.removeViewer(
        documentId: _currentFile!.id,
        userIdToRemove: userId,
      );

      _members.removeWhere((m) => m['id'] == userId);

      await _loadCurrentFile(_currentFile!.id);
      await _loadMembers();

      return null; 
    } catch (e) {
      debugPrint('Error removing user access: $e');

      if (e.toString().contains('UNAUTHORIZED')) {
        return 'Seul le propriétaire peut retirer l\'accès';
      }

      return 'Erreur lors de la suppression';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}