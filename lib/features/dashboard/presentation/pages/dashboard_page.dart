import 'package:flutter/material.dart';
import 'package:iampelgading/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header_background.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/simple_transaction_item.dart';
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
                  _buildTransactionSection(provider),
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
          // Orange Background with Rounded Bottom
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 278,
              decoration: const ShapeDecoration(
                color: Color(0xFFFFB74D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
            ),
          ),

          // Background Pattern using SVG
          Positioned(
            left: 0,
            top: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: SizedBox(
                width: screenWidth,
                height: 278,
                child: const DashboardHeaderBackground(
                  height: 278,
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),

          // Welcome Text
          Positioned(
            left: 24,
            top: 68,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Halo,',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.80,
                  ),
                ),
                Text(
                  provider.userName ?? 'Admin Iampelgading',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
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

  Widget _buildTransactionSection(DashboardProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  color: Color(0xFF202D41),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigate to all transactions
                },
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFF64B5F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Transaction List
          if (provider.isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            _buildTransactionList(),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    // Sample transaction data - replace with actual data from provider
    final transactions = [
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

    return Column(
      children: [
        for (int i = 0; i < transactions.length; i++) ...[
          SimpleTransactionItem(
            title: transactions[i]['title'] as String,
            time: transactions[i]['time'] as String,
            date: transactions[i]['date'] as String,
            amount: transactions[i]['amount'] as double,
            icon: transactions[i]['icon'] as IconData,
            onTap: () {
              // Navigate to transaction detail
            },
          ),
          if (i < transactions.length - 1)
            Opacity(
              opacity: 0.10,
              child: Container(
                width: double.infinity,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: ShapeDecoration(
                  color: const Color(0xFF6A788D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        ],

        const SizedBox(height: 24),
      ],
    );
  }
}
