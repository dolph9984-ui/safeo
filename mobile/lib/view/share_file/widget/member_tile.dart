import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/user_model.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/view/widgets/app_bottom_sheet.dart';
import 'package:securite_mobile/view/widgets/bottom_sheet_item.dart';

class MemberTile extends StatelessWidget {
  final User member;
  final bool isOwner;
  final String fileId;

  const MemberTile({
    super.key,
    required this.member,
    required this.fileId,
    this.isOwner = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: !isOwner ? () => _showMemberBottomSheet(context) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.foreground.withAlpha(10),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            
            const SizedBox(width: 12),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    member.fullName,
                    style: TextStyle(
                      fontFamily: AppFonts.productSansMedium,
                      fontSize: 14,
                      color: AppColors.foreground,
                    ),
                  ),
                  Text(
                    member.email,
                    style: TextStyle(
                      fontFamily: AppFonts.productSansRegular,
                      fontSize: 12,
                      color: AppColors.mutedForeground,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    isOwner ? 'Propriétaire' : 'Lecteur',
                    style: TextStyle(
                      fontFamily: AppFonts.productSansMedium,
                      fontSize: 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMemberBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppBottomSheet(
          items: [
            BottomSheetItem(
              label: 'Gérer les partages',
              assetName: 'assets/icons/users_round.svg',
              onTap: () {
                Navigator.pop(context);
                context.push('${AppRoutes.shareHandling}/$fileId');
              },
              color: AppColors.foreground,
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatar() {
    if (member.imageUrl != null && member.imageUrl!.isNotEmpty) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(member.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary.withAlpha(30),
      ),
      child: Center(
        child: Text(
          _getInitials(member.fullName),
          style: TextStyle(
            fontFamily: AppFonts.productSansMedium,
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}