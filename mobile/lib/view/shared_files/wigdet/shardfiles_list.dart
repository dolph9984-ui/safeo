import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class SharedFilesList extends StatelessWidget {
  final String filterLabel;
  final List<Widget> files;
  final VoidCallback onFilterTap;
  final bool showFilterButton;
  final String messageOnEmpty;

  const SharedFilesList({
    super.key,
    required this.filterLabel,
    required this.files,
    required this.onFilterTap,
    required this.showFilterButton,
    required this.messageOnEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        _title(filterLabel, onFilterTap, showFilterButton),
        if (files.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              messageOnEmpty,
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                fontSize: 14,
                color: AppColors.mutedForeground,
              ),
            ),
          )
        else
          Column(spacing: 16, children: files),
      ],
    );
  }

  static Widget _title(
    String filterLabel,
    VoidCallback onFilterTap,
    showFilterButton,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fichiers partagés',
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 18,
                color: AppColors.foreground,
              ),
            ),
            Text(
              filterLabel,
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
