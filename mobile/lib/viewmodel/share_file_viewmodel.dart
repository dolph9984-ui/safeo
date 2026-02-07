import 'package:flutter/material.dart';

enum ShareRole {
  owner,
  viewer,
}

class ShareMemberUiModel {
  final String id;
  final String name;
  final String email;
  final String avatarUrl;
  final ShareRole role;

  ShareMemberUiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
  });
}

class ShareFileViewModel extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  String _emailToInvite = '';

  String get emailToInvite => _emailToInvite;

  final List<ShareMemberUiModel> _members = [
    ShareMemberUiModel(
      id: '1',
      name: 'Emadisson Loick',
      email: 'johankrito64@gmail.com',
      avatarUrl: 'assets/icons/avatar.png',
      role: ShareRole.owner,
    ),
    ShareMemberUiModel(
      id: '2',
      name: 'Wade Warren',
      email: 'wade.warren@yahoo.fr',
      avatarUrl: 'assets/icons/avatar.png',
      role: ShareRole.viewer,
    ),
    ShareMemberUiModel(
      id: '3',
      name: 'Robert Fox',
      email: 'roberfox@gmail.com',
      avatarUrl: 'assets/icons/avatar.png',
      role: ShareRole.viewer,
    ),
  ];

  List<ShareMemberUiModel> get members => _members;

  void onInviteEmailChanged(String value) {
    _emailToInvite = value;
    notifyListeners();
  }

  bool get canSendInvite => _emailToInvite.isNotEmpty;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
