import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/view/shared_files/wigdet/search_bar.dart';
import 'package:securite_mobile/view/shared_files/wigdet/shardfiles_list.dart';
import 'package:securite_mobile/view/shared_files/wigdet/sharedfiles_item.dart';
import 'package:securite_mobile/view/user_files/widgets/user_files_bottom_sheet.dart';


enum UserRole { owner, viewer }

class SharedFilesView extends StatefulWidget {
  const SharedFilesView({super.key});

  @override
  State<SharedFilesView> createState() => _SharedFilesViewState();
}

class _SharedFilesViewState extends State<SharedFilesView> {
  final TextEditingController _searchController = TextEditingController();

  final UserRole userRole = UserRole.owner;


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
          showModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: (context) {
              return UserFilesBottomSheet();
            },
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
        SharedFilesList(listTitle: 'Fichiers partagés', files: files),
      ],
    );
  }
}
