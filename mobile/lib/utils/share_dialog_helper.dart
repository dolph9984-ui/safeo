import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/model/document_model.dart';

Future<void> showShareInvitationDialog({
  required BuildContext context,
  required String token,
  required String fileName,
  required String ownerName,
}) async {
  final DocumentModel documentModel = DocumentModel();

  // Affiche le dialog et attend la réponse (true = accepter, false = refuser)
  final accepted = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Text('Invitation de partage'),
      content: Text('Accepter l\'invitation ?'),
      actions: [
        SizedBox(
          height: 48,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(true), // Accepter
            child: Text('Accepter'),
          ),
        ),
        SizedBox(height: 16),
        SizedBox(
          height: 48,
          width: double.infinity,
          child: TextButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(8),
                ),
              ),
            ),
            onPressed: () => Navigator.of(context).pop(false), // Refuser
            child: Text('Refuser'),
          ),
        ),
      ],
    ),
  );

  // Si accepté
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

        // Navigation sécurisée après la fermeture du dialog
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/shared-files');
        });
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
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
        );

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) context.go('/user-files');
        });
      }
    }
  }
  // Si refusé
  else if (accepted == false) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Invitation refusée')));

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) context.go('/user-files');
      });
    }
  }
}
