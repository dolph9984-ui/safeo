import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String? imageUrl;
  final String username;

  final Function() onImageTap;

  const TopBar({
    super.key,
    this.imageUrl,
    required this.onImageTap,
    required this.username,
  });

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
            InkWell(
              borderRadius: BorderRadius.circular(50),
              onTap: onImageTap,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 17,
                  child: (imageUrl != null)
                      ? Image.network(
                          imageUrl!,
                          height: 34,
                          width: 34,
                          errorBuilder: (_, _, _) {
                            return username.trim().isNotEmpty
                                ? Text(
                                    username[0],
                                    style: TextStyle(
                                      fontFamily: AppFonts.zalandoSans,
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/icons/user.svg',
                                    height: 18,
                                  );
                          },
                        )
                      : username.trim().isNotEmpty
                      ? Text(
                          username[0],
                          style: TextStyle(
                            fontFamily: AppFonts.zalandoSans,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        )
                      : SvgPicture.asset('assets/icons/user.svg', height: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
