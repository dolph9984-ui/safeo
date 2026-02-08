import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/enum/file_type_enum.dart';
import 'package:securite_mobile/view/user_files/widgets/file_item.dart';
import 'package:securite_mobile/view/user_files/widgets/files_list.dart';
import 'package:securite_mobile/view/user_files/widgets/storage_card.dart';
import 'package:securite_mobile/view/user_files/widgets/user_files_bottom_sheet.dart';
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
          listTitle: 'Mes fichiers',
          files: vm.files
              .map(
                (file) => FileItem(
                  fileName: file.name,
                  fileSize: file.size,
                  dateTime: file.createdAt,
                  onButtonTap: (String id) {
                    showModalBottomSheet(
                      useRootNavigator: true,
                      context: context,
                      builder: (context) {
                        return UserFilesBottomSheet(
                          fileId: id,  
                        );
                      },
                    );
                  },
                  id: file.id,
                ),
              )
              .toList(),
          showSearchIcon: true,
        ),
      ],
    );
  }
}