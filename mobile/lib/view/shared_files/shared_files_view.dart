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
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SharedFilesViewModel>()
        ..initUser()
        ..fetchFiles();
    });
  }

  void _onSearchChanged() {
    context.read<SharedFilesViewModel>().searchFiles(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SharedFilesViewModel>();

    final files = vm.filteredFiles.map((file) {
      return SharedFileItem(
        id: file.id,
        fileName: file.originalName,
        dateTime: file.createdAt,
        onButtonTap: (id) {
          final selectedFile = vm.filteredFiles.firstWhere(
            (file) => file.id == id,
            orElse: () => throw Exception('File not found'),
          );
          
          if (vm.currentUser != null) {
            showModalBottomSheet(
              useRootNavigator: true,
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return UnifiedFileBottomSheet(
                  file: selectedFile,
                  currentUser: vm.currentUser!,
                  onOpenTap: () {
                    vm.openFile(selectedFile);
                    Navigator.pop(context);
                  },
                  onDownloadTap: () {
                    vm.downloadFile(selectedFile);
                    Navigator.pop(context);
                  },
                  onRenameTap: (newName) async {
                    final result = await vm.renameFile(selectedFile, newName);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result == ActionResult.success
                                ? 'Fichier renommé avec succès'
                                : 'Erreur lors du renommage',
                          ),
                        ),
                      );
                    }
                  },
                  onDeleteTap: () async {
                    final result = await vm.deleteFile(selectedFile);
                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result == ActionResult.success
                                ? 'Fichier supprimé avec succès'
                                : 'Erreur lors de la suppression',
                          ),
                        ),
                      );
                    }
                  },
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
                  controller: _searchController,
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
                  onFilterSelected: (filter) {
                    vm.setCurrentFilter(filter);
                    Navigator.pop(context);
                  },
                );
              },
            );
          },
          showFilterButton: true,
          messageOnEmpty: 'Aucun fichier partagé trouvé',
        ),
      ],
    );
  }
}