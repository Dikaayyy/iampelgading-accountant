import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_theme.dart';
import 'package:iampelgading/core/navigation/app_navigation.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      home: const AppNavigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
