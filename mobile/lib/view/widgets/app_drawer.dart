import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/widgets/drawer_item.dart';

class AppDrawer extends StatelessWidget {
  final String? profileImgUrl;

  const AppDrawer({super.key, this.profileImgUrl});

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
                    profileInfo(),
                    Row(
                      spacing: 16,
                      children: [
                        info('Fichier(s)', '0'),
                        info('Partagé(s)', '0'),
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
                onTap: () {},
                color: AppColors.foreground,
              ),

              DrawerItem(
                label: 'Se déconnecter',
                assetName: 'assets/icons/logout.svg',
                onTap: () {},
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

  Widget profileInfo() {
    return Row(
      spacing: 8,
      children: [
        CircleAvatar(
          radius: 24,
          child: (profileImgUrl != null)
              ? Image.network(
                  profileImgUrl!,
                  height: 48,
                  width: 48,
                  errorBuilder: (_, _, _) {
                    return SvgPicture.asset(
                      'assets/icons/user.svg',
                      height: 28,
                    );
                  },
                )
              : SvgPicture.asset('assets/icons/user.svg', height: 28),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kirito EM',
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                color: AppColors.foreground,
                fontSize: 15,
              ),
            ),
            Text(
              'mail@gmail.com',
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
