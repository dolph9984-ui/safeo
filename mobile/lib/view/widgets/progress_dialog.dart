import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';

class ProgressDialog extends StatelessWidget {
  final int percent;
  final String label;
  final VoidCallback onCancel;

  const ProgressDialog({
    super.key,
    required this.percent,
    required this.label,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BlurredDialog(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CircularProgressIndicator(
                    value: percent / 100,
                    strokeWidth: 8,
                    backgroundColor: Color(0xFFDFE2F9),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                ),
                Text(
                  '$percent%',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                color: AppColors.foreground,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            SizedBox(height: 32),

            OutlinedButton(
              onPressed: () {
                onCancel();
                context.pop();
              },
              child: Text('Annuler'),
            ),
          ],
        ),
      ),
    );
  }
}
