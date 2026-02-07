import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class FileVisibilityCard extends StatelessWidget {
  final String label;
  final String description;
  final String iconPath;
  final bool selected;
  final Function() onTap;

  const FileVisibilityCard({
    super.key,
    required this.label,
    required this.description,
    required this.iconPath,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Ink(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        AppColors.foreground,
                        BlendMode.srcIn,
                      ),
                    ),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: AppFonts.productSansRegular,
                        fontSize: 16,
                        color: AppColors.foreground,
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 14,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
            if (selected)
              SvgPicture.asset(
                'assets/icons/check.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
