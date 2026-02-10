import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/permissions.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/router/app_routes.dart';
import 'package:securite_mobile/utils/share_dialog_helper.dart';
import 'package:securite_mobile/view/app_scaffold.dart';
import 'package:securite_mobile/view/auth/login_view.dart';
import 'package:securite_mobile/view/auth/signup_view.dart';
import 'package:securite_mobile/view/auth/two_fa_view.dart';
import 'package:securite_mobile/view/battery_monitor.dart';
import 'package:securite_mobile/view/create_file/create_file_view.dart';
import 'package:securite_mobile/view/home/home_view.dart';
import 'package:securite_mobile/view/onboarding_view.dart';
import 'package:securite_mobile/view/search_page/search_page_view.dart';
import 'package:securite_mobile/view/share_file/share_file_view.dart';
import 'package:securite_mobile/view/shared_files/shared_files_view.dart';
import 'package:securite_mobile/view/sharehandling/sharehandling_view.dart';
import 'package:securite_mobile/view/trash/trash_view.dart';
import 'package:securite_mobile/view/user_files/user_files_view.dart';
import 'package:securite_mobile/viewmodel/auth/two_fa_viewmodel.dart';
import 'package:securite_mobile/viewmodel/trash_viewmodel.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/battery',

  refreshListenable: isAppUnlocked,

  redirect: (context, state) async {
    final currentLocation = state.matchedLocation;
    final isLoggedIn = await SessionModel().isLoggedIn;

    if (!isAppUnlocked.value && currentLocation != '/battery') {
      return '/battery';
    }

    if (isAppUnlocked.value &&
        !isLoggedIn &&
        !currentLocation.startsWith(AppRoutes.login) &&
        !currentLocation.startsWith(AppRoutes.signup) &&
        !currentLocation.startsWith(AppRoutes.twoFA) &&
        !currentLocation.startsWith(AppRoutes.onboarding) &&
        !currentLocation.startsWith(AppRoutes.shareInvitation)) {
      return AppRoutes.onboarding;
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/battery',
      builder: (context, state) => const BatteryMonitorView(),
    ),
    GoRoute(path: AppRoutes.root, builder: (_, _) => const SizedBox.shrink()),
    GoRoute(
      path: AppRoutes.authCallback,
      redirect: (context, state) => AppRoutes.root,
    ),

    // Onboarding
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingView(),
    ),

    // Home
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomeView(),
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
            final vm = TwoFAViewModel(verificationToken: token, mode: mode);
            if (email != null) vm.setEmail(email);
            return vm;
          },
          child: TwoFAView(verificationToken: token, mode: mode, email: email),
        );
      },
    ),

    // create file
    GoRoute(
      path: AppRoutes.createFile,
      name: AppRoutes.createFile,
      builder: (context, state) => const CreateFileView(),
    ),

    // trash
    GoRoute(
      path: AppRoutes.trash,
      name: AppRoutes.trash,
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => TrashViewModel(),
        child: const TrashView(),
      ),
    ),

    // search
    GoRoute(
      path: AppRoutes.searchPage,
      name: AppRoutes.searchPage,
      builder: (context, state) => const SearchPageView(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        final location = state.uri.toString();
        bool canPop = location.startsWith(AppRoutes.userFiles);

        final currentIndex = switch (location) {
          String l when l.startsWith(AppRoutes.userFiles) => 0,
          String l when l.startsWith(AppRoutes.createFile) => 1,
          String l when l.startsWith(AppRoutes.sharedFiles) => 2,
          _ => 0,
        };

        return PopScope(
          canPop: canPop,
          onPopInvokedWithResult: (didPop, result) {
            context.go(AppRoutes.userFiles);
          },
          child: AppScaffold(currentIndex: currentIndex, child: child),
        );
      },
      routes: [
        // user files
        GoRoute(
          path: AppRoutes.userFiles,
          name: AppRoutes.userFiles,
          builder: (context, state) => const UserFilesView(),
        ),

        // shared files
        GoRoute(
          path: AppRoutes.sharedFiles,
          name: AppRoutes.sharedFiles,
          builder: (context, state) => const SharedFilesView(),
        ),
      ],
    ),

    //share-file
    GoRoute(
      path: '${AppRoutes.shareFile}/:fileId',
      name: AppRoutes.shareFile,
      builder: (context, state) {
        final fileId = state.pathParameters['fileId'] ?? '';
        final autoFocus = state.uri.queryParameters['autoFocus'] == 'true';

        if (fileId.isEmpty) {
          return const UserFilesView();
        }

        return ShareFileView(fileId: fileId, autoFocus: autoFocus);
      },
    ),

    GoRoute(
      path: '${AppRoutes.shareHandling}/:fileId',
      name: AppRoutes.shareHandling,
      builder: (context, state) {
        final fileId = state.pathParameters['fileId'] ?? '';

        if (fileId.isEmpty) {
          return const UserFilesView();
        }

        return ShareHandlingView(fileId: fileId);
      },
    ),

    GoRoute(
      path: AppRoutes.shareInvitation,
      name: AppRoutes.shareInvitation,
      builder: (context, state) {
        final token = state.uri.queryParameters['token'] ?? '';
        final fileName = state.uri.queryParameters['fileName'] ?? 'Fichier';
        final ownerName = state.uri.queryParameters['ownerName'] ?? 'Un utilisateur';

        if (token.isEmpty) {
          return const UserFilesView();
        }

        // Afficher le dialog directement
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showShareInvitationDialog(
            context: context,
            token: token,
            fileName: fileName,
            ownerName: ownerName,
          );
        });

        // Retourner un écran de fond (ou un loading)
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    ),
  ],
);