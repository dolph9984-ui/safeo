// recent_searches_section.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/view/search_page/widgets/search_file_item.dart';

class RecentSearchesSection extends StatelessWidget {
  final List<AppFile> recentFiles;
  final VoidCallback onClearAll;
  final Function(AppFile)? onFileTap;

  const RecentSearchesSection({
    super.key,
    required this.recentFiles,
    required this.onClearAll,
    this.onFileTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recentFiles.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: [
            SvgPicture.asset(
              'assets/icons/search.svg',
              width: 64,
              height: 64,
              colorFilter: ColorFilter.mode(
                AppColors.mutedForeground,
                BlendMode.srcIn,
              ),
            ),
            Text(
              'Rechercher votre Fichier',
              style: TextStyle(
                fontFamily: AppFonts.productSansMedium,
                fontSize: 18,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Récents',
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 16,
                color: AppColors.foreground,
              ),
            ),
            InkWell(
              onTap: onClearAll,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Text(
                'Tout effacer',
                style: TextStyle(
                  fontFamily: AppFonts.productSansMedium,
                  fontSize: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Column(
          spacing: 16,
          children: recentFiles
              .map((file) => SearchFileItem(
                    file: file,
                    onTap: onFileTap != null ? () => onFileTap!(file) : null,
                  ))
              .toList(),
        ),
      ],
    );
  }
}