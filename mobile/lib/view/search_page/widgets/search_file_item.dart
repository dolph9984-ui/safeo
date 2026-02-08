import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/view/widgets/file_thumbnail.dart';

class SearchFileItem extends StatelessWidget {
  final String id;
  final String fileName;
  final double fileSize;
  final DateTime dateTime;
  final FileTypeEnum fileType;
  final String? searchQuery;

  const SearchFileItem({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.dateTime,
    required this.fileType,
    required this.id,
    this.searchQuery,
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
                  _buildHighlightedText(),
                  Text(
                    formatDateTime(dateTime),
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
    );
  }

  Widget _buildHighlightedText() {
    if (searchQuery == null || searchQuery!.isEmpty) {
      return Text(
        fileName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: AppFonts.productSansMedium,
          fontSize: 15,
          color: AppColors.foreground,
        ),
      );
    }

    final lowerFileName = fileName.toLowerCase();
    final lowerQuery = searchQuery!.toLowerCase();
    final index = lowerFileName.indexOf(lowerQuery);

    if (index == -1) {
      return Text(
        fileName,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: AppFonts.productSansMedium,
          fontSize: 15,
          color: AppColors.foreground,
        ),
      );
    }

    final beforeMatch = fileName.substring(0, index);
    final match = fileName.substring(index, index + searchQuery!.length);
    final afterMatch = fileName.substring(index + searchQuery!.length);

    return RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: TextStyle(
          fontFamily: AppFonts.productSansMedium,
          fontSize: 15,
          color: AppColors.foreground,
        ),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: TextStyle(
              backgroundColor: AppColors.blue400,
              color: AppColors.primaryLight,
              fontFamily: AppFonts.productSansMedium,
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day} ${MonthEnum.values[dateTime.month - 1].name} ${dateTime.year}';
  }
}
