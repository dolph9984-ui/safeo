import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_colors.dart';
import 'package:securite_mobile/constants/app_fonts.dart';
import 'package:securite_mobile/model/user_model.dart';

class UserSuggestionList extends StatelessWidget {
  final List<User> users;
  final Function(User) onUserSelected;

  const UserSuggestionList({
    super.key,
    required this.users,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (users.isEmpty) return SizedBox.shrink();

    return Container(
      constraints: BoxConstraints(maxHeight: 200),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.foreground.withAlpha(20),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListView.separated(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: users.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: AppColors.buttonDisabled,
        ),
        itemBuilder: (context, index) {
          final user = users[index];
          return InkWell(
            onTap: () => onUserSelected(user),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _buildAvatar(user),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: TextStyle(
                            fontFamily: AppFonts.productSansMedium,
                            fontSize: 14,
                            color: AppColors.foreground,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontFamily: AppFonts.productSansRegular,
                            fontSize: 12,
                            color: AppColors.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAvatar(User user) {
    if (user.imageUrl != null && user.imageUrl!.isNotEmpty) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(user.imageUrl!),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final initials = user.fullName.isNotEmpty 
        ? user.fullName[0].toUpperCase() 
        : '?';

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppColors.primary.withAlpha(30),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontFamily: AppFonts.productSansMedium,
            fontSize: 16,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}