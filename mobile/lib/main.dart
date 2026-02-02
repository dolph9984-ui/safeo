import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_theme.dart';
import 'package:securite_mobile/router/router.dart';
import 'package:securite_mobile/viewmodel/create_file_viewmodel.dart';
import 'package:securite_mobile/viewmodel/login_viewmodel.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';
import 'package:securite_mobile/viewmodel/two_fa_viewmodel.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => TwoFAViewModel()),
        ChangeNotifierProvider(create: (_) => UserFilesViewModel()),
        ChangeNotifierProvider(create: (_) => SharedFilesViewModel()),
        ChangeNotifierProvider(create: (_) => CreateFileViewModel()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
        title: 'SafeO',
        theme: AppTheme.lightTheme,
      ),
    );
  }
}
