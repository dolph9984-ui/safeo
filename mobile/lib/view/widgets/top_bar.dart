import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? imageUrl;

  const TopBar({super.key, this.imageUrl});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.background,
      automaticallyImplyActions: false,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 19),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Safeo",
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 22,
                color: AppColors.primary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 17,
                child: (imageUrl != null)
                    ? Image.network(imageUrl!, height: 34, width: 34)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
