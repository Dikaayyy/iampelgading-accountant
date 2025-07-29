import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:iampelgading/features/auth/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/navigation/custom_bottom_navbar.dart';
import 'package:iampelgading/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;
import 'package:iampelgading/core/interceptors/auth_interceptor.dart';
import 'dart:async';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation>
    with WidgetsBindingObserver {
  DateTime? _lastPressedAt;
  late final TransactionProvider _transactionProvider;
  Timer? _tokenCheckTimer;

  @override
  void initState() {
    super.initState();
    // Get the singleton instance
    _transactionProvider = di.sl<TransactionProvider>();

    // Start periodic token validation
    _startTokenCheck();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _tokenCheckTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      // Cek token setiap kali app di-resume
      final authService = di.sl<AuthService>();
      final isValid = await authService.isTokenValid();
      if (!isValid) {
        await authService.logout();
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      }
    }
  }

  void _startTokenCheck() {
    _tokenCheckTimer = Timer.periodic(const Duration(seconds: 30), (
      timer,
    ) async {
      final isValid = await di.sl<AuthService>().isTokenValid();
      if (!isValid) {
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _onWillPop();
      },
      child: ChangeNotifierProvider.value(
        value: _transactionProvider,
        child: CustomBottomNavbar(
          screens: [
            const DashboardPage(),
            const _PlaceholderPage(title: 'Add Transaction'),
            const FinancialRecordsPage(),
          ],
        ),
      ),
    );
  }

  void _onWillPop() {
    final now = DateTime.now();

    if (_lastPressedAt == null ||
        now.difference(_lastPressedAt!) > const Duration(seconds: 2)) {
      _lastPressedAt = now;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tekan sekali lagi untuk keluar'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      SystemNavigator.pop();
    }
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text(title)),
    );
  }
}
