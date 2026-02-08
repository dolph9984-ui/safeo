import 'package:flutter/foundation.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class UserFilesViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final fileModel = FileModel();

  User? _user;
  List<AppFile>? _files;

  int get storageLimit => _user?.storageLimit ?? 5;

  int get storageUsed => _user?.storageUsed ?? 2;

  List<AppFile> get files => _files ?? [];

  void initUser() {
    userModel.getCurrentUser().then((res) {
      _user = res;
      notifyListeners();
    });
  }

  void initFiles() {
    fileModel.getUserFiles().then((res) {
      _files = res;
      notifyListeners();
    });
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
