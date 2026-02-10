import 'package:flutter/material.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/constants/app_colors.dart';

class ShareInvitationDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String fileName,
    required String ownerName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmDialog(
        title: 'Invitation de partage',
        cancelLabel: 'Refuser',
        confirmLabel: 'Accepter',
        confirmBgColor: AppColors.primary,
        onConfirm: () {},
        onCancel: () {},
      ),
    );
  }
}
