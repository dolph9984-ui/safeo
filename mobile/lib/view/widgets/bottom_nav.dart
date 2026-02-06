import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class BottomNavItem extends StatelessWidget {
  final Function() onTap;
  final bool isActive;
  final String label;
  final String iconPath;
  final double size;

  const BottomNavItem({
    super.key,
    required this.onTap,
    required this.isActive,
    required this.label,
    required this.iconPath,
    this.size = 21,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: SvgPicture.asset(
                iconPath,
                height: size,
                width: size,
                colorFilter: ColorFilter.mode(
                  isActive ? Colors.white : AppColors.foreground,
                  BlendMode.srcIn,
                ),
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontFamily: AppFonts.productSansMedium,
                fontSize: 11,
                color: isActive ? AppColors.primary : AppColors.foreground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({super.key, required this.onTap, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.only(top: 11, bottom: 10, left: 14, right: 14),
          color: Colors.white,
          height: 83,
          child: Row(
            spacing: 48,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: BottomNavItem(
                  isActive: currentIndex == 0,
                  label: 'Liste des fichiers',
                  iconPath: 'assets/icons/files.svg',
                  onTap: () => onTap(0),
                ),
              ),

              Expanded(
                child: BottomNavItem(
                  isActive: currentIndex == 2,
                  label: 'Partagés',
                  iconPath: 'assets/icons/users_round.svg',
                  size: 20,
                  onTap: () => onTap(2),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -32,
          left: 0,
          right: 0,
          child: Material(
            color: Colors.white, // bordure
            shape: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: Material(
                color: AppColors.primary,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => onTap(1),
                  child: const SizedBox(
                    width: 64,
                    height: 64,
                    child: Center(
                      child: Icon(Icons.add, size: 28, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
