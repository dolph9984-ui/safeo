import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';

class FileThumbnail extends StatelessWidget {
  final PlatformFile? file;
  final String? thumbnailUrl;
  final EdgeInsets? padding;
  final double height;
  final double width;
  final double radius;

  const FileThumbnail({
    super.key,
    this.file,
    this.thumbnailUrl,
    this.padding,
    required this.height,
    required this.width,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    if (file != null && thumbnailUrl != null) {
      throw Exception(
        'One of "file" or "thumbnailUrl" parameter should be null.',
      );
    }

    if (file == null && thumbnailUrl == null) {
      throw Exception('Both "file" and "thumbnailUrl" can\'t be null');
    }

    var fileType = FileTypeEnum.other;
    if (file != null) {
      fileType = FileTypeEnum.fromExtension(file?.extension);
    }

    final thumbnail = file != null
        ? Container(
            clipBehavior: Clip.hardEdge,
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              color: fileType.bgColor,
            ),
            child: Padding(
              padding: fileType == FileTypeEnum.image && file!.path != null
                  ? EdgeInsets.zero
                  : padding ?? EdgeInsets.zero,
              child: fileType == FileTypeEnum.image && file!.path != null
                  ? Image.file(
                      File(file!.path!),
                      height: height,
                      width: width,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Icon(Icons.image, size: 24, color: AppColors.primary),
                    )
                  : SvgPicture.asset(fileType.assetName, fit: BoxFit.contain),
            ),
          )
        : Image.network(
            thumbnailUrl!,
            height: height,
            width: width,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                Icon(Icons.image, size: 24, color: AppColors.primary),
          );

    return thumbnail;
  }
}
