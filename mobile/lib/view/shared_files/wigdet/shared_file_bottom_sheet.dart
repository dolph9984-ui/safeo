import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/month_enum.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/rename_file_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';

class SharedFilesBottomSheet extends StatelessWidget {
  final SharedFileData file;

  const SharedFilesBottomSheet({
    super.key,
    required this.file,
  });

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
      if (isOwner) ...[
        ownerOnlyItems[0],
        ownerOnlyItems[1], 
      ],
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
        return BlurredDialog(
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                Text(
                  'Informations sur le fichier',
                  style: TextStyle(
                    color: AppColors.foreground,
                    fontSize: 16,
                    fontFamily: AppFonts.productSansMedium,
                  ),
                ),

                Divider(color: AppColors.buttonDisabled),

                _buildInfoRow('Nom', file.fileName),
                _buildInfoRow('Taille', '${file.fileSize} MB'),
                _buildInfoRow('Type', file.fileType.name.toUpperCase()),
                _buildInfoRow('Partagé le', _formatDate(file.sharedAt)),
                _buildInfoRow('Propriétaire', file.ownerName),
                _buildInfoRow('Email', file.ownerEmail),
                _buildInfoRow('Votre rôle', file.userRole == UserRole.owner ? 'Propriétaire' : 'Lecteur'),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.pop(),
                    child: Text('Fermer'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.productSansMedium,
              fontSize: 14,
              color: AppColors.mutedForeground,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.productSansRegular,
              fontSize: 14,
              color: AppColors.foreground,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${MonthEnum.values[date.month - 1].name} ${date.year}';
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
          description: 'Le fichier "${file.fileName}" sera déplacé vers la corbeille.',
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