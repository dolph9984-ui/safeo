import 'package:flutter/material.dart';
import 'package:securite_mobile/model/file_model.dart';

class SearchPageViewModel extends ChangeNotifier {
  final FileModel _fileModel;
  final TextEditingController searchController = TextEditingController();
  
  List<AppFile> _allFiles = [];
  List<AppFile> _searchResults = [];
  List<AppFile> _recentSearches = [];
  bool _isSearching = false;
  bool _isLoading = false;

  List<AppFile> get searchResults => _searchResults;
  List<AppFile> get recentSearches => _recentSearches;
  bool get isSearching => _isSearching;
  bool get isLoading => _isLoading;
  bool get hasQuery => searchController.text.trim().isNotEmpty;

  SearchPageViewModel({FileModel? fileModel}) 
      : _fileModel = fileModel ?? FileModel() {
    searchController.addListener(_onSearchChanged);
    _init();
  }

  Future<void> _init() async {
    await _loadAllFiles();
    await _loadRecentSearches();
  }

  Future<void> _loadAllFiles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final files = await _fileModel.getFiles();
      if (files != null) {
        _allFiles = files;
      }
    } catch (e) {
      debugPrint('Error loading files: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadRecentSearches() async {
    // TODO: Charger depuis le cache local ou shared preferences
    // Pour l'instant, on prend les 5 derniers fichiers
    _recentSearches = _allFiles.take(5).toList();
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
        .where((file) => file.name.toLowerCase().contains(lowerQuery))
        .toList();
    
    // Optionnel: Sauvegarder dans les recherches récentes
    _saveToRecentSearches(_searchResults);
  }

  void _saveToRecentSearches(List<AppFile> results) {
    // TODO: Implémenter la sauvegarde dans SharedPreferences
    // Pour l'instant, on met à jour en mémoire
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
    // TODO: Aussi effacer du cache local
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