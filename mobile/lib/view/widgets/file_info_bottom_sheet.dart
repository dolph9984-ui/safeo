import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/view/widgets/file_thumbnail.dart';

class FileInfoBottomSheet extends StatelessWidget {
  final AppFile file;

  const FileInfoBottomSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      enableDrag: false,
      onClosing: () {},
      builder: (context) => Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 40,
        ),
        child: Column(
          spacing: 12,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 8,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    FileThumbnail(
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(8),
                      radius: 10,
                      file: PlatformFile.fromMap({
                        "name": file.name,
                        "path": "",
                        "bytes": Uint8List(0),
                        "size": 0,
                      }),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          file.name,
                          style: TextStyle(
                            fontFamily: AppFonts.productSansMedium,
                            fontSize: 16,
                            color: AppColors.foreground,
                          ),
                        ),
                        Text(
                          'Importé le : ${file.updatedAt.toString()}',
                          style: TextStyle(
                            fontFamily: AppFonts.productSansRegular,
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            Divider(color: AppColors.buttonDisabled),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Text(
                  'Propriétaire : ${file.owner.fullName}',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 12,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Taille : ${file.size}',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 12,
                    color: AppColors.foreground,
                  ),
                ),

                Text(
                  'Partagé : ${file.isShared}',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 12,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  'Dernière modification : ${file.updatedAt}',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 12,
                    color: AppColors.foreground,
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
