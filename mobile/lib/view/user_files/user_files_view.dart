import 'package:flutter/material.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/view/user_files/widgets/file_item.dart';
import 'package:securite_mobile/view/user_files/widgets/files_list.dart';
import 'package:securite_mobile/view/user_files/widgets/storage_card.dart';
import 'package:securite_mobile/view/user_files/widgets/user_files_bottom_sheet.dart';


class UserFilesView extends StatelessWidget {
  const UserFilesView({super.key});

  @override
  Widget build(BuildContext context) {

    final ext = ['pdf', 'doc', 'docx', 'csv', 'jpg', 'jpeg'];
    final files = List.generate(
      8,
      (index) => FileItem(
        fileName: 'example_file_name.${ext[index % ext.length]}',
        fileSize: 2.2,
        dateTime: DateTime.now(),
        fileType: FileTypeEnum.values[index % 4],
        onButtonTap: (String id) {
          showModalBottomSheet(
            useRootNavigator: true,
            context: context,
            builder: (context) {
              return UserFilesBottomSheet();
            },
          );
        },
        id: index.toString(),
      ),
    );

    return ListView(
      padding: EdgeInsets.only(left: 24, right: 24, bottom: 40),
      children: [
        SizedBox(height: 16),
        StorageCard(used: 2, totalStorage: 5),
        SizedBox(height: 32),
        FilesList(
          listTitle: 'Mes fichiers',
          files: files,
          showSearchIcon: true,
        ),
      ],
    );
  }
}
