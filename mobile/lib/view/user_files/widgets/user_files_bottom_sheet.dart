import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/rename_file_dialog.dart';

import '../../../constants/app_colors.dart';
import '../../widgets/bottom_sheet_item.dart';

class UserFilesBottomSheet extends StatelessWidget {
  const UserFilesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomSheetItems = [
      BottomSheetItem(
        label: 'Ouvrir',
        assetName: 'assets/icons/open.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Partager',
        assetName: 'assets/icons/share.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Gérer les partages',
        assetName: 'assets/icons/users_round.svg',
        onTap: () {context.pushNamed(AppRoutes.shareFile);},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Renommer',
        assetName: 'assets/icons/edit.svg',
        onTap: () {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
            builder: (context) {
              return BlurredDialog(
                popOnOutsideDialogTap: false,
                child: RenameFileDialog(
                  validator: (newName) {
                    if (newName != null && newName.trim().isEmpty) {
                      return 'Veuillez entrer un nom valide.';
                    }
                    return null;
                  },
                  initialName: '',
                  onCancelPress: () => context.pop(),
                  onConfirmPress: (newName) {
                    context.pop();
                  },
                ),
              );
            },
          );
        },
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Télécharger',
        assetName: 'assets/icons/download.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Informations sur le fichier',
        assetName: 'assets/icons/info.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Placer dans la corbeille',
        assetName: 'assets/icons/trash.svg',
        onTap: () {
          showDialog(
            barrierColor: Colors.transparent,
            animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
            context: context,
            builder: (context) {
              return ConfirmDialog(
                title: 'Placer dans la corbeille',
                description: null,
                cancelLabel: 'Annuler',
                confirmLabel: 'Déplacer vers la corbeille',
                confirmBgColor: AppColors.destructive,
              );
            },
          );
        },
        color: AppColors.destructive,
      ),
    ];

    return AppBottomSheet(items: bottomSheetItems);
  }
}
