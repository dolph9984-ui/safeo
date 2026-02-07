import 'package:flutter/material.dart';

class ScaffoldViewModel extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final String _userName = 'Kirito EM';
  final String _email = 'example@gmail.com';

  String? _imageProfileUrl;

  final int _filesNumber = 0;
  final int _sharedFilesNumber = 0;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  String get userName => _userName;

  String get imageProfileUrl => _imageProfileUrl ?? '';

  String get email => _email;

  int get filesNumber => _filesNumber;

  int get sharedFilesNumber => _sharedFilesNumber;

  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}
