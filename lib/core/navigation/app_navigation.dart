import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/navigation/custom_bottom_navbar.dart';
import 'package:iampelgading/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/profile/presentation/pages/profile_page.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;
import 'package:iampelgading/core/interceptors/auth_interceptor.dart';
import 'dart:async';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
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
  }

  @override
  void dispose() {
    _tokenCheckTimer?.cancel();
    super.dispose();
  }

  void _startTokenCheck() {
    // Check token every 5 minutes
    _tokenCheckTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      AuthInterceptor.checkTokenValidity();
      AuthInterceptor.checkTokenExpirationWarning();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;

        // Handle back button press - show exit confirmation
        _onWillPop();
      },
      child: ChangeNotifierProvider.value(
        value: _transactionProvider,
        child: CustomBottomNavbar(
          screens: [
            const DashboardPage(),
            const FinancialRecordsPage(),
            const _PlaceholderPage(title: 'Add Transaction'),
            const _PlaceholderPage(title: 'Wallet'),
            const ProfilePage(),
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
