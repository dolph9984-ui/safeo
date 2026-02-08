import 'package:flutter/material.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class ShareHandlingViewModel extends ChangeNotifier {
  final FileModel _fileModel;
  final UserModel _userModel;
  final SessionModel _sessionModel;

  AppFile? _currentFile;
  User? _currentUser;
  List<User> _availableUsers = [];
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;

  AppFile? get currentFile => _currentFile;
  List<Map<String, dynamic>> get allMembers => _members;
  bool get isLoading => _isLoading;

  ShareHandlingViewModel({
    required String fileId,
    FileModel? fileModel,
    UserModel? userModel,
    SessionModel? sessionModel,
  })  : _fileModel = fileModel ?? FileModel(),
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
      final users = await _userModel.getAllUsers();
      if (users != null) {
        _availableUsers = users;
      }
    } catch (e) {
      debugPrint('Error loading available users: $e');
    }
  }

  Future<void> _loadCurrentFile(String fileId) async {
    try {
      final files = await _fileModel.getUserFiles();
      _currentFile = files?.firstWhere(
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

    _members.add({
      'id': _currentFile!.owner.uuid,
      'name': _currentFile!.owner.fullName,
      'email': _currentFile!.owner.email,
      'isOwner': true,
    });

    if (_currentFile!.viewersName != null && _currentFile!.viewersName!.isNotEmpty) {
      for (final viewerEmail in _currentFile!.viewersName!) {
        final viewer = _availableUsers.firstWhere(
          (user) => user.email.toLowerCase() == viewerEmail.toLowerCase(),
          orElse: () => User(
            uuid: 'unknown-${viewerEmail}',
            fullName: viewerEmail.split('@').first,
            email: viewerEmail,
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
      _members.removeWhere((m) => m['id'] == userId);
      return null;
    } catch (e) {
      debugPrint('Error removing user access: $e');
      return 'Erreur lors de la suppression';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}