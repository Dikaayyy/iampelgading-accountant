import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/transaction_section.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/transaction_detail_page.dart';
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
      backgroundColor: AppColors.background[200],
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
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: const FinancialRecordsPage(),
                        withNavBar: false, // This hides the bottom navbar
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    onTransactionTap: (transaction) {
                      // Navigate to transaction detail from dashboard
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: TransactionDetailPage(
                          transaction: transaction,
                          isExpense: (transaction['amount'] as double) < 0,
                        ),
                        withNavBar: false, // This hides the bottom navbar
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
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
    return [
      {
        'title': 'Tiket Masuk Wisata',
        'time': '14:30',
        'date': '20 August 2024',
        'amount': 500000.0,
        'icon': Icons.confirmation_number,
        'paymentMethod': 'Cash',
        'description': 'Penjualan tiket masuk wisata hari ini',
      },
      {
        'title': 'Pemeliharaan Fasilitas',
        'time': '10:15',
        'date': '20 August 2024',
        'amount': -250000.0,
        'icon': Icons.build,
        'paymentMethod': 'Cash',
        'description': 'Pemeliharaan rutin fasilitas wisata',
      },
      {
        'title': 'Penjualan Souvenir',
        'time': '16:45',
        'date': '19 August 2024',
        'amount': 150000.0,
        'icon': Icons.shopping_bag,
        'paymentMethod': 'QRIS',
        'description': 'Penjualan souvenir dan merchandise',
      },
      {
        'title': 'Biaya Kebersihan',
        'time': '09:00',
        'date': '19 August 2024',
        'amount': -75000.0,
        'icon': Icons.cleaning_services,
        'paymentMethod': 'Transfer Bank',
        'description': 'Biaya kebersihan harian',
      },
      {
        'title': 'Parkir Kendaraan',
        'time': '08:30',
        'date': '18 August 2024',
        'amount': 50000.0,
        'icon': Icons.local_parking,
        'paymentMethod': 'Cash',
        'description': 'Biaya parkir kendaraan pengunjung',
      },
    ];
  }
}
