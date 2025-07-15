import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_theme.dart';
import 'package:iampelgading/features/auth/presentation/pages/login_page.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await di.init();

  await initializeDateFormatting('id_ID', null);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akuntansi Iampelgading',
      theme: AppTheme.lightTheme,
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
