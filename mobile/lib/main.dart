import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:securite_mobile/constants/app_theme.dart';
import 'package:securite_mobile/model/session_model.dart';
import 'package:securite_mobile/router/app_router.dart';
import 'package:securite_mobile/services/security/secure_storage_service.dart';
import 'package:securite_mobile/utils/dio_util.dart';
import 'package:securite_mobile/viewmodel/create_file_viewmodel.dart';
import 'package:securite_mobile/viewmodel/scaffold_viewmodel.dart';
import 'package:securite_mobile/viewmodel/shared_files_viewmodel.dart';
import 'package:securite_mobile/viewmodel/trash_viewmodel.dart';
import 'package:securite_mobile/viewmodel/user_files_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SecureStorageService().initialize();
  await SessionModel().resumeSession();
  DioClient.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            final vm = ScaffoldViewModel();
            vm.init();
            return vm;
          },
        ),
        ChangeNotifierProvider(create: (_) => TrashViewModel()),
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
