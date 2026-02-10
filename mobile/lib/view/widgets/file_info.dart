import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/utils/file_size_util.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_fonts.dart';
import 'blurred_dialog.dart';

class FileInfo extends StatelessWidget {
  final Document file;

  const FileInfo({super.key, required this.file});

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
          spacing: 8,
          children: [
            Text(
              file.originalName,
              style: TextStyle(
                color: AppColors.foreground,
                fontSize: 20,
                fontFamily: AppFonts.productSansMedium,
              ),
            ),

            Divider(color: AppColors.buttonDisabled),

            Column(
              spacing: 12,
              children: [
                _buildInfoRow(
                  'Taille',
                  '${FileSizeUtil.bytesToMb(file.fileSize)} MB',
                ),
                _buildInfoRow('Type', file.fileType.toUpperCase()),
                _buildInfoRow('Partagé le', _formatDate(file.updatedAt)),
                _buildInfoRow('Propriétaire', file.owner.fullName),
                _buildInfoRow(
                  'Votre rôle',
                  SessionModel().session?.user.uuid == file.userId
                      ? 'Propriétaire'
                      : 'Lecteur',
                ),
              ],
            ),

            Divider(color: AppColors.buttonDisabled),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => context.pop(),
                child: Text('Fermer'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.productSansMedium,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.productSansRegular,
              fontSize: 14,
              color: AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${MonthEnum.values[date.month - 1].name} ${date.year}';
  }
}
