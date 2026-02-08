import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/view/share_file/widget/member_tile.dart';
import 'package:securite_mobile/view/share_file/widget/user_suggestion_list.dart';
import 'package:securite_mobile/view/shared_files/wigdet/search_bar.dart';
import 'package:securite_mobile/view/widgets/success_snackbar.dart';
import 'package:securite_mobile/viewmodel/share_file_viewmodel.dart';

class ShareFileView extends StatelessWidget {
  final String fileId;
  final bool autoFocus;

  const ShareFileView({
    super.key,
    required this.fileId,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShareFileViewModel(fileId: fileId),
      child: _ShareFileContent(fileId: fileId, autoFocus: autoFocus),
    );
  }
}

class _ShareFileContent extends StatelessWidget {
  final String fileId;
  final bool autoFocus;

  const _ShareFileContent({
    required this.fileId,
    required this.autoFocus,
  });

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShareFileViewModel>();

    if (vm.isLoading && vm.currentFile == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: const BackButton(),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              autoFocus: autoFocus,  
            ),

            const SizedBox(height: 8),

            if (vm.hasSearchResults)
              UserSuggestionList(
                users: vm.searchResults,
                onUserSelected: (user) {
                  vm.selectUserSuggestion(user);
                },
              ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: vm.canSendInvite && !vm.isLoading
                    ? () async {
                        final error = await vm.shareWithEmail(vm.emailToInvite);
                        
                        if (context.mounted) {
                          if (error == null) {
                            showSuccessSnackbar(
                              context,
                              'Invitation envoyée avec succès',
                            );
                          } else {
                            showErrorSnackbar(context, error);
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.buttonDisabled,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: vm.isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                    : Text(
                        'Envoyer l\'invitation',
                        style: TextStyle(
                          fontFamily: AppFonts.productSansMedium,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 32),

            Text(
              'Membres (${vm.sharedWith.length + 1})',
              style: TextStyle(
                fontFamily: AppFonts.productSansRegular,
                fontSize: 16,
                color: AppColors.foreground,
              ),
            ),

            const SizedBox(height: 16),

            Expanded(
              child: ListView.separated(
                itemCount: vm.sharedWith.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  if (index == 0 && vm.currentUser != null) {
                    return MemberTile(
                      member: vm.currentUser!,
                      fileId: fileId,
                      isOwner: true,
                    );
                  }

                  final member = vm.sharedWith[index - 1];
                  return MemberTile(
                    member: member,
                    fileId: fileId,
                    isOwner: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}