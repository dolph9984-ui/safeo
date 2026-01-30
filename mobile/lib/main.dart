import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:securite_mobile/constants/app_theme.dart';
import 'package:securite_mobile/services/auth/auth_storage_service.dart';
import 'package:securite_mobile/utils/dio_client.dart';
import 'package:securite_mobile/view/onboarding_view.dart';
import 'package:securite_mobile/view/auth/login_view.dart';
import 'package:securite_mobile/view/auth/signup_view.dart';
import 'package:securite_mobile/view/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await DioClient.initialize();  // Pinning + Bearer
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SafeO',
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    if (state.matchedLocation == '/') {
      final isLoggedIn = await AuthStorageService().isLoggedIn();
      return isLoggedIn ? '/home' : '/onboarding';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SizedBox.shrink()),
    GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingView()),
    GoRoute(path: '/login', builder: (context, state) => const LoginView()),
    GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
    GoRoute(path: '/home', builder: (context, state) => const HomeView()),
  ],
);