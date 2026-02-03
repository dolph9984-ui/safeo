import 'package:flutter/material.dart';
import 'package:securite_mobile/constants/app_theme.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';
import 'package:securite_mobile/router/app_router.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageService().initialize();
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
      routerConfig: appRouter, 
    );
  }
}