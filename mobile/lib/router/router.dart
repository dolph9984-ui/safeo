import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/view/create_file_view.dart';
import 'package:securite_mobile/view/login_view.dart';
import 'package:securite_mobile/view/shared_files_view.dart';
import 'package:securite_mobile/view/two_fa_view.dart';
import 'package:securite_mobile/view/user_files_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.login,
  routes: [
    // login
    GoRoute(
      path: Routes.login,
      name: Routes.login,
      builder: (context, state) => const LoginView(),
    ),

    // 2FA
    GoRoute(
      path: Routes.twoFA,
      name: Routes.twoFA,
      builder: (context, state) => const TwoFAView(),
    ),

    // create file
    GoRoute(
      path: Routes.createFile,
      name: Routes.createFile,
      builder: (context, state) => const CreateFileView(),
    ),

    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(items: []),
        );
      },
      routes: [
        // user files
        GoRoute(
          path: Routes.userFiles,
          name: Routes.userFiles,
          builder: (context, state) => const UserFilesView(),
        ),

        // shared files
        GoRoute(
          path: Routes.sharedFiles,
          name: Routes.sharedFiles,
          builder: (context, state) => const SharedFilesView(),
        ),
      ],
    ),
  ],
);
