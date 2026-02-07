import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/share_file/widget/member_tile.dart';
import 'package:securite_mobile/view/shared_files/wigdet/search_bar.dart';
import 'package:securite_mobile/viewmodel/share_file_viewmodel.dart';

class ShareFileView extends StatelessWidget {
  const ShareFileView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShareFileViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: const BackButton(),
        title: Text(
          'Partager ce document',
          style: TextStyle(
            fontFamily: AppFonts.zalandoSans,
            fontSize: 16,
            color: AppColors.foreground,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SharedFileSearchBar(
              controller: vm.searchController,
              hintText: 'Inviter un utilisateur par email',
              iconPath: 'assets/icons/user-plus.svg',
               onChanged: vm.onInviteEmailChanged,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: vm.canSendInvite ? () {} : null,
              child: const Text('Envoyer'),
            ),

            const SizedBox(height: 32),

            Text(
              'Membres',
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                fontSize: 16,
                color: AppColors.foreground,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: vm.members.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final member = vm.members[index];

                  return MemberTile(member: member);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



