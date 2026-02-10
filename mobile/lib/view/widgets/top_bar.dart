import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/viewmodel/scaffold_viewmodel.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ScaffoldViewModel>();
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
              onTap: () => vm.openDrawer(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: CircleAvatar(
                  radius: 17,
                  child: vm.imageProfileUrl.trim().isNotEmpty
                      ? Image.network(
                          vm.imageProfileUrl,
                          height: 34,
                          width: 34,
                          errorBuilder: (_, _, _) {
                            return vm.userName.trim().isNotEmpty
                                ? Text(
                                    vm.userName[0],
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
                      : vm.userName.trim().isNotEmpty
                      ? Text(
                          vm.userName[0],
                          style: TextStyle(
                            fontFamily: AppFonts.zalandoSans,
                            color: Colors.white,
                            fontSize: 14,
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
