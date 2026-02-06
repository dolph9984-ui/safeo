import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/view/widgets/file_thumbnail.dart';

class FileItem extends StatelessWidget {
  final String id;
  final String fileName;
  final double fileSize;
  final DateTime dateTime;
  final FileTypeEnum fileType;
  final Function(String id) onButtonTap;

  const FileItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.dateTime,
    required this.fileType,
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
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          spacing: 16,
          children: [
            // icon & title
            Expanded(
              child: Row(
                spacing: 10,
                children: [
                  FileThumbnail(
                    file: PlatformFile.fromMap({
                      "name": fileName,
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
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
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

                        Text(
                          '$fileSize MB, ${formatDateTime(dateTime)}',
                          style: TextStyle(
                            fontFamily: AppFonts.productSansRegular,
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // trailing icon
            Transform.translate(
              offset: Offset(4, 0),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onButtonTap(id),
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
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day} ${MonthEnum.values[dateTime.month - 1].name} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute}';
  }
}
