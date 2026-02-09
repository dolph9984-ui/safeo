import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/services/security/rbac_service.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/file_info.dart';
import 'package:securite_mobile/view/widgets/rename_file_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';

class UnifiedFileBottomSheet extends StatelessWidget {
  final Document file;
  final User currentUser;
  final Function()? onOpenTap;
  final Function()? onDownloadTap;
  final Function(String newName)? onRenameTap;
  final Function()? onDeleteTap;

  const UnifiedFileBottomSheet({
    super.key,
    required this.file,
    required this.currentUser,
    this.onOpenTap,
    this.onDownloadTap,
    this.onRenameTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = <BottomSheetItem>[];

    if (currentUser.canRead(file)) {
      items.add(
        BottomSheetItem(
          label: 'Ouvrir',
          assetName: 'assets/icons/open.svg',
          onTap: () {
            Navigator.pop(context);
            if (onOpenTap != null) {
              onOpenTap!();
            } else {
              showSuccessSnackbar(context, 'Ouverture du fichier...');
            }
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canShare(file)) {
      items.add(
        BottomSheetItem(
          label: 'Partager',
          assetName: 'assets/icons/share.svg',
          onTap: () {
            Navigator.pop(context);
            context.push('${AppRoutes.shareFile}/${file.id}');
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canShare(file)) {
      items.add(
        BottomSheetItem(
          label: 'Gérer les partages',
          assetName: 'assets/icons/users_round.svg',
          onTap: () {
            Navigator.pop(context);
            context.push('${AppRoutes.shareHandling}/${file.id}');
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canModify(file)) {
      items.add(
        BottomSheetItem(
          label: 'Renommer',
          assetName: 'assets/icons/edit.svg',
          onTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              animationStyle: AnimationStyle(
                duration: Duration(milliseconds: 0),
              ),
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
                    initialName: file.originalName,
                    onCancelPress: () {
                      context.pop();
                      context.pop();
                    },
                    onConfirmPress: (newName) {
                      if (onRenameTap != null) {
                        onRenameTap!(newName);
                      } else {
                        showSuccessSnackbar(
                          context,
                          'Fichier renommé en "$newName"',
                        );
                      }
                      context.pop();
                      context.pop();
                    },
                  ),
                );
              },
            );
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canDownload(file)) {
      items.add(
        BottomSheetItem(
          label: 'Télécharger',
          assetName: 'assets/icons/download.svg',
          onTap: () {
            Navigator.pop(context);
            if (onDownloadTap != null) {
              onDownloadTap!();
            } else {
              showSuccessSnackbar(context, 'Téléchargement en cours...');
            }
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canRead(file)) {
      items.add(
        BottomSheetItem(
          label: 'Informations sur le fichier',
          assetName: 'assets/icons/info.svg',
          onTap: () {
            Navigator.pop(context);
            _showFileInfoDialog(context);
          },
          color: AppColors.foreground,
        ),
      );
    }

    if (currentUser.canDelete(file)) {
      items.add(
        BottomSheetItem(
          label: 'Placer dans la corbeille',
          assetName: 'assets/icons/trash.svg',
          onTap: () {
            showDialog(
              barrierColor: Colors.transparent,
              animationStyle: AnimationStyle(
                duration: Duration(milliseconds: 0),
              ),
              context: context,
              builder: (context) {
                return ConfirmDialog(
                  title: 'Placer "${file.originalName}" dans la corbeille ?',
                  description: null,
                  cancelLabel: 'Annuler',
                  confirmLabel: 'Déplacer vers la corbeille',
                  confirmBgColor: AppColors.destructive,
                  onConfirm: () {
                    if (onDeleteTap != null) {
                      onDeleteTap!();
                    } else {
                      showSuccessSnackbar(
                        context,
                        'Fichier déplacé vers la corbeille',
                      );
                    }
                    context.pop();
                    context.pop();
                  },
                  onCancel: () {
                    context.pop();
                  },
                );
              },
            );
          },
          color: AppColors.destructive,
        ),
      );
    }

    return AppBottomSheet(items: items);
  }

  void _showFileInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (context) {
        return FileInfo(file: file);
      },
    );
  }
}
