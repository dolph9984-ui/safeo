import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final String username;
  final String email;
  final int filesNbr;
  final int sharedFilesNbr;
  final Function() onTrashTap;
  final Function() onLogoutTap;

  const AppDrawer({
    super.key,
    required this.username,
    required this.email,
    required this.filesNbr,
    required this.sharedFilesNbr,
    required this.onTrashTap,
    required this.onLogoutTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 16,
                  children: [
                    profileInfo(username, email),
                    Row(
                      spacing: 16,
                      children: [
                        info('Fichier(s)', filesNbr.toString()),
                        info('Partagé(s)', sharedFilesNbr.toString()),
                      ],
                    ),
                    Divider(color: AppColors.buttonDisabled),
                  ],
                ),
              ),

              Spacer(),

              Divider(
                color: AppColors.buttonDisabled,
                indent: 16,
                endIndent: 16,
              ),

              DrawerItem(
                label: 'Consulter la corbeille',
                assetName: 'assets/icons/trash.svg',
                onTap: onTrashTap,
                color: AppColors.foreground,
              ),

              DrawerItem(
                label: 'Se déconnecter',
                assetName: 'assets/icons/logout.svg',
                onTap: onLogoutTap,
                color: AppColors.destructive,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget info(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.productSansMedium,
            color: AppColors.foreground,
            fontSize: 14,
          ),
        ),
        Text(
          ' $label',
          style: TextStyle(
            fontFamily: AppFonts.productSansRegular,
            color: AppColors.mutedForeground,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget profileInfo(String username, String email) {
    final String? profileImgUrl = null;
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(
          radius: 24,
          child: (profileImgUrl != null)
              ? Image.network(
                  profileImgUrl,
                  height: 48,
                  width: 48,
                  errorBuilder: (_, _, _) {
                    return SvgPicture.asset(
                      'assets/icons/user.svg',
                      height: 28,
                    );
                  },
                )
              : Text(
                  username[0],
                  style: TextStyle(
                    fontFamily: AppFonts.zalandoSans,
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                color: AppColors.foreground,
                fontSize: 15,
              ),
            ),
            Text(
              email,
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                color: AppColors.mutedForeground,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
