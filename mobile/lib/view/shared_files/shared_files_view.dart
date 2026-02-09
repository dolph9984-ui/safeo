import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/enum/file_filter_enum.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/shared_files/wigdet/filter_bottom_sheet.dart';
import 'package:securite_mobile/view/shared_files/wigdet/search_bar.dart';
import 'package:securite_mobile/view/shared_files/wigdet/shardfiles_list.dart';
import 'package:securite_mobile/view/shared_files/wigdet/sharedfiles_item.dart';
import 'package:securite_mobile/view/widgets/user_bottom_sheet.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';

class SharedFilesView extends StatefulWidget {
  const SharedFilesView({super.key});

  @override
  State<SharedFilesView> createState() => _SharedFilesViewState();
}

class _SharedFilesViewState extends State<SharedFilesView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedFilesViewModel>()
        ..initUser()
        ..initFiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SharedFilesViewModel>();

    final files = vm.sharedFiles.map((file) {
      return SharedFileItem(
        id: file.id,
        fileName: file.originalName,
        dateTime: file.createdAt,
        onButtonTap: (id) {
          final selectedFile = vm.getFileById(id);
          if (selectedFile != null && vm.currentUser != null) {
            showModalBottomSheet(
              useRootNavigator: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return UnifiedFileBottomSheet(
                  file: selectedFile,
                  currentUser: vm.currentUser!,
                  onOpenTap: () => vm.openFile(selectedFile),
                  onDownloadTap: () => vm.downloadFile(selectedFile),
                  onRenameTap: (newName) =>
                      vm.renameFile(selectedFile, newName: newName),
                  onDeleteTap: () => vm.deleteFile(selectedFile),
                );
              },
            );
          }
        },
      );
    }).toList();

    return ListView(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
      children: [
        GestureDetector(
          onTap: () => context.pushNamed(AppRoutes.searchPage),
          child: AbsorbPointer(
            child: Hero(
              tag: 'search_bar',
              child: Material(
                type: MaterialType.transparency,
                child: SharedFileSearchBar(
                  controller: vm.searchController,
                  hintText: 'Rechercher un fichier...',
                  iconPath: 'assets/icons/search.svg',
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SharedFilesList(
          filterLabel: vm.currentFilter.label,
          files: files,
          onFilterTap: () {
            showModalBottomSheet(
              useRootNavigator: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return FilterBottomSheet(
                  currentFilter: vm.currentFilter,
                  allowedFilter: FileFilterEnum.values,
                  onFilterSelected: (filter) => vm.setFilter(filter),
                );
              },
            );
          },
          showFilterButton: true,
          messageOnEmpty: 'Aucun fichier trouvé',
        ),
      ],
    );
  }
}
