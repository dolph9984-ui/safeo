import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/enum/file_visibility_enum.dart';
import 'package:securite_mobile/view/create_file/widgets/file_visibility_card.dart';
import 'package:securite_mobile/view/widgets/rename_file_dialog.dart';
import 'package:securite_mobile/view/widgets/blurred_dialog.dart';
import 'package:securite_mobile/view/widgets/file_preview.dart';
import 'package:securite_mobile/view/widgets/file_uploader.dart';
import 'package:securite_mobile/view/widgets/progress_dialog.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';
import 'package:securite_mobile/viewmodel/create_file_viewmodel.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

class CreateFileView extends StatelessWidget {
  const CreateFileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateFileViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        titleSpacing: 4,
        backgroundColor: AppColors.background,
        leading: BackButton(),
        title: Text(
          "Importer un document",
          style: TextStyle(
            fontFamily: AppFonts.zalandoSans,
            fontSize: 16,
            color: AppColors.foreground,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 32,
          bottom: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 28,
          children: [
            // Affichage de l'erreur
            if (vm.errorMessage != null)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red, size: 20),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        vm.errorMessage!,
                        style: TextStyle(
                          fontFamily: AppFonts.productSansRegular,
                          fontSize: 14,
                          color: Colors.red.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            vm.selectedFile == null
                ? FileUploader(
                    onTap: () {
                      vm.selectFile();
                    },
                  )
                : FilePreview(
                    padding: EdgeInsets.all(45),
                    filePath: vm.filePath,
                    fileName: vm.fileName,
                    sizeInMB: vm.fileSizeInMB,
                    onEditTap: () {
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
                              initialName: vm.fileName,
                              validator: (newName) {
                                if (newName != null && newName.trim().isEmpty) {
                                  return 'Veuillez entrer un nom valide.';
                                }
                                return null;
                              },
                              onCancelPress: () => context.pop(),
                              onConfirmPress: (newName) {
                                vm.setFileName(newName);
                                context.pop();
                              },
                            ),
                          );
                        },
                      );
                    },
                    onDeleteTap: () => vm.unselectFile(),
                  ),
            Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Confidentialité du fichier',
                  style: TextStyle(
                    fontFamily: AppFonts.productSansRegular,
                    fontSize: 16,
                    color: AppColors.foreground,
                  ),
                ),
                FileVisibilityCard(
                  selected: vm.fileVisibility == FileVisibilityEnum.private,
                  onTap: () => vm.setFileVisibility(FileVisibilityEnum.private),
                  label: 'Privé',
                  description: 'Accessible uniquement par vous',
                  iconPath: 'assets/icons/lock.svg',
                ),
                FileVisibilityCard(
                  selected: vm.fileVisibility == FileVisibilityEnum.shared,
                  onTap: () => vm.setFileVisibility(FileVisibilityEnum.shared),
                  label: 'Partagé',
                  description: 'Accessible aux personnes que vous autorisez',
                  iconPath: 'assets/icons/users_line.svg',
                ),
              ],
            ),

            Spacer(),

            // Upload Button
            ElevatedButton(
              onPressed: vm.selectedFile == null || vm.loading
                  ? null
                  : () => _handleUpload(context, vm),
              child: vm.loading
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text('Importer'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleUpload(
    BuildContext context,
    CreateFileViewModel vm,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      animationStyle: AnimationStyle(duration: Duration(milliseconds: 0)),
      builder: (dialogContext) {
        return ListenableBuilder(
          listenable: vm,
          builder: (context, child) {
            return ProgressDialog(
              percent: vm.uploadProgress,
              label: vm.isCancelling ? 'Annulation...' : 'Upload en cours...',
              onCancel: () {
                if (!vm.isCancelling) {
                  vm.cancelUpload();
                }
              },
            );
          },
        );
      },
    );

    await vm.uploadFile();

    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      showSuccessSnackbar(context, vm.uploadMessage!);
    }

    if (context.mounted) {
      context.read<UserFilesViewModel>().fetchFiles();
      context.go('/user-files');
    }

    vm.reset();
  }
}
