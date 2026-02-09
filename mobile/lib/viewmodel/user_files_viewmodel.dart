import 'package:flutter/foundation.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/services/security/device_auth_service.dart';
import 'package:securite_mobile/utils/file_name_util.dart';

class UserFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = DocumentModel();
  final sessionModel = SessionModel();

  User? _user;
  List<Document>? _files;
  List<Document>? _filteredFiles;

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  FileFilterEnum get currentFilter => _currentFilter;

  int get storageLimit => _user?.storageLimit ?? 5;

  int get storageUsed => _user?.storageUsed ?? 2;

  List<Document> get filteredFiles => _filteredFiles ?? [];

  User? get currentUser => _user;

  void initUser() async {

    if (sessionModel.session == null) {
      sessionModel.destroySession();
      return;
    }
    _user = sessionModel.session!.user;
    notifyListeners();
  }

  void initFiles() {
    fileModel.getUserDocuments().then((res) {
      _files = res;
      _filteredFiles = res;
      notifyListeners();
    });
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

  void openFile(Document file) async {
    fileModel.openFile(file);
  }

  void renameFile(Document file, {required String newName}) async {
    if (file.originalName == newName) return;

    fileModel.renameDocument(file, newName: newName).then((res) {
      int index = _files?.indexOf(file) ?? -1;
      if (index != -1) _files![index] = file.copyWith(originalName: newName);
      notifyListeners();
    });
  }

  void downloadFile(Document file) async {
    fileModel.downloadFile(file);
  }

  void deleteFile(Document file) async {
    fileModel.deleteDocument(file).then((res) {
      _files?.removeWhere((e) => e == file);
      notifyListeners();
    });
  }
}
