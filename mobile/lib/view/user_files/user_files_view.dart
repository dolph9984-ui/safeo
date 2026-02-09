import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/shared_files/wigdet/filter_bottom_sheet.dart';
import 'package:securite_mobile/view/user_files/widgets/file_item.dart';
import 'package:securite_mobile/view/user_files/widgets/files_list.dart';
import 'package:securite_mobile/view/user_files/widgets/storage_card.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserFilesViewModel>()
        ..initFiles()
        ..initUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserFilesViewModel>();

    return ListView(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 40),
      children: [
        SizedBox(height: 16),
        StorageCard(used: vm.storageUsed, totalStorage: vm.storageLimit),
        SizedBox(height: 32),
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
                    if (vm.currentUser != null) { // MODIFICATION
                      showModalBottomSheet(
                        useRootNavigator: true,
                        context: context,
                        builder: (context) {
                          return UnifiedFileBottomSheet(
                            file: file,
                            currentUser: vm.currentUser!,
                            onOpenTap: () => vm.openFile(file),
                            onRenameTap: (newName) =>
                                vm.renameFile(file, newName: newName),
                            onDownloadTap: () => vm.downloadFile(file),
                            onDeleteTap: () => vm.deleteFile(file),
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