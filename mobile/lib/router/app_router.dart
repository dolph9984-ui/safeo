import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';
import 'package:securite_mobile/view/onboarding_view.dart';
import 'package:securite_mobile/view/auth/login_view.dart';
import 'package:securite_mobile/view/auth/signup_view.dart';
import 'package:securite_mobile/view/auth/two_fa_view.dart';
import 'package:securite_mobile/view/home/home_view.dart';
import 'package:securite_mobile/view/create_file_view.dart';
import 'package:securite_mobile/view/shared_files_view.dart';
import 'package:securite_mobile/view/user_files_view.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.root,

  redirect: (context, state) async {
    if (state.matchedLocation == AppRoutes.root) {
      final storage = SecureStorageService();
      final isLoggedIn = await storage.isLoggedIn();
      return isLoggedIn ? AppRoutes.home : AppRoutes.onboarding;
    }
    return null;
  },

  routes: [
    GoRoute(
      path: AppRoutes.root,
      builder: (_, __) => const SizedBox.shrink(),
    ),

    // Onboarding
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingView(),
    ),

    // Login
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginView(),
    ),

    // Signup
    GoRoute(
      path: AppRoutes.signup,
      builder: (context, state) => const SignupView(),
    ),

    // Two Factor Auth
    GoRoute(
      path: AppRoutes.twoFA,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null ||
            extra['verificationToken'] == null ||
            extra['mode'] == null) {
          return const LoginView();
        }

        final String token = extra['verificationToken'];
        final TwoFAMode mode = extra['mode'];
        final String? email = extra['email'];

        return ChangeNotifierProvider(
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
        );
      },
    ),

    // Create file
    GoRoute(
      path: AppRoutes.createFile,
      builder: (context, state) => const CreateFileView(),
    ),

    // Home
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(items: []),
        );
      },
      routes: [
        // User files
        GoRoute(
          path: AppRoutes.userFiles, 
          builder: (context, state) => const UserFilesView(),
        ),

        // Shared files
        GoRoute(
          path: AppRoutes.sharedFiles, 
          builder: (context, state) => const SharedFilesView(),
        ),
      ],
    ),
  ],
);