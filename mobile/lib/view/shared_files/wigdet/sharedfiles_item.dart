import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/view/widgets/file_thumbnail.dart';

class SharedFileItem extends StatelessWidget {
  final String id;
  final String fileName;
  final DateTime dateTime;
  final Function(String id) onButtonTap;

  const SharedFileItem({
    super.key,
    required this.fileName,
    required this.dateTime,
    required this.onButtonTap,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withAlpha(10),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 40,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                        image: AssetImage('assets/icons/avatar.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 35,
                    child: FileThumbnail(
                      file: PlatformFile.fromMap({
                        "name": fileName,
                        "path": "",
                        "bytes": Uint8List(0),
                        "size": 0,
                      }),
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(8),
                      radius: 10,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: AppFonts.productSansMedium,
                      fontSize: 15,
                      color: AppColors.foreground,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Partagé, ${formatDate(dateTime)}',
                    style: TextStyle(
                      fontFamily: AppFonts.productSansRegular,
                      fontSize: 13,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ],
              ),
            ),

            // MENU
            Transform.translate(
              offset: const Offset(4, 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onButtonTap(id),
                  borderRadius: BorderRadius.circular(50),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_vert,
                      size: 24,
                      color: AppColors.mutedForeground,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) {
    final month = MonthEnum.values[dateTime.month - 1].name;
    return '${dateTime.day} $month ${dateTime.year}';
  }
}
