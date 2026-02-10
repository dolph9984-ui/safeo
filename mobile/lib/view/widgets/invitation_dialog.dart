import 'package:flutter/material.dart';
import 'package:securite_mobile/utils/share_dialog_helper.dart';

class InvitationDialog extends StatefulWidget {
  final String token;
  final String? fileName;
  final String? userName;

  const InvitationDialog({
    super.key,
    required this.token,
    this.fileName,
    this.userName,
  });

  @override
  State<InvitationDialog> createState() => _InvitationDialogState();
}

class _InvitationDialogState extends State<InvitationDialog> {
  bool _opened = false;

  @override
  void initState() {
    super.initState();

    // évite une ouverture multiple si rebuild
    if (_opened) return;
    _opened = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showShareInvitationDialog(
        context: context,
        token: widget.token,
        fileName: widget.fileName ?? '',
        ownerName: widget.userName ?? '',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand();
  }
}
