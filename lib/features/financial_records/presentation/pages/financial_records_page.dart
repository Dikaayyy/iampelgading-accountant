import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/custom_search_field.dart';
import 'package:iampelgading/core/widgets/unified_transaction_item.dart';
import 'package:iampelgading/core/widgets/custom_bottom_sheet.dart';
import 'package:iampelgading/core/widgets/snackbar_helper.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/balance_card.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_header.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/transaction_history_header.dart';

class FinancialRecordsPage extends StatefulWidget {
  const FinancialRecordsPage({super.key});

  @override
  State<FinancialRecordsPage> createState() => _FinancialRecordsPageState();
}

class _FinancialRecordsPageState extends State<FinancialRecordsPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isBalanceVisible = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background[200],
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Header Section with Overlapping Balance Card
              _buildHeaderWithBalanceCard(screenWidth),

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

              // Transaction History Header
              TransactionHistoryHeader(
                onDownloadPressed: _handleDownloadPressed,
              ),

              // Transactions grouped by month
              _buildTransactionsByMonth(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderWithBalanceCard(double screenWidth) {
    return SizedBox(
      height: 320, // Reduced height since no greeting text
      child: Stack(
        children: [
          // Dashboard Header without greeting
          FinancialHeader(
            screenWidth: screenWidth,
            showGreeting: false, // Hide the greeting text
          ),

          // Overlapping Balance Card - positioned higher
          Positioned(
            left: 24,
            top: 100, // Moved higher up
            right: 24,
            child: BalanceCard(
              balance: 2200000.0,
              income: 2700000.0,
              expense: 500000.0,
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

  Widget _buildTransactionsByMonth() {
    final groupedTransactions = _getTransactionsGroupedByMonth();

    return Column(
      children:
          groupedTransactions.entries.map((entry) {
            final month = entry.key;
            final transactions = entry.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Month Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Text(
                    month,
                    style: AppTextStyles.h3.copyWith(
                      color: const Color(0xFF202D41),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Transactions for this month
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      for (int i = 0; i < transactions.length; i++) ...[
                        UnifiedTransactionItem(
                          title: transactions[i]['title'] as String,
                          time: transactions[i]['time'] as String,
                          date: transactions[i]['date'] as String,
                          amount: transactions[i]['amount'] as double,
                          icon: transactions[i]['icon'] as IconData,
                          transactionData: transactions[i],
                          onEdit: () => _handleEditTransaction(transactions[i]),
                          onDelete:
                              () => _handleDeleteTransaction(transactions[i]),
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
                    ],
                  ),
                ),

                const SizedBox(height: 12),
              ],
            );
          }).toList(),
    );
  }

  void _handleEditTransaction(Map<String, dynamic> transaction) {
    // TODO: Navigate to edit transaction page
    SnackbarHelper.showInfo(
      context: context,
      title: 'Edit Transaksi',
      message:
          'Fitur edit transaksi "${transaction['title']}" akan segera tersedia',
      showAtTop: true,
    );
  }

  void _handleDeleteTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Transaksi'),
          content: Text(
            'Apakah Anda yakin ingin menghapus transaksi "${transaction['title']}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _confirmDeleteTransaction(transaction);
              },
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteTransaction(Map<String, dynamic> transaction) {
    // TODO: Implement actual delete functionality
    // For now, just show a success message
    SnackbarHelper.showSuccess(
      context: context,
      title: 'Transaksi Dihapus',
      message: 'Transaksi "${transaction['title']}" berhasil dihapus',
      showAtTop: true,
    );

    // Optionally refresh the data
    setState(() {
      // Remove the transaction from the list or refresh data
    });
  }

  void _handleDownloadPressed() {
    CustomBottomSheet.show(
      context: context,
      title: 'Ekspor Data Transaksi',
      items: [
        BottomSheetItem(
          title: 'Ekspor ke CSV',
          subtitle: 'Unduh data transaksi dalam format CSV',
          icon: Icons.table_chart_outlined,
          iconColor: const Color(0xFF40B029),
          iconBackgroundColor: const Color(0xFF40B029).withOpacity(0.1),
          onTap: () {
            Navigator.of(context).pop();
            _exportToCsv();
          },
        ),
      ],
    );
  }

  void _exportToCsv() {
    // TODO: Implement actual CSV export functionality
    try {
      // Simulate the export process
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          // Simulate random success/failure for demo
          final isSuccess = DateTime.now().millisecondsSinceEpoch % 2 == 0;

          if (isSuccess) {
            // Show success message at top
            SnackbarHelper.showSuccess(
              context: context,
              title: 'Ekspor Berhasil',
              message: 'Data transaksi berhasil diekspor ke CSV',
              duration: const Duration(seconds: 3),
              showAtTop: true, // Show at top
            );
          } else {
            // Show error message at top
            SnackbarHelper.showError(
              context: context,
              title: 'Ekspor Gagal',
              message: 'Terjadi kesalahan saat mengekspor data',
              duration: const Duration(seconds: 3),
              showAtTop: true, // Show at top
            );
          }
        }
      });
    } catch (e) {
      // Handle any immediate errors at top
      SnackbarHelper.showError(
        context: context,
        title: 'Error',
        message: 'Terjadi kesalahan: ${e.toString()}',
        showAtTop: true, // Show at top
      );
    }
  }

  Map<String, List<Map<String, dynamic>>> _getTransactionsGroupedByMonth() {
    final allTransactions = [
      // August 2024
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
      {
        'title': 'Konsumsi Staff',
        'time': '13:23',
        'date': '18 August 2024',
        'amount': -550000.0,
        'icon': Icons.restaurant,
        'paymentMethod': 'Cash',
        'description': 'Konsumsi untuk staff selama 1 minggu',
      },
      // July 2024
      {
        'title': 'Tiket Masuk Wisata',
        'time': '15:20',
        'date': '31 July 2024',
        'amount': 750000.0,
        'icon': Icons.confirmation_number,
        'paymentMethod': 'Cash',
        'description': 'Penjualan tiket masuk wisata',
      },
      {
        'title': 'Pembelian Peralatan',
        'time': '11:30',
        'date': '30 July 2024',
        'amount': -300000.0,
        'icon': Icons.shopping_cart,
        'paymentMethod': 'Transfer Bank',
        'description': 'Pembelian peralatan maintenance',
      },
      {
        'title': 'Sewa Kendaraan',
        'time': '09:15',
        'date': '29 July 2024',
        'amount': -200000.0,
        'icon': Icons.directions_car,
        'paymentMethod': 'Cash',
        'description': 'Sewa kendaraan untuk keperluan operasional',
      },
      {
        'title': 'Penjualan Merchandise',
        'time': '14:45',
        'date': '28 July 2024',
        'amount': 100000.0,
        'icon': Icons.card_giftcard,
        'paymentMethod': 'QRIS',
        'description': 'Penjualan merchandise dan souvenir',
      },
    ];

    // Group transactions by month
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final transaction in allTransactions) {
      final date = transaction['date'] as String;
      final month = _extractMonth(date);

      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(transaction);
    }

    // Sort transactions within each month by date (newest first)
    grouped.forEach((month, transactions) {
      transactions.sort((a, b) {
        final dateA = a['date'] as String;
        final dateB = b['date'] as String;
        return dateB.compareTo(dateA);
      });
    });

    return grouped;
  }

  String _extractMonth(String dateString) {
    // Extract month and year from date string like "20 August 2024"
    final parts = dateString.split(' ');
    if (parts.length >= 3) {
      return '${parts[1]} ${parts[2]}';
    }
    return dateString;
  }

  Future<void> _refreshData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      // Refresh data here
    });
  }
}
