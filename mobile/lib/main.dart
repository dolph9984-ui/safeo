import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/routes.dart';
import 'package:securite_mobile/view/login_view.dart';
import 'package:securite_mobile/view/two_fa_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.login,
      routes: {
        Routes.login: (_) => LoginView(),
        Routes.twoFA: (_) => TwoFAView(),
      },
    );
  }
}
