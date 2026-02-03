import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';

import 'package:securite_mobile/view/onboarding_view.dart';
import 'package:securite_mobile/view/auth/login_view.dart';
import 'package:securite_mobile/view/auth/signup_view.dart';
import 'package:securite_mobile/view/auth/two_fa_view.dart';
import 'package:securite_mobile/view/home/home_view.dart';

import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';

/// Types de transitions supportées
enum TransitionType { fade, slideRight, slideBottom }

/// Router principal
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.root,

  /// Redirection sécurisée au lancement
  redirect: (context, state) async {
    if (state.matchedLocation == AppRoutes.root) {
      final storage = SecureStorageService();
      final isLoggedIn = await storage.isLoggedIn();
      return isLoggedIn ? AppRoutes.home : AppRoutes.onboarding;
    }
    return null;
  },

  routes: [
    /// Route racine (invisible)
    GoRoute(
      path: AppRoutes.root,
      builder: (_, __) => const SizedBox.shrink(),
    ),

    /// Onboarding
    _pureRoute(
      path: AppRoutes.onboarding,
      child: const OnboardingView(),
      type: TransitionType.fade,
    ),

    /// Login
    _pureRoute(
      path: AppRoutes.login,
      child: const LoginView(),
      type: TransitionType.slideRight,
    ),

    /// Signup
    _pureRoute(
      path: AppRoutes.signup,
      child: const SignupView(),
      type: TransitionType.slideRight,
    ),

    /// Two Factor Auth
    GoRoute(
      path: AppRoutes.twoFA,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null ||
            extra['verificationToken'] == null ||
            extra['mode'] == null) {
          return const MaterialPage(child: LoginView());
        }

        final String token = extra['verificationToken'];
        final TwoFAMode mode = extra['mode'];
        final String? email = extra['email'];

        return _buildCustomTransition(
          state: state,
          type: TransitionType.slideBottom,
          child: ChangeNotifierProvider(
            create: (_) {
              final vm = TwoFAViewModel(
                verificationToken: token,
                mode: mode,
              );
              if (email != null) vm.setEmail(email);
              return vm;
            },
            child: TwoFAView(
              verificationToken: token,
              mode: mode,
              email: email,
            ),
          ),
        );
      },
    ),

    /// Home
    _pureRoute(
      path: AppRoutes.home,
      child: const HomeView(),
      type: TransitionType.fade,
    ),
  ],
);

//ROUTE SIMPLE AVEC TRANSITION
GoRoute _pureRoute({
  required String path,
  required Widget child,
  TransitionType type = TransitionType.slideRight,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) =>
        _buildCustomTransition(state: state, child: child, type: type),
  );
}

//MOTEUR DE TRANSITION MODERNE (UX 2025)
CustomTransitionPage _buildCustomTransition({
  required GoRouterState state,
  required Widget child,
  required TransitionType type,
}) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,

    //Durées optimisées (rapide & fluide)
    transitionDuration: const Duration(milliseconds: 320),
    reverseTransitionDuration: const Duration(milliseconds: 280),

    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      switch (type) {
        case TransitionType.fade:
          return FadeTransition(
            opacity: curved,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.98, end: 1.0).animate(curved),
              child: child,
            ),
          );

        //Slide horizontal doux (Login / Signup)
        case TransitionType.slideRight:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );

        //Bottom sheet moderne (2FA)
        case TransitionType.slideBottom:
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(curved),
            child: FadeTransition(
              opacity: curved,
              child: child,
            ),
          );
      }
    },
  );
}