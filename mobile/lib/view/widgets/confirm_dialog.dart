import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';
import 'blurred_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String? description;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmBgColor;
  final Function() onConfirm;
  final Function() onCancel;

  const ConfirmDialog({
    super.key,
    required this.title,
    this.description,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmBgColor,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlurredDialog(
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.foreground,
                fontSize: 16,
                fontFamily: AppFonts.productSansMedium,
              ),
            ),

            if (description != null)
              Text(
                description!,
                style: TextStyle(
                  color: AppColors.mutedForeground,
                  fontSize: 14,
                  fontFamily: AppFonts.productSansRegular,
                ),
              ),

            Column(
              spacing: 4,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(40, 40),
                      backgroundColor: confirmBgColor,
                    ),
                    onPressed: () {
                      onConfirm();
                      context.pop();
                    },
                    child: Text(confirmLabel),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      onCancel();
                      context.pop();
                    },
                    child: Text(cancelLabel),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
