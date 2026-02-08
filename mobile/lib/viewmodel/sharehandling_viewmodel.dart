import 'package:flutter/material.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class ShareHandlingViewModel extends ChangeNotifier {
  final FileModel _fileModel;
  final UserModel _userModel;

  AppFile? _currentFile;
  User? _currentUser;
  List<Map<String, dynamic>> _members = [];
  bool _isLoading = false;

  AppFile? get currentFile => _currentFile;
  List<Map<String, dynamic>> get allMembers => _members;
  bool get isLoading => _isLoading;

  ShareHandlingViewModel({
    required String fileId,
    FileModel? fileModel,
    UserModel? userModel,
  })  : _fileModel = fileModel ?? FileModel(),
        _userModel = userModel ?? UserModel() {
    _init(fileId);
  }

  Future<void> _init(String fileId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _userModel.getCurrentUser();
      final files = await _fileModel.getFiles();
      _currentFile = files?.firstWhere(
        (f) => f.id == fileId,
        orElse: () => files.first,
      );
      await _loadMembers();
    } catch (e) {
      debugPrint('Error initializing ShareHandlingViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadMembers() async {
    if (_currentFile == null || _currentUser == null) return;

    // Propriétaire en premier
    _members = [
      {
        'id': _currentUser!.uuid,
        'name': _currentUser!.fullName,
        'email': _currentUser!.email,
        'isOwner': true,
      },
    ];

    _members.addAll([
      {
        'id': 'viewer_1',
        'name': 'Wade Warren',
        'email': 'wade.warren@yahoo.fr',
        'isOwner': false,
      },
      {
        'id': 'viewer_2',
        'name': 'Robert Fox',
        'email': 'robertfox@gmail.com',
        'isOwner': false,
      },
    ]);

    notifyListeners();
  }

  Future<String?> removeUserAccess(String userId) async {
    if (_currentFile == null) return 'Erreur';

    _isLoading = true;
    notifyListeners();

    try {
      // TODO: Appel API pour retirer l'accès
      
      _members.removeWhere((m) => m['id'] == userId && m['isOwner'] == true);
      
      return null; // Succès
    } catch (e) {
      debugPrint('Error removing user access: $e');
      return 'Erreur lors de la suppression';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}