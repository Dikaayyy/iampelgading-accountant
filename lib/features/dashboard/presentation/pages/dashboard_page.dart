import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/transaction_section.dart';
import 'package:iampelgading/features/dashboard/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/transaction_detail_page.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, transactionProvider, child) {
        return ChangeNotifierProvider(
          create:
              (_) =>
                  DashboardProvider(transactionProvider: transactionProvider),
          child: const DashboardView(),
        );
      },
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
  void initState() {
    super.initState();
    // Load transactions when dashboard initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background[200],
      body: Consumer2<DashboardProvider, TransactionProvider>(
        builder: (context, dashboardProvider, transactionProvider, child) {
          return RefreshIndicator(
            onRefresh: dashboardProvider.refreshDashboard,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Header Section with Overlapping Balance Card
                  _buildHeaderWithBalanceCard(dashboardProvider),

                  const SizedBox(height: 24),

                  // Transaction List Section
                  TransactionSection(
                    transactions: dashboardProvider.recentTransactionsAsMap,
                    isLoading:
                        dashboardProvider.isLoading ||
                        transactionProvider.isLoadingTransactions,
                    onViewAllTap: () {
                      // Navigate to the correct FinancialRecordsPage with tabs
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ChangeNotifierProvider.value(
                          value: transactionProvider,
                          child: const FinancialRecordsPage(),
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    onTransactionTap: (transaction) {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: TransactionDetailPage(
                          transaction: transaction,
                          isExpense: (transaction['amount'] as double) < 0,
                        ),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),

                  // Show empty state if no transactions
                  if (dashboardProvider.recentTransactions.isEmpty &&
                      !transactionProvider.isLoadingTransactions)
                    Container(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada transaksi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Transaksi yang Anda tambahkan akan muncul di sini',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
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
}
