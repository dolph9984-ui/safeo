import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/model/document_model.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';

Future<void> showShareInvitationDialog({
  required BuildContext context,
  required String token,
  required String fileName,
  required String ownerName,
}) async {
  final DocumentModel documentModel = DocumentModel();

  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => ConfirmDialog(
      title: 'Invitation de partage',
      description: '$ownerName vous invite à accéder au fichier "$fileName".\n\nVoulez-vous accepter cette invitation ?',
      cancelLabel: 'Refuser',
      confirmLabel: 'Accepter',
      confirmBgColor: AppColors.primary,
      onConfirm: () {},
      onCancel: () {},
    ),
  );

  if (accepted == true) {
    try {
      await documentModel.acceptShareInvitation(token);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invitation acceptée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Naviguer vers les fichiers partagés avec GoRouter
        context.go('/shared-files');
      }
    } on Exception catch (e) {
      if (context.mounted) {
        String errorMessage = 'Erreur lors de l\'acceptation';
        
        if (e.toString().contains('INVALID_TOKEN')) {
          errorMessage = 'Invitation invalide ou expirée';
        } else if (e.toString().contains('USER_NOT_FOUND')) {
          errorMessage = 'Utilisateur introuvable';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
        
        // Retour à l'accueil en cas d'erreur
        context.go('/user-files');
      }
    }
  } else if (accepted == false) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation refusée')),
      );
      
      // Retour à l'accueil si refusé
      context.go('/user-files');
    }
  }
}
