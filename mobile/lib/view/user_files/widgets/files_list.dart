import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class FilesList extends StatelessWidget {
  final String listTitle;
  final bool showSearchIcon;
  final List<Widget> files;

  const FilesList({
    super.key,
    required this.listTitle,
    required this.showSearchIcon,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        title(listTitle, showSearchIcon),
        Column(spacing: 16, children: files),
      ],
    );
  }

  static Widget title(String title, bool showSearchIcon) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.zalandoSans,
            fontSize: 16,
            color: AppColors.foreground,
          ),
        ),
        Row(
          spacing: 8,
          children: [
            if (showSearchIcon)
              InkWell(
                onTap: () {},
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                child: SvgPicture.asset('assets/icons/search.svg'),
              ),

            InkWell(
              onTap: () {},
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
