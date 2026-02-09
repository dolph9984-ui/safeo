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
  List<Document> _recentSearches = [];
  bool _isSearching = false;
  bool _isLoading = false;

  List<Document> get searchResults => _searchResults;

  List<Document> get recentSearches => _recentSearches;

  bool get isSearching => _isSearching;

  bool get isLoading => _isLoading;

  bool get hasQuery => searchController.text.trim().isNotEmpty;

  User? get currentUser => _currentUser;

  SearchPageViewModel({
    DocumentModel? documentModel,
    SessionModel? sessionModel,
  }) : documentModel = documentModel ?? DocumentModel(),
       _sessionModel = sessionModel ?? SessionModel() {
    searchController.addListener(_onSearchChanged);
    _init();
  }

  Future<void> _init() async {
    await initUser();
    await _loadAllFiles();
    await _loadRecentSearches();
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
      final sharedFiles = await documentModel.getSharedDocuments();

      _allFiles = [...?userFiles, ...?sharedFiles];
    } catch (e) {
      debugPrint('Error loading files: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadRecentSearches() async {
    _recentSearches = _allFiles.take(3).toList();
    notifyListeners();
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
        .where((file) => file.originalName.toLowerCase().contains(lowerQuery))
        .toList();

    _saveToRecentSearches(_searchResults);
  }

  void _saveToRecentSearches(List<Document> results) {
    if (results.isNotEmpty) {
      final newRecent = results.first;
      _recentSearches.removeWhere((f) => f.id == newRecent.id);
      _recentSearches.insert(0, newRecent);
      if (_recentSearches.length > 10) {
        _recentSearches = _recentSearches.take(10).toList();
      }
    }
  }

  void clearSearch() {
    searchController.clear();
    _searchResults = [];
    _isSearching = false;
    notifyListeners();
  }

  void clearRecentSearches() {
    _recentSearches = [];
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
