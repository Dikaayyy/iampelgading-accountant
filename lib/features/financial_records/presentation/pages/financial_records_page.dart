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
import 'package:iampelgading/core/widgets/date_range_picker.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/permission_dialog.dart';
import 'package:iampelgading/core/services/permission_service.dart';
import 'package:iampelgading/core/services/file_opener_service.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'dart:async'; // Add this import

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

  // Pagination controller
  final PagingController<int, Transaction> _pagingController = PagingController(
    firstPageKey: 1,
  );

  // Add these fields
  DateTime? _exportStartDate;
  DateTime? _exportEndDate;

  // Add debounce timer for search
  Timer? _searchDebounce;

  // Static page size
  static const int _pageSize = 10;

  // Add refresh state fields
  bool _isRefreshing = false;
  DateTime? _lastRefreshTime;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    // Setup pagination controller
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    // Load transactions when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<TransactionProvider>();
      provider.loadTransactions(); // For balance calculation
      // Tambahkan listener agar pagination auto refresh saat transaksi berubah
      provider.addListener(_onProviderChanged);
    });

    // Listen to navigation changes
    NavigationService().controller.addListener(_onNavigationChanged);

    // Listen to search changes with debounce
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Clean up properly
    final provider = context.read<TransactionProvider>();
    provider.removeListener(_onProviderChanged);

    // Hapus listener agar tidak memory leak
    context.read<TransactionProvider>().removeListener(_onProviderChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _pagingController.dispose();
    _searchDebounce?.cancel(); // Cancel debounce timer
    NavigationService().controller.removeListener(_onNavigationChanged);
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  void _onNavigationChanged() {
    final currentIndex = NavigationService().controller.index;
    final isFinancialRecordsPage = currentIndex == 2;

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

  void _onSearchChanged() {
    // Cancel previous timer
    _searchDebounce?.cancel();

    // Set new timer with longer delay to prevent excessive calls
    _searchDebounce = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        final currentSearchQuery = _searchController.text.trim();
        final providerSearchQuery =
            context.read<TransactionProvider>().searchQuery;

        // Only update if search query actually changed
        if (currentSearchQuery != providerSearchQuery) {
          // Update provider search query (this will trigger debounced refresh)
          context.read<TransactionProvider>().updateSearchQuery(
            currentSearchQuery,
          );

          // Reset pagination controller after a short delay
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _refreshPagination();
            }
          });
        }
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _searchFocusNode.unfocus();
    context.read<TransactionProvider>().updateSearchQuery('');
    _refreshPagination();
  }

  void _dismissKeyboard() {
    _searchFocusNode.unfocus();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final provider = context.read<TransactionProvider>();
      final searchQuery = _searchController.text.trim();

      if (searchQuery.isNotEmpty) {
        // For search: get all transactions and filter locally
        if (pageKey == 1) {
          final allTransactions = await provider.getTransactions?.call();

          if (allTransactions != null) {
            // Filter and sort transactions
            final filteredTransactions =
                allTransactions.where((transaction) {
                  return transaction.title.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      transaction.description.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      ) ||
                      transaction.category.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      );
                }).toList();

            // Sort by date (newest first)
            filteredTransactions.sort((a, b) => b.date.compareTo(a.date));

            _pagingController.appendLastPage(filteredTransactions);
          } else {
            _pagingController.appendLastPage([]);
          }
        } else {
          _pagingController.appendLastPage([]);
        }
      } else {
        // For normal pagination (no search)
        final response = await provider.getTransactionsPaginated?.call(
          page: pageKey,
          limit: _pageSize,
          search: null,
        );

        if (response != null) {
          final isLastPage = !response.hasNextPage;

          // Sort the response data by date (newest first)
          final sortedData = List<Transaction>.from(response.data);
          sortedData.sort((a, b) => b.date.compareTo(a.date));

          if (isLastPage) {
            _pagingController.appendLastPage(sortedData);
          } else {
            final nextPageKey = pageKey + 1;
            _pagingController.appendPage(sortedData, nextPageKey);
          }
        } else {
          _pagingController.appendLastPage([]);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _refreshPagination() {
    final now = DateTime.now();

    // Prevent too frequent refreshes
    if (_lastRefreshTime != null &&
        now.difference(_lastRefreshTime!).inMilliseconds < 500) {
      return;
    }

    if (_isRefreshing) {
      return;
    }

    _isRefreshing = true;
    _lastRefreshTime = now;

    // Small delay to prevent race conditions
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _pagingController.refresh();
        _isRefreshing = false;
      }
    });
  }

  // Update the provider changed listener to use debounced refresh
  void _onProviderChanged() {
    // Use debounced refresh instead of immediate refresh
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted && !_isRefreshing) {
        _refreshPagination();
      }
    });
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
          child: CustomScrollView(
            slivers: [
              // Header and Balance Card
              SliverToBoxAdapter(
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
                              // Let the listener handle the search logic
                            },
                            suffixIcon:
                                _searchController.text.isNotEmpty
                                    ? IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: _clearSearch,
                                    )
                                    : null,
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    TransactionHistoryHeader(
                      onDownloadPressed: _handleDownloadPressed,
                    ),
                  ],
                ),
              ),

              // Paginated Transaction List
              _buildPaginatedTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaginatedTransactionList() {
    return PagedSliverList<int, Transaction>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Transaction>(
        itemBuilder: (context, transaction, index) {
          return _buildTransactionItem(transaction, index);
        },
        firstPageErrorIndicatorBuilder: (context) => _buildErrorIndicator(),
        newPageErrorIndicatorBuilder:
            (context) => _buildNewPageErrorIndicator(),
        firstPageProgressIndicatorBuilder:
            (context) => _buildLoadingIndicator(),
        newPageProgressIndicatorBuilder:
            (context) => _buildNewPageLoadingIndicator(),
        noItemsFoundIndicatorBuilder: (context) => _buildEmptyIndicator(),
        noMoreItemsIndicatorBuilder: (context) => _buildNoMoreItemsIndicator(),
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction, int index) {
    // Group by month logic
    bool shouldShowMonthHeader = false;
    String monthName = '';

    if (index == 0) {
      shouldShowMonthHeader = true;
      monthName = DateFormat('MMMM yyyy', 'id_ID').format(transaction.date);
    } else {
      // Check if this transaction is from a different month than the previous one
      final currentItems = _pagingController.itemList ?? [];
      if (index > 0 && index <= currentItems.length - 1) {
        final prevTransaction = currentItems[index - 1];
        final currentMonth = DateFormat(
          'MMMM yyyy',
          'id_ID',
        ).format(transaction.date);
        final prevMonth = DateFormat(
          'MMMM yyyy',
          'id_ID',
        ).format(prevTransaction.date);

        if (currentMonth != prevMonth) {
          shouldShowMonthHeader = true;
          monthName = currentMonth;
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Header
        if (shouldShowMonthHeader)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Text(
              monthName,
              style: AppTextStyles.h4.copyWith(
                color: const Color(0xFF202D41),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

        // Transaction Item
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              UnifiedTransactionItem(
                title: transaction.title,
                time: DateFormat('HH:mm').format(transaction.date),
                date:
                    '${transaction.date.day} ${_getMonthName(transaction.date.month)} ${transaction.date.year}',
                amount: transaction.amount,
                icon:
                    context.read<TransactionProvider>().transactionToMap(
                          transaction,
                        )['icon']
                        as IconData,
                transactionData: context
                    .read<TransactionProvider>()
                    .transactionToMap(transaction),
                onEdit:
                    () => _handleEditTransaction(
                      context.read<TransactionProvider>().transactionToMap(
                        transaction,
                      ),
                    ),
                onDelete:
                    () => _handleDeleteTransaction(
                      context.read<TransactionProvider>().transactionToMap(
                        transaction,
                      ),
                    ),
              ),

              // Separator (except for last item in the list)
              if (index < (_pagingController.itemList?.length ?? 0) - 1)
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
          ),
        ),

        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNewPageLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildErrorIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text(
              'Terjadi kesalahan saat memuat data',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshPagination,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewPageErrorIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Gagal memuat data selanjutnya',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _refreshPagination,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyIndicator() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'Tidak ada transaksi yang ditemukan'
                  : 'Belum ada transaksi',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_searchController.text.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                'Coba kata kunci lain',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNoMoreItemsIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Tidak ada data lagi',
          style: TextStyle(color: Colors.grey),
        ),
      ),
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

      // Refresh pagination after delete
      _refreshPagination();

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder:
          (context) => CustomBottomSheet(
            title: 'Ekspor Data Transaksi',
            items: [
              BottomSheetItem(
                title: 'Ekspor ke CSV',
                subtitle: 'Unduh data transaksi dalam format CSV',
                icon: Icons.table_chart_outlined,
                iconColor: const Color(0xFF40B029),
                iconBackgroundColor: const Color(0xFF40B029).withOpacity(0.1),
                onTap: () {
                  // Tutup CustomBottomSheet sebelum buka date range
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(milliseconds: 200), () {
                    _checkPermissionAndShowDateRange();
                  });
                },
              ),
            ],
            onClose: () => Navigator.of(context).pop(),
          ),
    );
  }

  Future<void> _checkPermissionAndShowDateRange() async {
    try {
      final hasPermission = await PermissionService.checkStoragePermission();

      if (hasPermission) {
        _showDateRangeBottomSheet();
      } else {
        if (mounted) {
          await PermissionDialog.showStoragePermissionDialog(
            context,
            onGranted: () {
              if (mounted) {
                _showDateRangeBottomSheet();
              }
            },
            onDenied: () {
              if (mounted) {
                SnackbarHelper.showWarning(
                  context: context,
                  title: 'Izin Diperlukan',
                  message:
                      'Izin akses storage diperlukan untuk mengekspor file CSV',
                  showAtTop: true,
                );
              }
            },
          );
        }
      }
    } catch (e) {
      if (mounted) {
        SnackbarHelper.showError(
          context: context,
          title: 'Error',
          message: 'Terjadi kesalahan saat memeriksa izin',
          showAtTop: true,
        );
      }
    }
  }

  void _showDateRangeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (context) => _buildDateRangeBottomSheet(),
    );
  }

  Widget _buildDateRangeBottomSheet() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: AppColors.neutral[50],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Text(
              'Pilih Periode Transaksi',
              style: AppTextStyles.h3.copyWith(
                color: const Color(0xFF202D41),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Divider
          Container(height: 1, color: AppColors.neutral[50]?.withOpacity(0.3)),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Date Range Picker
                  DateRangePicker(
                    initialStartDate:
                        _exportStartDate ??
                        DateTime.now().subtract(const Duration(days: 30)),
                    initialEndDate: _exportEndDate ?? DateTime.now(),
                    onDateRangeSelected: (startDate, endDate) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _exportStartDate = startDate;
                            _exportEndDate = endDate;
                          });
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Consumer<TransactionProvider>(
                          builder: (context, provider, child) {
                            return PrimaryButton(
                              text: 'Ekspor CSV',
                              isLoading: provider.isExporting,
                              onPressed:
                                  provider.isExporting
                                      ? null
                                      : () => _exportToCsv(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportToCsv() async {
    if (_exportStartDate == null || _exportEndDate == null) {
      SnackbarHelper.showWarning(
        context: context,
        title: 'Periode Tidak Valid',
        message: 'Silakan pilih tanggal mulai dan akhir',
        showAtTop: true,
      );
      return;
    }

    if (_exportStartDate!.isAfter(_exportEndDate!)) {
      SnackbarHelper.showWarning(
        context: context,
        title: 'Periode Tidak Valid',
        message: 'Tanggal mulai tidak boleh lebih dari tanggal akhir',
        showAtTop: true,
      );
      return;
    }

    try {
      // Tutup modal date range sebelum ekspor dengan rootNavigator: true
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      final filePath = await context
          .read<TransactionProvider>()
          .exportTransactionsToCsv(
            startDate: _exportStartDate!,
            endDate: _exportEndDate!,
          );

      if (mounted) {
        // Create action buttons
        Widget actionButtons = Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Open File button
            SizedBox(
              height: 32,
              child: TextButton.icon(
                onPressed: () async {
                  try {
                    final canOpen = await FileOpenerService.canOpenFile(
                      filePath,
                    );
                    if (!canOpen) {
                      if (mounted) {
                        SnackbarHelper.showWarning(
                          context: context,
                          title: 'File Tidak Dapat Dibuka',
                          message:
                              'Format file tidak didukung atau file tidak ditemukan',
                          showAtTop: true,
                        );
                      }
                      return;
                    }

                    final success = await FileOpenerService.openFile(filePath);
                    if (!success && mounted) {
                      SnackbarHelper.showWarning(
                        context: context,
                        title: 'Tidak Bisa Buka File',
                        message:
                            'Tidak ada aplikasi yang bisa membuka file CSV. File tersimpan di: $filePath',
                        showAtTop: true,
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      SnackbarHelper.showError(
                        context: context,
                        title: 'Error',
                        message: 'Gagal membuka file: ${e.toString()}',
                        showAtTop: true,
                      );
                    }
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 16),
                label: const Text('Buka File', style: TextStyle(fontSize: 12)),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.success[500],
                  backgroundColor: AppColors.success[100]?.withOpacity(0.5),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ),
          ],
        );

        SnackbarHelper.showSuccess(
          context: context,
          title: 'Ekspor Berhasil',
          message: 'Data berhasil diekspor ke: $filePath',
          showAtTop: true,
          actionButton: actionButtons,
        );
      }
    } catch (e) {
      // Pastikan modal tertutup juga saat error dengan rootNavigator: true
      if (mounted && Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }

      if (mounted) {
        String errorMessage = e.toString();
        if (errorMessage.contains('Exception: ')) {
          errorMessage = errorMessage.replaceFirst('Exception: ', '');
        }

        // Handle permission denied specifically
        if (errorMessage.contains('Permission denied') ||
            errorMessage.contains('izin akses storage')) {
          await PermissionDialog.showPermissionDeniedDialog(
            context,
            onOpenSettings: () {
              // Optional: Show success message after user returns from settings
            },
          );
        } else {
          SnackbarHelper.showError(
            context: context,
            title: 'Ekspor Gagal',
            message: errorMessage,
            showAtTop: true,
          );
        }
      }
    }
  }

  Future<void> _refreshData() async {
    // Refresh both balance data and paginated list
    final provider = context.read<TransactionProvider>();
    await Future.wait([
      provider.loadTransactions(),
      provider.loadPaginatedTransactions(refresh: true),
    ]);
    _refreshPagination();
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
