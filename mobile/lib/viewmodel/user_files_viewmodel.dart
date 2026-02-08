import 'package:flutter/foundation.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/file_name_util.dart';

class UserFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = FileModel();
  final sessionModel = SessionModel();

  User? _user;
  List<AppFile>? _files;
  List<AppFile>? _filteredFiles;

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  FileFilterEnum get currentFilter => _currentFilter;

  int get storageLimit => _user?.storageLimit ?? 5;

  int get storageUsed => _user?.storageUsed ?? 2;

  List<AppFile> get filteredFiles => _filteredFiles ?? [];

  void initUser() {
    if (sessionModel.session == null) {
      sessionModel.destroySession();
      _user = User.none();
      return;
    }
    _user = sessionModel.session!.user;
    notifyListeners();
  }

  void initFiles() {
    fileModel.getUserFiles().then((res) {
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
                      FileNameUtil.getExtension(file.name),
                    ) ==
                    targetType,
              )
              .toList();
  }

  void openFile(AppFile file) async {
    fileModel.openFile(file);
  }

  void renameFile(AppFile file, {required String newName}) async {
    if (file.name == newName) return;

    fileModel.renameFile(file, newName: newName).then((res) {
      int index = _files?.indexOf(file) ?? -1;
      if (index != -1) _files![index] = file.copyWith(name: newName);
      notifyListeners();
    });
  }

  void downloadFile(AppFile file) async {
    fileModel.downloadFile(file);
  }

  void deleteFile(AppFile file) async {
    fileModel.deleteFile(file).then((res) {
      _files?.removeWhere((e) => e == file);
      notifyListeners();
    });
  }
}
