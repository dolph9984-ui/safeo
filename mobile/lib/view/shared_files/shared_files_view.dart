import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/view/shared_files/wigdet/search_bar.dart';
import 'package:securite_mobile/view/shared_files/wigdet/shardfiles_list.dart';
import 'package:securite_mobile/view/shared_files/wigdet/sharedfiles_item.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';

enum UserRole {
  owner,
  viewer,
}

class SharedFilesView extends StatefulWidget {
  const SharedFilesView({super.key});

  @override
  State<SharedFilesView> createState() => _SharedFilesViewState();
}

class _SharedFilesViewState extends State<SharedFilesView> {
  final TextEditingController _searchController = TextEditingController();

  final UserRole userRole = UserRole.owner;



  List<BottomSheetItem> _buildBottomSheetItems(UserRole role) {
    final allItems = [
      BottomSheetItem(
        label: 'Ouvrir',
        assetName: 'assets/icons/open.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Partager',
        assetName: 'assets/icons/share.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Gérer les partages',
        assetName: 'assets/icons/users_round.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Renommer',
        assetName: 'assets/icons/edit.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Télécharger',
        assetName: 'assets/icons/download.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Informations sur le fichier',
        assetName: 'assets/icons/info.svg',
        onTap: () {},
        color: AppColors.foreground,
      ),
      BottomSheetItem(
        label: 'Placer dans la corbeille',
        assetName: 'assets/icons/trash.svg',
        onTap: () {},
        color: AppColors.destructive,
      ),
    ];

    if (role == UserRole.viewer) {
      return allItems.where((item) {
        return item.label == 'Ouvrir' ||
            item.label == 'Télécharger' ||
            item.label == 'Informations sur le fichier';
      }).toList();
    }

    return allItems;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ext = ['pdf', 'doc', 'docx', 'csv', 'jpg', 'jpeg'];

    final files = List.generate(
      8,
      (index) => SharedFileItem(
        id: index.toString(),
        fileName: 'example_file_name.${ext[index % ext.length]}',
        fileSize: 2.2,
        dateTime: DateTime.now(),
        fileType: FileTypeEnum.values[index % 4],
        onButtonTap: (_) {
          final items = _buildBottomSheetItems(userRole);

          showModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: (_) => AppBottomSheet(items: items),
          );
        },
      ),
    );

    return ListView(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40),
      children: [
        SharedFileSearchBar(
          controller: _searchController,
          hintText: 'Rechercher un fichier...',
              iconPath: 'assets/icons/search.svg',
        ),
        const SizedBox(height: 24),
        SharedFilesList(
          listTitle: 'Fichiers partagés',
          files: files,
        ),
      ],
    );
  }
}
