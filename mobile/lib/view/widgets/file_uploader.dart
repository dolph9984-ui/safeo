import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class FileUploader extends StatelessWidget {
  final Function() onTap;

  const FileUploader({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      childOnTop: false,
      options: RoundedRectDottedBorderOptions(
        dashPattern: [5, 5],
        color: AppColors.foreground,
        radius: Radius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          color: Colors.white,
          child: Column(
            spacing: 16,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.blue50,
                radius: 26,
                child: SvgPicture.asset(
                  'assets/icons/image_add.svg',
                  height: 24,
                ),
              ),
              Column(
                spacing: 4,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cliquer ',
                        style: TextStyle(
                          fontFamily: AppFonts.productSansMedium,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        'pour ajouter votre document',
                        style: TextStyle(
                          fontFamily: AppFonts.productSansMedium,
                          color: AppColors.foreground,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Formats acceptés: PDF, DOC, DOCX, CSV, JPG, JPEG',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppFonts.productSansRegular,
                      color: AppColors.mutedForeground,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
