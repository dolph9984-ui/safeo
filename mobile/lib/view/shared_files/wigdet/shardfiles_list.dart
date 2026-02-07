import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class SharedFilesList extends StatelessWidget {
  final String filterLabel;
  final List<Widget> files;
  final VoidCallback onFilterTap;

  const SharedFilesList({
    super.key,
    required this.filterLabel,
    required this.files,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        _title(filterLabel, onFilterTap),
        if (files.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Text(
              'Aucun fichier trouvé',
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

  static Widget _title(String filterLabel, VoidCallback onFilterTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4,
          children: [
            Text(
              'Fichiers partagés',
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 16,
                color: AppColors.foreground,
              ),
            ),
            Text(
              filterLabel,
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                fontSize: 12,
                color: AppColors.mutedForeground,
              ),
            ),
          ],
        ),
        InkWell(
          onTap: onFilterTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: SvgPicture.asset('assets/icons/filter.svg', width: 30,height: 30,),
        ),
      ],
    );
  }
}