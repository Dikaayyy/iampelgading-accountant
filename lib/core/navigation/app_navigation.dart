import 'package:flutter/material.dart';
import 'package:iampelgading/core/navigation/custom_bottom_navbar.dart';
import 'package:iampelgading/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/profile/presentation/pages/profile_page.dart';

class AppNavigation extends StatefulWidget {
  const AppNavigation({super.key});

  @override
  State<AppNavigation> createState() => _AppNavigationState();
}

class _AppNavigationState extends State<AppNavigation> {
  @override
  Widget build(BuildContext context) {
    return CustomBottomNavbar(
      screens: [
        const DashboardPage(),
        const FinancialRecordsPage(),
        const _PlaceholderPage(title: 'Add Transaction'),
        const _PlaceholderPage(title: 'Wallet'),
        const ProfilePage(),
      ],
    );
  }
}

class _PlaceholderPage extends StatelessWidget {
  final String title;

  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.construction, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              '$title Page',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Coming Soon', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
