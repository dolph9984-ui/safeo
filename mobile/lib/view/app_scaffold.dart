import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/view/widgets/app_drawer.dart';
import 'package:securite_mobile/view/widgets/bottom_nav.dart';
import 'package:securite_mobile/view/widgets/confirm_dialog.dart';
import 'package:securite_mobile/view/widgets/top_bar.dart';
import 'package:securite_mobile/viewmodel/scaffold_viewmodel.dart';

import '../constants/app_colors.dart';
import '../router/app_routes.dart';

class AppScaffold extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const AppScaffold({
    super.key,
    required this.currentIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<ScaffoldViewModel>().scaffoldKey,
      drawer: Consumer<ScaffoldViewModel>(
        builder: (context, vm, _) => AppDrawer(
          username: vm.userName,
          email: vm.email,
          filesNbr: vm.filesNumber,
          sharedFilesNbr: vm.sharedFilesNumber,
          onTrashTap: () {
            context.pop();
            context.pushNamed(AppRoutes.trash);
          },
          onLogoutTap: () {
            showDialog(
              context: context,
              barrierColor: Colors.transparent,
              animationStyle: AnimationStyle(
                duration: Duration(milliseconds: 0),
              ),
              builder: (_) {
                return ConfirmDialog(
                  title: 'Se déconnecter',
                  description: 'Voulez-vous vraiment vous déconnecter',
                  cancelLabel: 'Annuler',
                  confirmLabel: 'Se déconnecter',
                  confirmBgColor: AppColors.primary,
                  onCancel: () {},
                  onConfirm: () async => await vm.logout(),
                );
              },
            );
          },
        ),
      ),
      appBar: TopBar(),
      bottomNavigationBar: BottomNav(
        onTap: (index) {
          switch (index) {
            case 0:
              context.go(AppRoutes.userFiles);
              break;
            case 1:
              context.pushNamed(AppRoutes.createFile);
              break;
            case 2:
              context.go(AppRoutes.sharedFiles);
              break;
          }
        },
        currentIndex: currentIndex,
      ),
      body: child,
    );
  }
}
