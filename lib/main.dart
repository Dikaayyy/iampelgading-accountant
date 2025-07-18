import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/theme/app_theme.dart';
import 'package:iampelgading/features/auth/presentation/pages/login_page.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;
import 'package:iampelgading/core/navigation/app_navigation.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:intl/date_symbol_data_local.dart';

// Global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: di.sl<TransactionProvider>()),
      ],
      child: MaterialApp(
        title: 'Akuntansi Iampelgading',
        theme: AppTheme.lightTheme,
        home: const AuthChecker(),
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  late AuthService _authService;
  bool _isChecking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _authService = di.sl<AuthService>();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final isLoggedIn = await _authService.isLoggedIn();
      setState(() {
        _isLoggedIn = isLoggedIn;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _isLoggedIn = false;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isLoggedIn ? const AppNavigation() : const LoginPage();
  }
}
