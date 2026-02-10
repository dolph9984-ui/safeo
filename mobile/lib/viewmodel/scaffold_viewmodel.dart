import 'package:flutter/material.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

class ScaffoldViewModel extends ChangeNotifier {
  UserFilesViewModel filesVm;
  SharedFilesViewModel sharedFilesVm;

  ScaffoldViewModel({required this.filesVm, required this.sharedFilesVm}) {
    filesVm.addListener(_onFilesVmChanged);
    sharedFilesVm.addListener(_onSharedFilesVmChanged);
  }

  void _onFilesVmChanged() {
    notifyListeners();
  }

  void _onSharedFilesVmChanged() {
    notifyListeners();
  }

  final userModel = UserModel();
  final sessionModel = SessionModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? _user;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String get userName => _user?.fullName ?? '?';

  String get imageProfileUrl => _user?.imageUrl ?? '';

  String get email => _user?.email ?? '';

  int get filesNumber => filesVm.files?.length ?? 0;

  int get sharedFilesNumber => sharedFilesVm.sharedFiles.length;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void init() {
    if (sessionModel.session == null) {
      sessionModel.destroySession();
      _user = null;
      return;
    }
    _user = sessionModel.session!.user;
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    sessionModel.destroySession();
    notifyListeners();
  }

  @override
  void dispose() {
    filesVm.removeListener(_onFilesVmChanged);
    sharedFilesVm.removeListener(_onSharedFilesVmChanged);
    super.dispose();
  }
}
