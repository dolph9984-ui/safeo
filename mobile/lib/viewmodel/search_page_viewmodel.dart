import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';

class SearchPageViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  
  List<SharedFileData> _searchResults = [];
  List<SharedFileData> _recentSearches = [];
  bool _isSearching = false;

  List<SharedFileData> get searchResults => _searchResults;
  List<SharedFileData> get recentSearches => _recentSearches;
  bool get isSearching => _isSearching;
  bool get hasQuery => searchController.text.trim().isNotEmpty;

  SearchPageViewModel() {
    searchController.addListener(_onSearchChanged);
    _loadRecentSearches();
  }

  void _loadRecentSearches() {
    final now = DateTime.now();
    _recentSearches = [
      SharedFileData(
        id: 'r1',
        fileName: 'Rapport_Q4.pdf',
        fileSize: 2.5,
        sharedAt: now.subtract(Duration(hours: 2)),
        fileType: FileTypeEnum.pdf,
        userRole: UserRole.owner,
        ownerName: 'Vous',
        ownerEmail: 'you@example.com',
      ),
      SharedFileData(
        id: 'r2',
        fileName: 'Budget_2024.xlsx',
        fileSize: 1.8,
        sharedAt: now.subtract(Duration(days: 1)),
        fileType: FileTypeEnum.csv,
        userRole: UserRole.viewer,
        ownerName: 'Marie Martin',
        ownerEmail: 'marie@example.com',
      ),
    ];
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
    // Mock search
    final now = DateTime.now();
    final allFiles = [
      SharedFileData(
        id: '1',
        fileName: 'Rapport_Annual_2024.pdf',
        fileSize: 3.2,
        sharedAt: now.subtract(Duration(days: 2)),
        fileType: FileTypeEnum.pdf,
        userRole: UserRole.owner,
        ownerName: 'Jean Dupont',
        ownerEmail: 'jean.dupont@example.com',
      ),
      SharedFileData(
        id: '2',
        fileName: 'Budget_Marketing.xlsx',
        fileSize: 1.5,
        sharedAt: now.subtract(Duration(days: 5)),
        fileType: FileTypeEnum.csv,
        userRole: UserRole.viewer,
        ownerName: 'Marie Martin',
        ownerEmail: 'marie.martin@example.com',
      ),
      SharedFileData(
        id: '3',
        fileName: 'Presentation_Produit.pptx',
        fileSize: 8.7,
        sharedAt: now.subtract(Duration(days: 1)),
        fileType: FileTypeEnum.document,
        userRole: UserRole.owner,
        ownerName: 'Pierre Leblanc',
        ownerEmail: 'pierre.leblanc@example.com',
      ),
      SharedFileData(
        id: '4',
        fileName: 'Logo_Entreprise.png',
        fileSize: 2.1,
        sharedAt: now.subtract(Duration(hours: 3)),
        fileType: FileTypeEnum.image,
        userRole: UserRole.owner,
        ownerName: 'Luc Bernard',
        ownerEmail: 'luc.bernard@example.com',
      ),
    ];

    _searchResults = allFiles
        .where((file) => file.fileName.toLowerCase().contains(query.toLowerCase()))
        .toList();
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

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }
}