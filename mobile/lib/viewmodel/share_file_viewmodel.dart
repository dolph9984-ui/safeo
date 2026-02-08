import 'package:flutter/material.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class ShareFileViewModel extends ChangeNotifier {
  final FileModel _fileModel;
  final UserModel _userModel;
  final TextEditingController searchController = TextEditingController();

  AppFile? _currentFile;
  User? _currentUser;
  List<User> _sharedWith = [];
  List<User> _searchResults = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String _emailToInvite = '';

  final List<User> _availableUsers = [
    User(
      uuid: '2',
      fullName: 'Wade Warren',
      email: 'wade.warren@yahoo.fr',
      filesNbr: 3,
      sharedFilesNbr: 1,
      storageLimit: 1024 * 1024 * 1024,
      storageUsed: 500 * 1024 * 1024,
      createdAt: DateTime.now(),
      imageUrl: null,
    ),
    User(
      uuid: '3',
      fullName: 'Robert Fox',
      email: 'robertfox@gmail.com',
      filesNbr: 5,
      sharedFilesNbr: 2,
      storageLimit: 1024 * 1024 * 1024,
      storageUsed: 300 * 1024 * 1024,
      createdAt: DateTime.now(),
      imageUrl: null,
    ),
  ];

  AppFile? get currentFile => _currentFile;
  User? get currentUser => _currentUser;
  List<User> get sharedWith => _sharedWith;
  List<User> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String get emailToInvite => _emailToInvite;
  bool get canSendInvite => _isValidEmail(_emailToInvite);
  bool get hasSearchResults => _searchResults.isNotEmpty;

  ShareFileViewModel({
    required String fileId,
    FileModel? fileModel,
    UserModel? userModel,
  })  : _fileModel = fileModel ?? FileModel(),
        _userModel = userModel ?? UserModel() {
    searchController.addListener(_onSearchChanged);
    _init(fileId);
  }

  Future<void> _init(String fileId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _userModel.getCurrentUser();
      final files = await _fileModel.getUserFiles();
      _currentFile = files?.firstWhere(
        (f) => f.id == fileId,
        orElse: () => files.first,
      );
      await _loadSharedUsers();
    } catch (e) {
      debugPrint('Error initializing ShareFileViewModel: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSharedUsers() async {
    if (_currentFile == null) return;
    _sharedWith = [];
    notifyListeners();
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    _emailToInvite = query;

    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
    } else {
      _isSearching = true;
      _performSearch(query);
    }
    notifyListeners();
  }

  Future<void> _performSearch(String query) async {
    await Future.delayed(Duration(milliseconds: 300));

    _searchResults = _availableUsers
        .where((user) =>
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    notifyListeners();
  }

  void onInviteEmailChanged(String value) {
    _emailToInvite = value;
    notifyListeners();
  }

  void selectUserSuggestion(User user) {
    searchController.text = user.email;
    _emailToInvite = user.email;
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  Future<String?> shareWithEmail(String email) async {
    if (!_isValidEmail(email) || _currentFile == null) {
      return 'Email invalide';
    }

    // Vérifier si l'utilisateur est le propriétaire
    if (_currentUser != null && email.toLowerCase() == _currentUser!.email.toLowerCase()) {
      return 'Vous êtes déjà le propriétaire de ce fichier';
    }

    // Vérifier si l'utilisateur existe dans le système
    final userExists = _availableUsers.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (!userExists) {
      return 'Utilisateur non trouvé dans le système';
    }

    // Vérifier si l'utilisateur a déjà accès
    final alreadyShared = _sharedWith.any(
      (u) => u.email.toLowerCase() == email.toLowerCase(),
    );

    if (alreadyShared) {
      return 'Cet utilisateur a déjà accès au fichier';
    }

    _isLoading = true;
    notifyListeners();

    try {
      // Trouver l'utilisateur dans la liste disponible
      final user = _availableUsers.firstWhere(
        (u) => u.email.toLowerCase() == email.toLowerCase(),
      );

      await _fileModel.shareFile(
        _currentFile!,
        shareTo: [user],
      );

      _sharedWith.add(user);
      searchController.clear();
      _searchResults = [];
      _isSearching = false;
      _emailToInvite = '';

      return null; 
    } catch (e) {
      debugPrint('Error sharing via email: $e');
      return 'Erreur lors du partage';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> removeUserAccess(User user) async {
    if (_currentFile == null) return 'Erreur';

    _isLoading = true;
    notifyListeners();

    try {
      _sharedWith.removeWhere((u) => u.uuid == user.uuid);
      return null; 
    } catch (e) {
      debugPrint('Error removing user access: $e');
      return 'Erreur lors de la suppression';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void clearSearch() {
    searchController.clear();
    _searchResults = [];
    _isSearching = false;
    _emailToInvite = '';
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}