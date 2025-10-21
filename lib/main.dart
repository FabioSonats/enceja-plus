import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_router.dart';
import 'core/constants/app_constants.dart';
import 'data/datasources/simple_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar banco de dados simples
  await SimpleDatabase.initializeMockData();

  runApp(const ENCCEJAPlusApp());
}

class ENCCEJAPlusApp extends StatelessWidget {
  const ENCCEJAPlusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRouter.router,
    );
  }
}
