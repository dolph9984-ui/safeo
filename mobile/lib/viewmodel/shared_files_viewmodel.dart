import 'package:flutter/cupertino.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/file_name_util.dart';

class LoadingState {
  final bool state;
  final String message;

  LoadingState({required this.state, required this.message});
}

enum ActionResult { error, success }

class SharedFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = DocumentModel();
  final sessionModel = SessionModel();

  User? _user;
  List<Document>? _sharedFiles;
  List<Document>? _filteredFiles;
  String _searchQuery = '';

  LoadingState loading = LoadingState(state: false, message: '');

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  FileFilterEnum get currentFilter => _currentFilter;

  List<Document> get filteredFiles => _filteredFiles ?? [];

  List<Document> get sharedFiles => _sharedFiles ?? [];

  User? get currentUser => _user;

  void _setLoading(bool state, [String message = '']) {
    loading = LoadingState(state: state, message: message);
    notifyListeners();
  }

  void initUser() {
    if (sessionModel.session == null) {
      sessionModel.destroySession();
      return;
    }
    _user = sessionModel.session!.user;
    notifyListeners();
  }

  Future<void> fetchFiles() async {
    _setLoading(true, 'Récupération des fichiers partagés');
    try {
      _sharedFiles = await fileModel.getSharedDocuments();
      _filteredFiles = _sharedFiles;
      _applyFiltersAndSearch();
    } finally {
      _setLoading(false);
    }
  }

  void setCurrentFilter(FileFilterEnum newFilter) {
    _currentFilter = newFilter;
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void searchFiles(String query) {
    _searchQuery = query.toLowerCase();
    _applyFiltersAndSearch();
    notifyListeners();
  }

  void _applyFiltersAndSearch() {
    List<Document> filtered = _sharedFiles ?? [];

    // 1. Appliquer les filtres de type de fichier
    const filterMap = {
      FileFilterEnum.pdf: FileTypeEnum.pdf,
      FileFilterEnum.image: FileTypeEnum.image,
      FileFilterEnum.document: FileTypeEnum.document,
      FileFilterEnum.csv: FileTypeEnum.csv,
    };

    final targetType = filterMap[_currentFilter];

    if (targetType != null) {
      filtered = filtered.where((file) {
        return FileTypeEnum.fromExtension(
              FileNameUtil.getExtension(file.originalName),
            ) ==
            targetType;
      }).toList();
    } else if (_currentFilter == FileFilterEnum.owner) {
      filtered = filtered.where((file) => file.isOwner ?? false).toList();
    } else if (_currentFilter == FileFilterEnum.viewer) {
      filtered = filtered.where((file) => !(file.isOwner ?? true)).toList();
    }

    // 2. Appliquer la recherche textuelle
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((file) {
        return file.originalName.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    _filteredFiles = filtered;
  }

  Future<ActionResult> renameFile(Document file, String newName) async {
    if (file.originalName == newName) {
      return ActionResult.success;
    }

    _setLoading(true, 'Renommage du document');

    final res = await fileModel.renameDocument(file, newName: newName);

    if (res) {
      final index = _sharedFiles?.indexOf(file) ?? -1;
      if (index != -1) {
        _sharedFiles![index] = file.copyWith(originalName: newName);
        _applyFiltersAndSearch();
        notifyListeners();
      }
    }

    _setLoading(false);
    return res ? ActionResult.success : ActionResult.error;
  }

  Future<ActionResult> deleteFile(Document file) async {
    _setLoading(true, 'Suppression du document');

    final res = await fileModel.deleteDocument(file);

    if (res) {
      _sharedFiles?.remove(file);
      _applyFiltersAndSearch();
      notifyListeners();
    }

    _setLoading(false);
    return res ? ActionResult.success : ActionResult.error;
  }

  void openFile(Document file) {
    fileModel.openFile(file);
  }

  Future<bool> downloadFile(Document file) async {
    return await fileModel.downloadFile(file);
  }
}
