import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_theme.dart';
import 'package:securite_mobile/router/app_router.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';
import 'package:securite_mobile/utils/dio_util.dart';
import 'package:securite_mobile/viewmodel/create_file_viewmodel.dart';
import 'package:securite_mobile/viewmodel/share_file_viewmodel.dart';
import 'package:securite_mobile/viewmodel/scaffold_view_model.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageService().initialize();
  DioClient.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ScaffoldViewModel()),
        ChangeNotifierProvider(create: (_) => UserFilesViewModel()),
        ChangeNotifierProvider(create: (_) => SharedFilesViewModel()),
        ChangeNotifierProvider(create: (_) => CreateFileViewModel()),
        ChangeNotifierProvider(create: (_) => ShareFileViewModel()),
        
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
