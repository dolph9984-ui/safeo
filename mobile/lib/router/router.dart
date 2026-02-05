import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/view/create_file/create_file_view.dart';
import 'package:securite_mobile/view/login_view.dart';
import 'package:securite_mobile/view/shared_files_view.dart';
import 'package:securite_mobile/view/two_fa_view.dart';
import 'package:securite_mobile/view/user_files/user_files_view.dart';
import 'package:securite_mobile/view/widgets/bottom_nav.dart';
import 'package:securite_mobile/view/widgets/top_bar.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: Routes.userFiles,
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
        final location = state.uri.toString();

        final currentIndex = switch (location) {
          String l when l.startsWith(Routes.userFiles) => 0,
          String l when l.startsWith(Routes.createFile) => 1,
          String l when l.startsWith(Routes.sharedFiles) => 2,
          _ => 0,
        };
        return Scaffold(
          appBar: TopBar(),
          bottomNavigationBar: BottomNav(
            onTap: (index) {
              switch (index) {
                case 0:
                  context.go(Routes.userFiles);
                  break;
                case 1:
                  context.pushNamed(Routes.createFile);
                  break;
                case 2:
                  context.go(Routes.sharedFiles);
                  break;
              }
            },
            currentIndex: currentIndex,
          ),
          body: child,
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
