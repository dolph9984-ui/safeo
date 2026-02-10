import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/shared_files/wigdet/filter_bottom_sheet.dart';
import 'package:securite_mobile/view/user_files/widgets/file_item.dart';
import 'package:securite_mobile/view/user_files/widgets/files_list.dart';
import 'package:securite_mobile/view/user_files/widgets/storage_card.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';
import 'package:securite_mobile/view/widgets/user_bottom_sheet.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

class UserFilesView extends StatefulWidget {
  const UserFilesView({super.key});

  @override
  State<UserFilesView> createState() => _UserFilesViewState();
}

class _UserFilesViewState extends State<UserFilesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserFilesViewModel>();
    final buildContext = context;

    return ListView(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 40),
      children: [
        SizedBox(height: 16),
        StorageCard(used: vm.storageUsed, totalStorage: vm.storageLimit),
        SizedBox(height: 32),
        if (vm.loading.state == true)
          Center(
            child: Column(
              spacing: 24,
              children: [
                SizedBox(height: 32),
                if (vm.loading.message.isNotEmpty) Text(vm.loading.message),
                CircularProgressIndicator(color: AppColors.primary),
              ],
            ),
          )
        else
          FilesList(
            currentFilter: vm.currentFilter,
            listTitle: 'Mes fichiers',
            showSearchIcon: true,
            onSearchTap: () => context.pushNamed(AppRoutes.searchPage),
            onFilterTap: () {
              showModalBottomSheet(
                useRootNavigator: true,
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) {
                  return FilterBottomSheet(
                    currentFilter: vm.currentFilter,
                    onFilterSelected: (newFilter) {
                      vm.setCurrentFilter(newFilter);
                    },
                    allowedFilter: [
                      FileFilterEnum.all,
                      FileFilterEnum.image,
                      FileFilterEnum.pdf,
                      FileFilterEnum.document,
                      FileFilterEnum.csv,
                    ],
                  );
                },
              );
            },
            files: vm.filteredFiles
                .map(
                  (file) => FileItem(
                    fileName: file.originalName,
                    fileSize: file.fileSize,
                    dateTime: file.createdAt,
                    onButtonTap: (String id) {
                      if (vm.currentUser != null) {
                        // MODIFICATION
                        showModalBottomSheet(
                          useRootNavigator: true,
                          context: context,
                          builder: (context) {
                            return UnifiedFileBottomSheet(
                              file: file,
                              currentUser: vm.currentUser!,
                              onOpenTap: () => vm.openFile(file),
                              onRenameTap: (newName) async {
                                final result = await vm.renameFile(
                                  file,
                                  newName,
                                );
                                if (buildContext.mounted) {
                                  if (result == ActionResult.success) {
                                    showSuccessSnackbar(
                                      buildContext,
                                      'Fichier renommé avec succès',
                                    );
                                  } else {
                                    showErrorSnackbar(
                                      buildContext,
                                      'Erreur lors du renommage',
                                    );
                                  }
                                }
                              },
                              onDownloadTap: () async {
                                final result = await vm.downloadFile(file);
                                if (buildContext.mounted) {
                                  if (result == ActionResult.success) {
                                    showSuccessSnackbar(
                                      buildContext,
                                      'Fichier téléchargé',
                                    );
                                  } else {
                                    showErrorSnackbar(
                                      buildContext,
                                      'Erreur lors du téléchargement',
                                    );
                                  }
                                }
                              },
                              onDeleteTap: () async {
                                final result = await vm.deleteFile(file);

                                if (buildContext.mounted) {
                                  if (result == ActionResult.success) {
                                    showSuccessSnackbar(
                                      buildContext,
                                      'Fichier supprimé avec succès',
                                    );
                                  } else {
                                    showErrorSnackbar(
                                      buildContext,
                                      'Erreur lors de la suppression',
                                    );
                                  }
                                }
                              },
                            );
                          },
                        );
                      }
                    },
                    id: file.id,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}
