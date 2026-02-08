import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';

class MemberAccessItem extends StatelessWidget {
  final String memberId;
  final String name;
  final String email;
  final bool isOwner;
  final Future<String?> Function(String memberId) onRemove;

  const MemberAccessItem({
    super.key,
    required this.memberId,
    required this.name,
    required this.email,
    required this.isOwner,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withAlpha(10),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          _buildAvatar(),
          
          const SizedBox(width: 12),
          
          // Nom, email et rôle (colonne)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                // Nom
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: AppFonts.productSansMedium,
                    fontSize: 14,
                    color: AppColors.foreground,
                  ),
                ),
                // Email
                Text(
                  email,
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                // Rôle
                Text(
                  isOwner ? 'Propriétaire' : 'Lecteur',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansMedium,
                    fontSize: 12,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Icône de suppression (croix)
          if (!isOwner)
            InkWell(
              onTap: () => _showRemoveConfirmation(context),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.close,
                  size: 20,
                  color: AppColors.foreground,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary.withAlpha(30),
      ),
      child: Center(
        child: Text(
          _getInitials(name),
          style: TextStyle(
            fontFamily: AppFonts.productSansMedium,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  void _showRemoveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (dialogContext) {
        return ConfirmDialog(
          title: 'Retirer l\'accès',
          description: 'Voulez-vous retirer l\'accès de $name à ce fichier ?',
          cancelLabel: 'Annuler',
          confirmLabel: 'Retirer',
          confirmBgColor: AppColors.destructive,
          onConfirm: () async {
            Navigator.pop(dialogContext);
            
            final error = await onRemove(memberId);
            
            if (context.mounted) {
              if (error == null) {
                showSuccessSnackbar(context, 'Accès retiré avec succès');
              } else {
                showErrorSnackbar(context, error);
              }
            }
          },
          onCancel: () => Navigator.pop(dialogContext),
        );
      },
    );
  }
}