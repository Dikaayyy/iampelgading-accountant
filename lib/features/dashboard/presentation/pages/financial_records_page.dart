import 'package:flutter/material.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_tab_bar.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_transaction_list.dart';
import 'package:iampelgading/core/widgets/custom_search_field.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

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
                    provider.updateSearchQuery(value);
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

    // Use filtered transactions instead of all transactions
    final expenseTransactions =
        provider.filteredTransactions
            .where((transaction) => !transaction.isIncome)
            .map((transaction) => provider.transactionToMap(transaction))
            .toList();

    if (expenseTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'Tidak ada pengeluaran yang ditemukan'
                  : 'Belum ada pengeluaran',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (provider.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
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

    // Use filtered transactions instead of all transactions
    final incomeTransactions =
        provider.filteredTransactions
            .where((transaction) => transaction.isIncome)
            .map((transaction) => provider.transactionToMap(transaction))
            .toList();

    if (incomeTransactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              provider.searchQuery.isNotEmpty
                  ? 'Tidak ada pemasukan yang ditemukan'
                  : 'Belum ada pemasukan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (provider.searchQuery.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
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
