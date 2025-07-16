import 'package:flutter/material.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_tab_bar.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_transaction_list.dart';
import 'package:iampelgading/core/widgets/custom_search_field.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:intl/intl.dart';

class FinancialRecordsPage extends StatefulWidget {
  const FinancialRecordsPage({super.key});

  @override
  State<FinancialRecordsPage> createState() => _FinancialRecordsPageState();
}

class _FinancialRecordsPageState extends State<FinancialRecordsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load transactions when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      appBar: CustomAppBar(
        title: 'Catatan Keuangan',
        backgroundColor: const Color(0xFFFFB74D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              const SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomSearchField(
                  controller: _searchController,
                  hintText: 'Cari transaksi...',
                  onChanged: (value) {
                    setState(() {
                      // Filter transactions based on search value
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Tab Bar
              FinancialTabBar(tabController: _tabController),

              const SizedBox(height: 16),

              // Tab View Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Pengeluaran (Expenses)
                    _buildExpenseTab(provider),
                    // Pemasukan (Income)
                    _buildIncomeTab(provider),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildExpenseTab(TransactionProvider provider) {
    if (provider.isLoadingTransactions) {
      return const Center(child: CircularProgressIndicator());
    }

    final expenseTransactions =
        provider.transactions
            .where((transaction) => !transaction.isIncome)
            .map((transaction) => provider.transactionToMap(transaction))
            .toList();

    if (expenseTransactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada pengeluaran'),
          ],
        ),
      );
    }

    return FinancialTransactionList(
      transactions: expenseTransactions,
      isExpense: true,
    );
  }

  Widget _buildIncomeTab(TransactionProvider provider) {
    if (provider.isLoadingTransactions) {
      return const Center(child: CircularProgressIndicator());
    }

    final incomeTransactions =
        provider.transactions
            .where((transaction) => transaction.isIncome)
            .map((transaction) => provider.transactionToMap(transaction))
            .toList();

    if (incomeTransactions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Belum ada pemasukan'),
          ],
        ),
      );
    }

    return FinancialTransactionList(
      transactions: incomeTransactions,
      isExpense: false,
    );
  }
}
