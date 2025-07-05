import 'package:flutter/material.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_tab_bar.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_transaction_list.dart';

class FinancialRecordsPage extends StatefulWidget {
  const FinancialRecordsPage({super.key});

  @override
  State<FinancialRecordsPage> createState() => _FinancialRecordsPageState();
}

class _FinancialRecordsPageState extends State<FinancialRecordsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      body: Column(
        children: [
          // Header with orange background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 64,
              left: 24,
              right: 24,
              bottom: 19,
            ),
            decoration: const BoxDecoration(color: Color(0xFFFFB74D)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 72),
                const Text(
                  'Catatan Keuangan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 63),

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
      },
      {
        'title': 'Biaya Kebersihan',
        'time': '09:00',
        'date': '19 August 2024',
        'amount': 75000.0,
        'icon': Icons.cleaning_services,
      },
      {
        'title': 'Konsumsi Staff',
        'time': '13:23',
        'date': '18 August 2024',
        'amount': 550000.0,
        'icon': Icons.restaurant,
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
      },
      {
        'title': 'Penjualan Souvenir',
        'time': '16:45',
        'date': '19 August 2024',
        'amount': 150000.0,
        'icon': Icons.shopping_bag,
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
