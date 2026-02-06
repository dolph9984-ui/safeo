import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/create_file/widgets/confidentiality_card.dart';
import 'package:securite_mobile/view/widgets/file_preview.dart';
import 'package:securite_mobile/view/widgets/file_uploader.dart';
import 'package:securite_mobile/viewmodel/create_file_viewmodel.dart';

class CreateFileView extends StatelessWidget {
  const CreateFileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateFileViewModel>();

    return Scaffold(
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
                    onEditTap: () {},
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

                ConfidentialityCard(
                  selected: true,
                  onTap: () {},
                  label: 'Privé',
                  description: 'Accessible uniquement par vous',
                  iconPath: 'assets/icons/lock.svg',
                ),
                ConfidentialityCard(
                  selected: false,
                  onTap: () {},
                  label: 'Partagé',
                  description: 'Accessible aux personnes que vous autorisez',
                  iconPath: 'assets/icons/users_line.svg',
                ),
              ],
            ),

            Spacer(),
            ElevatedButton(
              onPressed: vm.selectedFile == null ? null : () {},
              child: Text('Importer'),
            ),
          ],
        ),
      ),
    );
  }
}
