import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class BottomSheetItem extends StatelessWidget {
  final String label;
  final String assetName;
  final Function() onTap;
  final Color color;

  const BottomSheetItem({
    super.key,
    required this.label,
    required this.assetName,
    required this.onTap,
    required this.color, Icon? trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        height: 48,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            spacing: 16,
            children: [
              SvgPicture.asset(
                assetName,
                height: 18,
                width: 18,
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: AppFonts.productSansRegular,
                  fontSize: 16,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
