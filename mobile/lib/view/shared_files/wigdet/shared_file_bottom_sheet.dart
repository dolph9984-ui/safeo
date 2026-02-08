import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/model/file_model.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/file_info.dart';
import 'package:securite_mobile/view/widgets/rename_file_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';

import '../../../model/user_model.dart';

class SharedFilesBottomSheet extends StatelessWidget {
  final SharedFileData file;

  const SharedFilesBottomSheet({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    final isOwner = file.userRole == UserRole.owner;

    // Actions communes à tous les utilisateurs
    final commonItems = [
      BottomSheetItem(
        label: 'Ouvrir',
        assetName: 'assets/icons/open.svg',
        onTap: () {
          Navigator.pop(context);
          showSuccessSnackbar(context, 'Ouverture du fichier...');
        },
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Télécharger',
        assetName: 'assets/icons/download.svg',
        onTap: () {
          Navigator.pop(context);
          showSuccessSnackbar(context, 'Téléchargement en cours...');
        },
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Informations sur le fichier',
        assetName: 'assets/icons/info.svg',
        onTap: () {
          Navigator.pop(context);
          _showFileInfoDialog(context);
        },
        color: AppColors.foreground,
      ),
    ];

    // Actions réservées au propriétaire
    final ownerOnlyItems = [
      BottomSheetItem(
        label: 'Gérer les partages',
        assetName: 'assets/icons/users_round.svg',
        onTap: () {
          Navigator.pop(context);
          context.pushNamed(AppRoutes.shareFile);
        },
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Renommer',
        assetName: 'assets/icons/edit.svg',
        onTap: () {
          Navigator.pop(context);
          _showRenameDialog(context);
        },
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Placer dans la corbeille',
        assetName: 'assets/icons/trash.svg',
        onTap: () {
          Navigator.pop(context);
          _showDeleteConfirmation(context);
        },
        color: AppColors.destructive,
      ),
    ];

    // Construction de la liste finale
    final allItems = [
      commonItems[0],
      if (isOwner) ...[ownerOnlyItems[0], ownerOnlyItems[1]],
      commonItems[1],
      commonItems[2],
      if (isOwner) ownerOnlyItems[2],
    ];

    return AppBottomSheet(items: allItems);
  }

  void _showFileInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (context) {
        return FileInfo(
          file: AppFile(
            id: '',
            name: file.fileName,
            size: file.fileSize.toInt(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            category: '',
            owner: User(
              uuid: '',
              fullName: file.ownerName,
              email: file.ownerEmail,
              filesNbr: 0,
              sharedFilesNbr: 0,
              storageLimit: 0,
              storageUsed: 0,
              createdAt: DateTime.now(),
              imageUrl: '',
            ),
            type: file.fileType,
            isShared: true,
          ),
        );
      },
    );
  }

  void _showRenameDialog(BuildContext context) {
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
            initialName: file.fileName,
            onCancelPress: () => context.pop(),
            onConfirmPress: (newName) {
              context.pop();
              showSuccessSnackbar(context, 'Fichier renommé en "$newName"');
            },
          ),
        );
      },
    );
  }

  void _showDeleteConfirmation(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (context) {
        return ConfirmDialog(
          title: 'Placer dans la corbeille',
          description:
              'Le fichier "${file.fileName}" sera déplacé vers la corbeille.',
          cancelLabel: 'Annuler',
          confirmLabel: 'Déplacer vers la corbeille',
          confirmBgColor: AppColors.destructive,
          onConfirm: () {},
          onCancel: () {},
        );
      },
    );

    if (confirmed == true && context.mounted) {
      showSuccessSnackbar(context, 'Fichier déplacé vers la corbeille');
    }
  }
}
