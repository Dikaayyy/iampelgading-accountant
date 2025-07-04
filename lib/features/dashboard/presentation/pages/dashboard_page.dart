import 'package:flutter/material.dart';
import 'package:iampelgading/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/transaction_section.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardProvider(),
      child: const DashboardView(),
    );
  }
}

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  bool _isBalanceVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      body: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header Section with Overlapping Balance Card
                  _buildHeaderWithBalanceCard(provider),

                  const SizedBox(height: 24),

                  // Transaction List Section
                  TransactionSection(
                    transactions: _getMockTransactions(),
                    isLoading: provider.isLoading,
                    onViewAllTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const FinancialRecordsPage(),
                        ),
                      );
                    },
                    onTransactionTap: (transaction) {
                      // Navigate to transaction detail
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderWithBalanceCard(DashboardProvider provider) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 352,
      child: Stack(
        children: [
          // Dashboard Header
          DashboardHeader(
            screenWidth: screenWidth,
            userName: provider.userName,
          ),

          // Overlapping Balance Card
          Positioned(
            left: 24,
            top: 139,
            right: 24,
            child: BalanceCard(
              balance: provider.netIncome,
              income: provider.totalIncome,
              expense: provider.totalExpense,
              isVisible: _isBalanceVisible,
              onToggleVisibility: () {
                setState(() {
                  _isBalanceVisible = !_isBalanceVisible;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMockTransactions() {
    // Move mock data to a separate method or better yet, to a repository
    return [
      {
        'title': 'Tiket Masuk Wisata',
        'time': '14:30',
        'date': '20 August 2024',
        'amount': 500000.0,
        'icon': Icons.confirmation_number,
      },
      {
        'title': 'Pemeliharaan Fasilitas',
        'time': '10:15',
        'date': '20 August 2024',
        'amount': -250000.0,
        'icon': Icons.build,
      },
      {
        'title': 'Penjualan Souvenir',
        'time': '16:45',
        'date': '19 August 2024',
        'amount': 150000.0,
        'icon': Icons.shopping_bag,
      },
      {
        'title': 'Biaya Kebersihan',
        'time': '09:00',
        'date': '19 August 2024',
        'amount': -75000.0,
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Parkir Kendaraan',
        'time': '08:30',
        'date': '18 August 2024',
        'amount': 50000.0,
        'icon': Icons.local_parking,
      },
    ];
  }
}
