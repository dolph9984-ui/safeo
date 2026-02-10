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
  UserFilesViewModel() {
    initUser();
    fetchFiles();
  }

  final userModel = UserModel();
  final documentModel = DocumentModel();
  final sessionModel = SessionModel();

  User? _user;
  List<Document>? files;
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
      files = await documentModel.getUserDocuments();
      _filteredFiles = files;
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
        ? files
        : files
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

    final res = await documentModel.renameDocument(file, newName: newName);

    if (res) {
      final index = files?.indexOf(file) ?? -1;
      if (index != -1) {
        files![index] = file.copyWith(originalName: newName);
        _filterFiles();
        notifyListeners();
      }
    }

    _setLoading(false);
    return res ? ActionResult.success : ActionResult.error;
  }

  Future<ActionResult> deleteFile(Document document) async {
    _setLoading(true, 'Suppression du document');

    final res = await documentModel.deleteDocument(document);

    if (res) {
      files?.remove(document);
      _filterFiles();
      notifyListeners();
    }

    _setLoading(false);
    return res ? ActionResult.success : ActionResult.error;
  }

  void openFile(Document file) {
    documentModel.openFile(file);
  }

  Future<ActionResult> downloadFile(Document document) async {
    final res = await documentModel.downloadFile(document);
    return res ? ActionResult.success : ActionResult.error;
  }
}
