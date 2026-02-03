import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:securite_mobile/constants/app_colors.dart';

/// HEADER COMMUN
class AuthHeader extends StatelessWidget {
  final VoidCallback onBackPressed;

  const AuthHeader({super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            padding: const EdgeInsets.only(left: 8),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 32),
            onPressed: onBackPressed,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: SvgPicture.asset(
            'assets/icons/logo_safeo.svg',
            height: 30,
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      ],
    );
  }
}

/// LAYOUT PRINCIPAL
class AuthLayout extends StatelessWidget {
  final Widget child;
  final VoidCallback onBackPressed;

  const AuthLayout({
    super.key,
    required this.child,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AuthHeader(onBackPressed: onBackPressed),
            const SizedBox(height: 60),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// DIVIDER "ou"
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(child: Divider(color: AppColors.borderGray)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ou', style: TextStyle(color: AppColors.textHint)),
          ),
          Expanded(child: Divider(color: AppColors.borderGray)),
        ],
      ),
    );
  }
}

/// FOOTER
class AuthFooter extends StatelessWidget {
  final String text;
  final String linkText;
  final VoidCallback onTap;

  const AuthFooter({
    super.key,
    required this.text,
    required this.linkText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          GestureDetector(
            onTap: onTap,
            child: Text(
              ' $linkText',
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// MESSAGE D'ERREUR
class AuthErrorMessage extends StatelessWidget {
  final String? message;

  const AuthErrorMessage({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    if (message == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.errorLight,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message!,
              style: const TextStyle(color: AppColors.errorDark),
            ),
          ),
        ],
      ),
    );
  }
}

/// BOUTON GOOGLE
class GoogleAuthButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  const GoogleAuthButton({
    super.key,
    required this.onPressed,
    this.label = 'Continuer avec Google',
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.borderGray),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/icons/google_icon.svg',
                  height: 24,
                  width: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
    );
  }
}