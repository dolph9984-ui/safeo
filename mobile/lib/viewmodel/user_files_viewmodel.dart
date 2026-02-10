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

class UserFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = DocumentModel();
  final sessionModel = SessionModel();

  User? _user;
  List<Document>? _files;
  List<Document>? _filteredFiles;

  LoadingState loading = LoadingState(state: false, message: '');

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  FileFilterEnum get currentFilter => _currentFilter;

  int get storageLimit => _user?.storageLimit ?? 5;

  int get storageUsed => _user?.storageUsed ?? 2;

  List<Document> get filteredFiles => _filteredFiles ?? [];

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
    _setLoading(true, 'Récupération des fichiers');
    try {
      _files = await fileModel.getUserDocuments();
      _filteredFiles = _files;
    } finally {
      _setLoading(false);
    }
  }

  void setCurrentFilter(FileFilterEnum newFilter) {
    _currentFilter = newFilter;
    _filterFiles();
    notifyListeners();
  }

  void _filterFiles() {
    const filterMap = {
      FileFilterEnum.pdf: FileTypeEnum.pdf,
      FileFilterEnum.image: FileTypeEnum.image,
      FileFilterEnum.document: FileTypeEnum.document,
      FileFilterEnum.csv: FileTypeEnum.csv,
    };

    final targetType = filterMap[_currentFilter];

    _filteredFiles = targetType == null
        ? _files
        : _files
              ?.where(
                (file) =>
                    FileTypeEnum.fromExtension(
                      FileNameUtil.getExtension(file.originalName),
                    ) ==
                    targetType,
              )
              .toList();
  }

  Future<ActionResult> renameFile(Document file, String newName) async {
    if (file.originalName == newName) {
      return ActionResult.success;
    }

    _setLoading(true);

    final res = await fileModel.renameDocument(file, newName: newName);

    if (res) {
      final index = _files?.indexOf(file) ?? -1;
      if (index != -1) {
        _files![index] = file.copyWith(originalName: newName);
        _filterFiles();
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
      _files?.remove(file);
      _filterFiles();
      notifyListeners();
    }

    _setLoading(false);
    return res ? ActionResult.success : ActionResult.error;
  }

  void openFile(Document file) {
    fileModel.openFile(file);
  }

  void downloadFile(Document file) {
    fileModel.downloadFile(file);
  }
}
