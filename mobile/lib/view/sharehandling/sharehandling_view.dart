import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/sharehandling/widgets/member_access_item.dart';
import 'package:securite_mobile/viewmodel/sharehandling_viewmodel.dart';

class ShareHandlingView extends StatelessWidget {
  final String fileId;

  const ShareHandlingView({
    super.key,
    required this.fileId,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShareHandlingViewModel(fileId: fileId),
      child: _ShareHandlingContent(fileId: fileId),
    );
  }
}

class _ShareHandlingContent extends StatelessWidget {
  final String fileId;

  const _ShareHandlingContent({required this.fileId});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShareHandlingViewModel>();

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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Qui a accès',
              style: TextStyle(
                fontFamily: AppFonts.zalandoSans,
                fontSize: 16,
                color: AppColors.foreground,
              ),
            ),
            InkWell(
              onTap: () {
                context.push('${AppRoutes.shareFile}/$fileId?autoFocus=true');
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  'assets/icons/user-plus.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        child: ListView.separated(
          itemCount: vm.allMembers.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final member = vm.allMembers[index];
            
            return MemberAccessItem(
              memberId: member['id'] as String,
              name: member['name'] as String,
              email: member['email'] as String,
              isOwner: member['isOwner'] as bool,
              onRemove: (memberId) => vm.removeUserAccess(memberId),
            );
          },
        ),
      ),
    );
  }
}