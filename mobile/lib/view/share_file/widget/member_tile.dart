import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/viewmodel/share_file_viewmodel.dart';

class MemberTile extends StatelessWidget {
  final ShareMemberUiModel member;

  const MemberTile({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(member.avatarUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  member.name,
                  style: TextStyle(
                    fontFamily: AppFonts.productSansMedium,
                    fontSize: 14,
                    color: AppColors.foreground,
                  ),
                ),
                Text(
                  member.email,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedForeground,
                  ),
                ),
              ],
            ),
          ),
          Text(
            member.role == ShareRole.owner ? 'Propriétaire' : 'Lecteur',
            style: TextStyle(
              fontSize: 12,
              color:AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
