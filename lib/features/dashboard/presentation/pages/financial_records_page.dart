import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/transaction_card.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_tab_bar.dart';
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

    // Filter transaksi hari ini dan pengeluaran
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final expenseTransactions =
        provider.transactions
            .where(
              (transaction) =>
                  !transaction.isIncome &&
                  transaction.date.isAfter(
                    todayStart.subtract(const Duration(seconds: 1)),
                  ) &&
                  transaction.date.isBefore(
                    todayEnd.add(const Duration(seconds: 1)),
                  ),
            )
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
              'Belum ada pengeluaran hari ini',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: expenseTransactions.length,
      itemBuilder: (context, index) {
        final tx = expenseTransactions[index];
        return TransactionCard(
          title: tx.title,
          category: tx.category,
          time: DateFormat('HH:mm').format(tx.date),
          date: DateFormat('d MMMM yyyy', 'id_ID').format(tx.date),
          amount: tx.amount,
          categoryIcon: Icons.trending_down,
          onTap: () {
            // detail page logic here
          },
        );
      },
    );
  }

  Widget _buildIncomeTab(TransactionProvider provider) {
    if (provider.isLoadingTransactions) {
      return const Center(child: CircularProgressIndicator());
    }

    // Filter transaksi hari ini dan pemasukan
    final today = DateTime.now();
    final todayStart = DateTime(today.year, today.month, today.day);
    final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final incomeTransactions =
        provider.transactions
            .where(
              (transaction) =>
                  transaction.isIncome &&
                  transaction.date.isAfter(
                    todayStart.subtract(const Duration(seconds: 1)),
                  ) &&
                  transaction.date.isBefore(
                    todayEnd.add(const Duration(seconds: 1)),
                  ),
            )
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
              'Belum ada pemasukan hari ini',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: incomeTransactions.length,
      itemBuilder: (context, index) {
        final tx = incomeTransactions[index];
        return TransactionCard(
          title: tx.title,
          category: tx.category,
          time: DateFormat('HH:mm').format(tx.date),
          date: DateFormat('d MMMM yyyy', 'id_ID').format(tx.date),
          amount: tx.amount,
          categoryIcon: Icons.trending_up,
          onTap: () {
            // detail page logic here
          },
        );
      },
    );
  }
}
