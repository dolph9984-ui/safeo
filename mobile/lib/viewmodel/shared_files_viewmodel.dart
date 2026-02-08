import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/utils/file_name_util.dart';

class SharedFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = FileModel();
  final sessionModel = SessionModel();

  final TextEditingController searchController = TextEditingController();

  User? _user;
  List<AppFile>? _sharedFiles;
  List<AppFile>? _filteredFiles;

  FileFilterEnum _currentFilter = FileFilterEnum.all;

  List<AppFile> get sharedFiles => _filteredFiles ?? [];
  FileFilterEnum get currentFilter => _currentFilter;
  User? get currentUser => _user;

  SharedFilesViewModel() {
    searchController.addListener(_applyFilters);
  }

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
    fileModel.getSharedFiles().then((res) {
      _sharedFiles = res;
      _filteredFiles = res;
      notifyListeners();
    });
  }

  void setFilter(FileFilterEnum filter) {
    _currentFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    final query = searchController.text.toLowerCase();

    List<AppFile> filtered = _sharedFiles ?? [];

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
          FileNameUtil.getExtension(file.name),
        ) == targetType;
      }).toList();
    }

    if (_currentFilter == FileFilterEnum.owner && _user != null) {
      filtered = filtered.where((file) => file.owner.uuid == _user!.uuid).toList();
    } else if (_currentFilter == FileFilterEnum.viewer && _user != null) {
      filtered = filtered.where((file) {
        return file.owner.uuid != _user!.uuid &&
            (file.viewersName?.contains(_user!.email) ?? false);
      }).toList();
    }

    if (query.isNotEmpty) {
      filtered = filtered.where((file) {
        return file.name.toLowerCase().contains(query);
      }).toList();
    }

    _filteredFiles = filtered;
    notifyListeners();
  }

  AppFile? getFileById(String id) {
    try {
      return _sharedFiles?.firstWhere((file) => file.id == id);
    } catch (e) {
      return null;
    }
  }

  void openFile(AppFile file) async {
    fileModel.openFile(file);
  }

  void renameFile(AppFile file, {required String newName}) async {
    if (file.name == newName) return;

    fileModel.renameFile(file, newName: newName).then((res) {
      int index = _sharedFiles?.indexOf(file) ?? -1;
      if (index != -1) _sharedFiles![index] = file.copyWith(name: newName);
      notifyListeners();
    });
  }

  void downloadFile(AppFile file) async {
    fileModel.downloadFile(file);
  }

  void deleteFile(AppFile file) async {
    fileModel.deleteFile(file).then((res) {
      _sharedFiles?.removeWhere((e) => e == file);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    searchController.removeListener(_applyFilters);
    searchController.dispose();
    super.dispose();
  }
}