import 'package:flutter/material.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/model/user_model.dart';

class ScaffoldViewModel extends ChangeNotifier {
  final userModel = UserModel();
  final sessionModel = SessionModel();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  User? _user;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String get userName => _user?.fullName ?? '?';

  String get imageProfileUrl => _user?.imageUrl ?? '';

  String get email => _user?.email ?? '';

  int get filesNumber => _user?.filesNbr ?? 0;

  int get sharedFilesNumber => _user?.sharedFilesNbr ?? 0;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }

  void init() {
    if (sessionModel.session == null) sessionModel.destroySession();
    _user = sessionModel.session!.user;
  }

  Future<void> logout() async {
    sessionModel.destroySession();
  }
}
