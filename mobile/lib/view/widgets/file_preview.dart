import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class FilePreview extends StatelessWidget {
  final String fileName;
  final double sizeInMB;
  final Function() onEditTap;
  final Function() onDeleteTap;

  const FilePreview({
    super.key,
    required this.fileName,
    required this.sizeInMB,
    required this.onEditTap,
    required this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                width: 160,
                height: 128,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.primary,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    spacing: 8,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: onEditTap,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x80000000),
                          ),
                          child: SvgPicture.asset(
                            height: 16,
                            'assets/icons/edit_filled.svg',
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),

                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: onDeleteTap,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0x80000000),
                          ),
                          child: SvgPicture.asset(
                            height: 16,
                            'assets/icons/trash_filled.svg',
                            colorFilter: ColorFilter.mode(
                              Colors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                fileName,
                style: TextStyle(
                  fontFamily: AppFonts.productSansRegular,
                  fontSize: 14,
                  color: AppColors.foreground,
                ),
              ),
              Text(
                '$sizeInMB MB',
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
    );
  }
}
