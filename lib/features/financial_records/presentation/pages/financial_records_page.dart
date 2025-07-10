import 'package:flutter/material.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_tab_bar.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_transaction_list.dart';
import 'package:iampelgading/core/widgets/custom_search_field.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';

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
      body: Column(
        children: [
          const SizedBox(height: 24),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomSearchField(
              controller: _searchController,
              hintText: 'Cari transaksi...',
              onChanged: (value) {
                // Implement search functionality here
                setState(() {
                  // Filter your transactions based on search value
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
                FinancialTransactionList(
                  transactions: _getExpenseTransactions(),
                  isExpense: true,
                ),
                // Pemasukan (Income)
                FinancialTransactionList(
                  transactions: _getIncomeTransactions(),
                  isExpense: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getExpenseTransactions() {
    return [
      {
        'title': 'Pemeliharaan Fasilitas',
        'time': '10:15',
        'date': '20 August 2024',
        'amount': 250000.0,
        'icon': Icons.build,
        'paymentMethod': 'Cash',
        'description': 'Pemeliharaan rutin fasilitas wisata',
      },
      {
        'title': 'Biaya Kebersihan',
        'time': '09:00',
        'date': '19 August 2024',
        'amount': 75000.0,
        'icon': Icons.cleaning_services,
        'paymentMethod': 'Transfer Bank',
        'description': 'Biaya kebersihan harian',
      },
      {
        'title': 'Konsumsi Staff',
        'time': '13:23',
        'date': '18 August 2024',
        'amount': 550000.0,
        'icon': Icons.restaurant,
        'paymentMethod': 'Cash',
        'description': 'Konsumsi untuk staff selama 1 minggu',
      },
    ];
  }

  List<Map<String, dynamic>> _getIncomeTransactions() {
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
        'title': 'Penjualan Souvenir',
        'time': '16:45',
        'date': '19 August 2024',
        'amount': 150000.0,
        'icon': Icons.shopping_bag,
        'paymentMethod': 'QRIS',
        'description': 'Penjualan souvenir dan merchandise',
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
