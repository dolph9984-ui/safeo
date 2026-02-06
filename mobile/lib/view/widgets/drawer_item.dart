import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class DrawerItem extends StatelessWidget {
  final String label;
  final String assetName;
  final Function() onTap;
  final Color color;

  const DrawerItem({
    super.key,
    required this.label,
    required this.assetName,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Ink(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            spacing: 16,
            children: [
              SvgPicture.asset(
                assetName,
                height: 20,
                width: 20,
                colorFilter: ColorFilter.mode(
                  color.withAlpha(180),
                  BlendMode.srcIn,
                ),
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
