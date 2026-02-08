import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/file_model.dart'; // ✅ Importer AppFile
import 'package:securite_mobile/view/widgets/file_thumbnail.dart';

class TrashItem extends StatelessWidget {
  final AppFile trashedFile; // ✅ Changé de TrashedFile à AppFile
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onMenuTap;

  const TrashItem({
    super.key,
    required this.trashedFile,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
    required this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: isSelected
              ? Border.all(color: AppColors.primary, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground.withAlpha(10),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 16,
            children: [
              if (isSelectionMode)
                Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.mutedForeground,
                  size: 24,
                ),

              Expanded(
                child: Row(
                  spacing: 10,
                  children: [
                    FileThumbnail(
                      file: PlatformFile.fromMap({
                        "name": trashedFile.name, // ✅ Changé de fileName à name
                        "path": "",
                        "bytes": Uint8List(0),
                        "size": 0,
                      }),
                      height: 40,
                      width: 40,
                      padding: EdgeInsets.all(10),
                      radius: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            trashedFile.name, // ✅ Changé de fileName à name
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontFamily: AppFonts.productSansMedium,
                              fontSize: 15,
                              color: AppColors.foreground,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'Suppression dans ',
                                style: TextStyle(
                                  fontFamily: AppFonts.productSansRegular,
                                  fontSize: 12,
                                  color: AppColors.mutedForeground,
                                ),
                              ),
                              Text(
                                _getSuppressionDate(),
                                style: TextStyle(
                                  fontFamily: AppFonts.productSansRegular,
                                  fontSize: 12,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (!isSelectionMode)
                Transform.translate(
                  offset: Offset(4, 0),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onMenuTap,
                      borderRadius: BorderRadius.circular(50),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: SvgPicture.asset(
                          'assets/icons/more_vert.svg',
                          colorFilter: ColorFilter.mode(
                            AppColors.mutedForeground,
                            BlendMode.srcIn,
                          ),
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSuppressionDate() {
    // ✅ Calculer la date de suppression automatique (30 jours après updatedAt)
    final deletionDate = trashedFile.updatedAt.add(Duration(days: 30));
    final daysRemaining = deletionDate.difference(DateTime.now()).inDays;

    String deletionText = daysRemaining > 0
        ? '$daysRemaining jour${daysRemaining > 1 ? 's' : ''}'
        : 'imminente';

    return deletionText;
  }
}