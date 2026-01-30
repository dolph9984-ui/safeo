import 'package:flutter/material.dart';
import 'package:securite_mobile/router/routes.dart';
import 'package:securite_mobile/view/home_view.dart';
import 'package:securite_mobile/view/login_view.dart';
import 'package:securite_mobile/view/two_fa_view.dart';
import 'package:securite_mobile/constants/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SafeO',
      theme: AppTheme.lightTheme,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (_) => const LoginView(),
        Routes.twoFA: (_) => const TwoFAView(),
        Routes.home: (_) => const HomeView(),
      },
    );
  }
}
