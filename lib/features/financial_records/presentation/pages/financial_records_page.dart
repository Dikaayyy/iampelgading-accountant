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
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/features/transaction/presentation/pages/edit_transaction_page.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';

class FinancialRecordsPage extends StatefulWidget {
  const FinancialRecordsPage({super.key});

  @override
  State<FinancialRecordsPage> createState() => _FinancialRecordsPageState();
}

class _FinancialRecordsPageState extends State<FinancialRecordsPage>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isBalanceVisible = true;
  bool _isCurrentPage = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Load transactions when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TransactionProvider>().loadTransactions();
    });

    // Listen to navigation changes
    NavigationService().controller.addListener(_onNavigationChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    NavigationService().controller.removeListener(_onNavigationChanged);
    super.dispose();
  }

  void _onNavigationChanged() {
    final currentIndex = NavigationService().controller.index;
    final isFinancialRecordsPage =
        currentIndex == 2; // Financial records is now at index 2

    if (_isCurrentPage != isFinancialRecordsPage) {
      setState(() {
        _isCurrentPage = isFinancialRecordsPage;
      });

      // Clear search when leaving this page
      if (!isFinancialRecordsPage) {
        _clearSearch();
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<TransactionProvider>().updateSearchQuery('');
  }

  void _dismissKeyboard() {
    _searchFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.background[200],
      body: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.opaque,
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildHeaderWithBalanceCard(screenWidth),

                const SizedBox(height: 24),

                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Consumer<TransactionProvider>(
                    builder: (context, provider, child) {
                      return CustomSearchField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        hintText: 'Cari transaksi...',
                        onChanged: (value) {
                          provider.updateSearchQuery(value);
                        },
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                TransactionHistoryHeader(
                  onDownloadPressed: _handleDownloadPressed,
                ),

                _buildTransactionsByMonth(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsByMonth() {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingTransactions) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Use filtered transactions for display
        final groupedTransactions =
            provider.getFilteredTransactionsGroupedByMonth();

        if (groupedTransactions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                _searchController.text.isNotEmpty
                    ? 'Tidak ada transaksi yang ditemukan'
                    : 'Belum ada transaksi',
              ),
            ),
          );
        }

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
                        style: AppTextStyles.h4.copyWith(
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
                              title: transactions[i].title,
                              time: DateFormat(
                                'HH:mm',
                              ).format(transactions[i].date),
                              date:
                                  '${transactions[i].date.day} ${_getMonthName(transactions[i].date.month)} ${transactions[i].date.year}',
                              amount: transactions[i].amount,
                              icon:
                                  transactions[i].isIncome
                                      ? Icons.arrow_downward
                                      : Icons.arrow_upward,
                              transactionData: provider.transactionToMap(
                                transactions[i],
                              ),
                              onEdit:
                                  () => _handleEditTransaction(
                                    provider.transactionToMap(transactions[i]),
                                  ),
                              onDelete:
                                  () => _handleDeleteTransaction(
                                    provider.transactionToMap(transactions[i]),
                                  ),
                            ),
                            if (i < transactions.length - 1)
                              Opacity(
                                opacity: 0.10,
                                child: Container(
                                  width: double.infinity,
                                  height: 1,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
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
      },
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[month - 1];
  }

  void _handleEditTransaction(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] as double? ?? 0.0;
    final isIncome = amount > 0;

    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: EditTransactionPage(transaction: transaction, isIncome: isIncome),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }

  void _handleDeleteTransaction(Map<String, dynamic> transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
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

  void _confirmDeleteTransaction(Map<String, dynamic> transaction) async {
    final transactionId = transaction['id']?.toString();

    if (transactionId == null) {
      SnackbarHelper.showError(
        context: context,
        title: 'Gagal Menghapus',
        message: 'ID transaksi tidak valid',
        showAtTop: true,
      );
      return;
    }

    try {
      // Call the delete transaction method from provider
      await context.read<TransactionProvider>().deleteTransaction(
        transactionId,
      );

      SnackbarHelper.showSuccess(
        context: context,
        title: 'Transaksi Dihapus',
        message: 'Transaksi "${transaction['title']}" berhasil dihapus',
        showAtTop: true,
      );
    } catch (e) {
      SnackbarHelper.showError(
        context: context,
        title: 'Gagal Menghapus',
        message: 'Terjadi kesalahan saat menghapus transaksi',
        showAtTop: true,
      );
    }
  }

  void _handleDownloadPressed() {
    CustomBottomSheet.show(
      context: context,
      title: 'Ekspor Data Transaksi',
      items: [
        BottomSheetItem(
          title: 'Ekspor ke PDF',
          subtitle: 'Unduh data transaksi dalam format PDF',
          icon: Icons.picture_as_pdf,
          iconColor: const Color(0xFFFF4545),
          iconBackgroundColor: const Color(0xFFFF4545).withOpacity(0.1),
          onTap: () {
            Navigator.of(context).pop();
            _exportToPdf();
          },
        ),
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

  void _exportToPdf() {
    // TODO: Implement PDF export
    SnackbarHelper.showSuccess(
      context: context,
      title: 'Ekspor Berhasil',
      message: 'Data transaksi berhasil diekspor ke PDF',
      showAtTop: true,
    );
  }

  void _exportToCsv() {
    // TODO: Implement CSV export
    SnackbarHelper.showSuccess(
      context: context,
      title: 'Ekspor Berhasil',
      message: 'Data transaksi berhasil diekspor ke CSV',
      showAtTop: true,
    );
  }

  Future<void> _refreshData() async {
    await context.read<TransactionProvider>().refreshTransactions();
  }

  Widget _buildHeaderWithBalanceCard(double screenWidth) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          FinancialHeader(screenWidth: screenWidth, showGreeting: false),

          Positioned(
            left: 24,
            top: 100,
            right: 24,
            child: Consumer<TransactionProvider>(
              builder: (context, provider, child) {
                // Always use ALL transactions for balance calculation
                return BalanceCard(
                  balance: provider.netIncome,
                  income: provider.totalIncome,
                  expense: provider.totalExpense,
                  isVisible: _isBalanceVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isBalanceVisible = !_isBalanceVisible;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
