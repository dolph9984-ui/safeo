import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';

class FilesList extends StatelessWidget {
  final String listTitle;
  final bool showSearchIcon;
  final VoidCallback onSearchTap;
  final VoidCallback onFilterTap;
  final List<Widget> files;
  final FileFilterEnum currentFilter;

  const FilesList({
    super.key,
    required this.listTitle,
    required this.showSearchIcon,
    required this.files,
    required this.onSearchTap,
    required this.onFilterTap,
    required this.currentFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        title(
          title: listTitle,
          showSearchIcon: showSearchIcon,
          onSearchTap: onSearchTap,
          onFilterTap: onFilterTap,
          currentFilter: currentFilter,
        ),
        files.isEmpty
            ? Text(
                'Aucun fichier pour le moment.',
                style: TextStyle(
                  fontFamily: AppFonts.productSansRegular,
                  color: AppColors.mutedForeground,
                  fontSize: 14,
                ),
              )
            : Column(spacing: 16, children: files),
      ],
    );
  }

  Widget title({
    required String title,
    required bool showSearchIcon,
    required VoidCallback onSearchTap,
    required VoidCallback onFilterTap,
    required FileFilterEnum currentFilter,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 18,
                color: AppColors.foreground,
              ),
            ),
            Text(
              currentFilter.label,
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
        Row(
          spacing: 8,
          children: [
            if (showSearchIcon)
              InkWell(
                onTap: onSearchTap,
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: SvgPicture.asset('assets/icons/search.svg'),
              ),

            InkWell(
              onTap: onFilterTap,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              child: SvgPicture.asset('assets/icons/filter.svg'),
            ),
          ],
        ),
      ],
    );
  }
}
