import 'package:flutter/material.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class SearchPageViewModel extends ChangeNotifier {
  final DocumentModel documentModel;
  final SessionModel _sessionModel;
  final TextEditingController searchController = TextEditingController();

  User? _currentUser;
  List<Document> _allFiles = [];
  List<Document> _searchResults = [];
  bool _isSearching = false;
  bool _isLoading = false;

  List<Document> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  bool get hasQuery => searchController.text.trim().isNotEmpty;
  User? get currentUser => _currentUser;

  SearchPageViewModel({
    DocumentModel? documentModel,
    SessionModel? sessionModel,
  })  : documentModel = documentModel ?? DocumentModel(),
        _sessionModel = sessionModel ?? SessionModel() {
    searchController.addListener(_onSearchChanged);
    _init();
  }

  Future<void> _init() async {
    await initUser();
    await _loadAllFiles();
  }

  Future<void> initUser() async {
    if (_sessionModel.session == null) {
      _sessionModel.destroySession();
      _currentUser = User.none();
      return;
    }
    _currentUser = _sessionModel.session!.user;
    notifyListeners();
  }

  Future<void> _loadAllFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userFiles = await documentModel.getUserDocuments();

      List<Document> sharedFiles = [];
      try {
        final shared = await documentModel.getSharedDocuments();
        sharedFiles = shared ?? [];
      } catch (_) {
        // erreur ignorée volontairement
      }

      _allFiles = [...userFiles, ...sharedFiles];
    } catch (_) {
      _allFiles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();

    if (query.isEmpty) {
      _searchResults = [];
      _isSearching = false;
    } else {
      _isSearching = true;
      _performSearch(query);
    }
    notifyListeners();
  }

  void _performSearch(String query) {
    final lowerQuery = query.toLowerCase();

    _searchResults = _allFiles
        .where(
          (file) => file.originalName.toLowerCase().contains(lowerQuery),
        )
        .toList();
  }

  void clearSearch() {
    searchController.clear();
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _loadAllFiles();
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}
