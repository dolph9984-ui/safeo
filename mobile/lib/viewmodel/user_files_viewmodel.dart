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
    fileModel.getFiles().then((res) {
      _files = res;
      notifyListeners();
    });
  }
}
