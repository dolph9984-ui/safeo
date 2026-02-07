import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';

enum UserRole { owner, viewer }

enum FileFilter {
  all('Tous les fichiers'),
  owner('Mes fichiers'),
  viewer('Fichiers partagés avec moi'),
  pdf('PDF'),
  image('Images'),
  document('Documents'),
  csv('Tableurs');

  final String label;
  const FileFilter(this.label);
}

class SharedFileData {
  final String id;
  final String fileName;
  final double fileSize;
  final DateTime sharedAt;
  final FileTypeEnum fileType;
  final UserRole userRole;
  final String ownerName;
  final String ownerEmail;

  SharedFileData({
    required this.id,
    required this.fileName,
    required this.fileSize,
    required this.sharedAt,
    required this.fileType,
    required this.userRole,
    required this.ownerName,
    required this.ownerEmail,
  });
}

class SharedFilesViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  
  List<SharedFileData> _sharedFiles = [];
  List<SharedFileData> _filteredFiles = [];
  FileFilter _currentFilter = FileFilter.all;

  List<SharedFileData> get sharedFiles => _filteredFiles;
  FileFilter get currentFilter => _currentFilter;

  SharedFilesViewModel() {
    _loadMockData();
    searchController.addListener(_applyFilters);
  }

  void _loadMockData() {
    final now = DateTime.now();
    _sharedFiles = [
      SharedFileData(
        id: '1',
        fileName: 'Rapport_Q1_2024.pdf',
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
        fileName: 'Contrat_Client_A.docx',
        fileSize: 0.9,
        sharedAt: now.subtract(Duration(days: 7)),
        fileType: FileTypeEnum.document,
        userRole: UserRole.viewer,
        ownerName: 'Sophie Durand',
        ownerEmail: 'sophie.durand@example.com',
      ),
      SharedFileData(
        id: '5',
        fileName: 'Logo_Entreprise.png',
        fileSize: 2.1,
        sharedAt: now.subtract(Duration(hours: 3)),
        fileType: FileTypeEnum.image,
        userRole: UserRole.owner,
        ownerName: 'Luc Bernard',
        ownerEmail: 'luc.bernard@example.com',
      ),
      SharedFileData(
        id: '6',
        fileName: 'Photo_Equipe.jpg',
        fileSize: 4.5,
        sharedAt: now.subtract(Duration(days: 4)),
        fileType: FileTypeEnum.image,
        userRole: UserRole.viewer,
        ownerName: 'Anne Petit',
        ownerEmail: 'anne.petit@example.com',
      ),
    ];
    _filteredFiles = _sharedFiles;
    notifyListeners();
  }

  void setFilter(FileFilter filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();
    
    // Appliquer le filtre de type
    List<SharedFileData> filtered = _sharedFiles;

    switch (_currentFilter) {
      case FileFilter.owner:
        filtered = filtered.where((file) => file.userRole == UserRole.owner).toList();
        break;
      case FileFilter.viewer:
        filtered = filtered.where((file) => file.userRole == UserRole.viewer).toList();
        break;
      case FileFilter.pdf:
        filtered = filtered.where((file) => file.fileType == FileTypeEnum.pdf).toList();
        break;
      case FileFilter.image:
        filtered = filtered.where((file) => file.fileType == FileTypeEnum.image).toList();
        break;
      case FileFilter.document:
        filtered = filtered.where((file) => file.fileType == FileTypeEnum.document).toList();
        break;
      case FileFilter.csv:
        filtered = filtered.where((file) => file.fileType == FileTypeEnum.csv).toList();
        break;
      case FileFilter.all:
        break;
    }

    // Appliquer la recherche
    if (query.isNotEmpty) {
      filtered = filtered.where((file) {
        return file.fileName.toLowerCase().contains(query);
      }).toList();
    }

    _filteredFiles = filtered;
    notifyListeners();
  }

  SharedFileData? getFileById(String id) {
    try {
      return _sharedFiles.firstWhere((file) => file.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_applyFilters);
    searchController.dispose();
    super.dispose();
  }
}