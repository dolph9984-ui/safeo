import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class SharedFilesList extends StatelessWidget {
  final String listTitle;
  final List<Widget> files;

  const SharedFilesList({
    super.key,
    required this.listTitle,
    required this.files,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        _title(listTitle),
        Column(spacing: 16, children: files),
      ],
    );
  }

  static Widget _title(String title) {
    return Row(
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

        InkWell(
          onTap: () {},
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: SvgPicture.asset('assets/icons/filter.svg'),
        ),
      ],
    );
  }
}
