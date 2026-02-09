import 'package:flutter/material.dart';

class Permissions {
  // pas définitif
  static const admin = [];
  static const superAdmin = [...admin];
}

ValueNotifier<bool> isAppUnlocked = ValueNotifier<bool>(false);