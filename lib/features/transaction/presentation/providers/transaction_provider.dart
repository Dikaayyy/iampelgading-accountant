import 'package:flutter/material.dart';
import 'package:iampelgading/features/transaction/domain/usecases/get_transactions_paginaed_usecase.dart';
import 'package:iampelgading/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/features/transaction/domain/usecases/add_transaction.dart';
import 'package:iampelgading/features/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:iampelgading/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;
import 'package:iampelgading/features/transaction/domain/usecases/export_transactions_usecase.dart';
import 'package:iampelgading/core/services/csv_export_service.dart';
import 'package:iampelgading/features/transaction/data/datasources/transaction_remote_datasource.dart';

class TransactionProvider with ChangeNotifier {
  final AddTransaction? _addTransaction;
  final GetTransactions? _getTransactions;
  final GetTransactionsPaginated? _getTransactionsPaginated;
  final UpdateTransaction? _updateTransaction;
  final DeleteTransaction? _deleteTransaction;
  final ExportTransactions? _exportTransactions;

  // Controllers
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();

  // Date and Time
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Other properties
  bool _isLoading = false;
  String? _selectedPaymentMethod;
  double _totalAmount = 0.0;

  // Transactions list
  List<Transaction> _transactions = [];
  bool _isLoadingTransactions = false;
  String? _errorMessage;

  // Filtered transactions for display purposes
  List<Transaction> _filteredTransactions = [];
  String _searchQuery = '';
  String? _selectedFilter;

  // Pagination properties
  List<Transaction> _paginatedTransactions = [];
  bool _isLoadingMoreTransactions = false;
  bool _hasMoreTransactions = true;
  int _currentPage = 1;
  static const int _pageSize = 10;

  // Getters
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isLoading => _isLoading;
  bool get isLoadingTransactions => _isLoadingTransactions;
  bool get isLoadingMoreTransactions => _isLoadingMoreTransactions;
  bool get hasMoreTransactions => _hasMoreTransactions;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  double get totalAmount => _totalAmount;
  List<Transaction> get transactions =>
      _transactions; // Always all data for balance calculation
  List<Transaction> get paginatedTransactions =>
      _paginatedTransactions; // For paginated display
  List<Transaction> get filteredTransactions =>
      _filteredTransactions; // For search display
  String get searchQuery => _searchQuery;
  String? get selectedFilter => _selectedFilter;
  String? get errorMessage => _errorMessage;

  // Add the missing getters
  GetTransactions? get getTransactions => _getTransactions;
  GetTransactionsPaginated? get getTransactionsPaginated =>
      _getTransactionsPaginated;

  // Lists
  List<String> get paymentMethods => [
    'Cash',
    'Transfer Bank',
    'E-Wallet',
    'QRIS',
    'Kartu Kredit',
    'Kartu Debit',
  ];

  List<String> get incomeCategories => [
    'Pendapatan Tiket Wisata',
    'Pendapatan Parkir',
    'Pendapatan Camping',
    'Pendapatan Lain-lain',
  ];

  List<String> get expenseCategories => [
    'Beban Gaji/Honor',
    'Beban Kebersihan',
    'Beban Perlengkapan/ATK',
    'Beban Listrik dan Air',
    'Beban Lain-lain',
  ];

  TransactionProvider([
    this._addTransaction,
    this._getTransactions,
    this._getTransactionsPaginated,
    this._updateTransaction,
    this._deleteTransaction,
    this._exportTransactions,
  ]) {
    _initializeDefaultValues();
    quantityController.text = '0';
    loadTransactions();
  }

  // Load all transactions for balance calculation and export
  Future<void> loadTransactions() async {
    if (_getTransactions == null) return;

    _isLoadingTransactions = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _getTransactions.call();
      _isLoadingTransactions = false;
      notifyListeners();
    } catch (e) {
      _isLoadingTransactions = false;
      _errorMessage = e.toString();

      if (e.toString().contains('Unauthorized')) {
        await _handleUnauthorized();
      }

      notifyListeners();
      throw Exception('Failed to load transactions: $e');
    }
  }

  // Load paginated transactions for display
  Future<void> loadPaginatedTransactions({bool refresh = false}) async {
    if (_getTransactionsPaginated == null) return;

    if (refresh) {
      _currentPage = 1;
      _paginatedTransactions.clear();
      _hasMoreTransactions = true;
    }

    if (!_hasMoreTransactions || _isLoadingMoreTransactions) return;

    _isLoadingMoreTransactions = true;
    notifyListeners();

    try {
      final response = await _getTransactionsPaginated!(
        page: _currentPage,
        limit: _pageSize,
        search: _searchQuery, // Pastikan query digunakan
      );

      if (refresh) {
        _paginatedTransactions = response.data;
      } else {
        _paginatedTransactions.addAll(response.data);
      }

      _hasMoreTransactions = response.hasNextPage;
      _currentPage++;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoadingMoreTransactions = false;
      notifyListeners();
    }
  }

  // Handle unauthorized access
  Future<void> _handleUnauthorized() async {
    try {
      final authService = di.sl<AuthService>();
      await authService.logout();
      // Navigate to login page would be handled by the UI
    } catch (e) {
      // Handle logout error
    }
  }

  // Refresh transactions
  Future<void> refreshTransactions() async {
    await Future.wait([
      loadTransactions(),
      loadPaginatedTransactions(refresh: true),
    ]);
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Search functionality
  void updateSearchQuery(String query) {
    _searchQuery = query;
    loadPaginatedTransactions(refresh: true);
    notifyListeners();
  }

  // Filter functionality
  void updateFilter(String? filter) {
    _selectedFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  // Clear search and filters
  void clearSearchAndFilters() {
    _searchQuery = '';
    _selectedFilter = null;
    loadPaginatedTransactions(refresh: true);
    notifyListeners();
  }

  // Balance calculations always use ALL transactions
  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  double get totalExpense {
    return _transactions
        .where((transaction) => !transaction.isIncome)
        .fold(0.0, (sum, transaction) => sum + transaction.amount.abs());
  }

  double get netIncome => totalIncome - totalExpense;

  // Apply search and filters to transactions
  void _applyFilters() {
    _applyFiltersToTransactions(_paginatedTransactions);
  }

  void _applyFiltersToTransactions(List<Transaction> sourceTransactions) {
    _filteredTransactions =
        sourceTransactions.where((transaction) {
          // Apply search filter
          bool matchesSearch = true;
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            matchesSearch =
                transaction.title.toLowerCase().contains(query) ||
                transaction.category.toLowerCase().contains(query) ||
                transaction.description.toLowerCase().contains(query);
          }

          // Apply type filter
          bool matchesFilter = true;
          if (_selectedFilter != null) {
            switch (_selectedFilter) {
              case 'income':
                matchesFilter = transaction.isIncome;
                break;
              case 'expense':
                matchesFilter = !transaction.isIncome;
                break;
              case 'this_month':
                final now = DateTime.now();
                matchesFilter =
                    transaction.date.year == now.year &&
                    transaction.date.month == now.month;
                break;
              // Add more filters as needed
            }
          }

          return matchesSearch && matchesFilter;
        }).toList();

    // Sort filtered transactions by date (newest first)
    _filteredTransactions.sort((a, b) => b.date.compareTo(a.date));
  }

  // Get filtered transactions grouped by month for UI
  Map<String, List<Transaction>> getFilteredTransactionsGroupedByMonth() {
    final Map<String, List<Transaction>> grouped = {};

    // Use filtered transactions if there's a search query, otherwise use paginated transactions
    final transactionsToGroup =
        _searchQuery.isNotEmpty
            ? _filteredTransactions
            : _paginatedTransactions;

    for (final transaction in transactionsToGroup) {
      final monthKey = DateFormat(
        'MMMM yyyy',
        'id_ID',
      ).format(transaction.date);

      if (!grouped.containsKey(monthKey)) {
        grouped[monthKey] = [];
      }
      grouped[monthKey]!.add(transaction);
    }

    // Sort transactions within each month by date (newest first)
    grouped.forEach((month, transactions) {
      transactions.sort((a, b) => b.date.compareTo(a.date));
    });

    return grouped;
  }

  // Convert Transaction to Map for UI compatibility
  Map<String, dynamic> transactionToMap(Transaction transaction) {
    return {
      'id': transaction.id,
      'title': transaction.title,
      'amount': transaction.amount,
      'category': transaction.category,
      'description': transaction.description,
      'paymentMethod': transaction.paymentMethod,
      'quantity': transaction.quantity,
      'pricePerItem': transaction.pricePerItem,
      'date': DateFormat('d MMMM yyyy', 'id_ID').format(transaction.date),
      'time': DateFormat('HH:mm').format(transaction.date),
      'icon': transaction.isIncome ? Icons.trending_up : Icons.trending_down,
    };
  }

  void _initializeDefaultValues() {
    try {
      _selectedDate = DateTime.now();

      try {
        dateController.text = DateFormat(
          'dd MMMM yyyy',
          'id_ID',
        ).format(_selectedDate);
      } catch (e) {
        dateController.text = DateFormat(
          'dd MMMM yyyy',
          'en_US',
        ).format(_selectedDate);
      }

      _selectedTime = TimeOfDay.now();
      // Format time as HH:MM for display
      timeController.text =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // Fallback initialization
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      dateController.text = DateFormat('dd MMMM yyyy').format(_selectedDate);
      timeController.text =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    }
  }

  void updateDate(DateTime date) {
    _selectedDate = date;
    try {
      dateController.text = DateFormat('dd MMMM yyyy', 'id_ID').format(date);
    } catch (e) {
      dateController.text = DateFormat('dd MMMM yyyy', 'en_US').format(date);
    }
    notifyListeners();
  }

  void updateTime(TimeOfDay time, BuildContext context) {
    _selectedTime = time;
    // Always format as HH:MM regardless of locale
    timeController.text =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    notifyListeners();
  }

  void updatePaymentMethod(String method) {
    _selectedPaymentMethod = method;
    notifyListeners();
  }

  void updateQuantityOrPrice() {
    final quantity = double.tryParse(quantityController.text) ?? 0.0;
    final price = double.tryParse(priceController.text) ?? 0.0;
    _totalAmount = quantity * price;
    notifyListeners();
  }

  // Validation methods
  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kuantitas harus diisi';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Kuantitas harus berupa angka positif';
    }
    return null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga harus diisi';
    }
    if (double.tryParse(value) == null || double.parse(value) <= 0) {
      return 'Harga harus berupa angka positif';
    }
    return null;
  }

  String? validateCategory(String? value) {
    if (value == null || value.isEmpty) {
      return 'Kategori harus dipilih';
    }
    return null;
  }

  // Update resetForm method
  void resetForm() {
    quantityController.text = '1'; // Default to 1 instead of 0
    priceController.clear();
    descriptionController.clear();
    categoryController.clear();
    _selectedPaymentMethod = null;
    _totalAmount = 0.0;
    _initializeDefaultValues();
    notifyListeners();
  }

  // Fix saveTransaction method
  Future<void> saveTransaction({required bool isIncome}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_addTransaction != null) {
        // Combine date and time properly
        final DateTime combinedDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        // Create transaction entity
        final transaction = Transaction(
          title: categoryController.text,
          amount: isIncome ? _totalAmount : -_totalAmount,
          category: categoryController.text,
          date: combinedDateTime,
          paymentMethod: _selectedPaymentMethod ?? 'Cash',
          description: descriptionController.text,
          isIncome: isIncome,
          quantity: int.tryParse(quantityController.text) ?? 1,
          pricePerItem: double.tryParse(priceController.text) ?? 0.0,
        );

        // Debug: Print what we're sending

        // Call API to create transaction
        final createdTransaction = await _addTransaction.call(transaction);

        // Add the created transaction to local list
        _transactions.add(createdTransaction);

        // Refresh both transaction lists
        await Future.wait([
          loadTransactions(),
          loadPaginatedTransactions(refresh: true),
        ]);

        // Clear form after successful save
        resetForm();
      } else {
        await Future.delayed(const Duration(seconds: 2));
        resetForm();
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();

      // If unauthorized, handle logout
      if (e.toString().contains('Unauthorized')) {
        await _handleUnauthorized();
      }

      notifyListeners();
      rethrow;
    }
  }

  // Fix updateTransaction method
  Future<void> updateTransaction({
    required bool isIncome,
    required String transactionId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_updateTransaction != null) {
        // Combine date and time properly
        final DateTime combinedDateTime = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );

        // Create transaction entity
        final transaction = Transaction(
          id: transactionId,
          title: categoryController.text,
          amount: isIncome ? _totalAmount : -_totalAmount,
          category: categoryController.text,
          date: combinedDateTime,
          paymentMethod: _selectedPaymentMethod ?? 'Cash',
          description: descriptionController.text,
          isIncome: isIncome,
          quantity: int.tryParse(quantityController.text) ?? 1,
          pricePerItem: double.tryParse(priceController.text) ?? 0.0,
        );

        // Debug: Print what we're sending

        // Call API to update transaction
        final updatedTransaction = await _updateTransaction.call(transaction);

        // Update local list
        final index = _transactions.indexWhere((t) => t.id == transactionId);
        if (index != -1) {
          _transactions[index] = updatedTransaction;
        }

        // Refresh both transaction lists
        await Future.wait([
          loadTransactions(),
          loadPaginatedTransactions(refresh: true),
        ]);
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();

      // If unauthorized, handle logout
      if (e.toString().contains('Unauthorized')) {
        await _handleUnauthorized();
      }

      notifyListeners();
      throw Exception('Failed to update transaction: $e');
    }
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    if (_deleteTransaction == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call API to delete transaction
      await _deleteTransaction.call(transactionId);

      // Remove transaction from local list
      _transactions.removeWhere(
        (transaction) => transaction.id == transactionId,
      );
      _paginatedTransactions.removeWhere(
        (transaction) => transaction.id == transactionId,
      );

      // Refresh both transaction lists
      await Future.wait([
        loadTransactions(),
        loadPaginatedTransactions(refresh: true),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();

      // If unauthorized, handle logout
      if (e.toString().contains('Unauthorized')) {
        await _handleUnauthorized();
      }

      notifyListeners();
      throw Exception('Failed to delete transaction: $e');
    }
  }

  // Fix updateQuantityFromText method
  void updateQuantityFromText(String value) {
    if (value.isEmpty) {
      quantityController.text = '0';
    } else {
      final numValue = double.tryParse(value);
      if (numValue == null || numValue < 0) {
        quantityController.text = '0';
      } else {
        // Remove .0 if it's a whole number
        if (numValue == numValue.roundToDouble()) {
          quantityController.text = numValue.toInt().toString();
        } else {
          quantityController.text = numValue.toString();
        }
      }
    }
    updateQuantityOrPrice();
  }

  // Fix incrementQuantity method
  void incrementQuantity() {
    final currentValue = double.tryParse(quantityController.text) ?? 0.0;
    final newValue = currentValue + 1;
    quantityController.text =
        newValue.toInt().toString(); // Always show as integer
    updateQuantityOrPrice();
  }

  // Fix decrementQuantity method
  void decrementQuantity() {
    final currentValue = double.tryParse(quantityController.text) ?? 0.0;
    if (currentValue > 0) {
      final newValue = currentValue - 1;
      quantityController.text =
          newValue.toInt().toString(); // Always show as integer
      updateQuantityOrPrice();
    }
  }

  // Fix populateFromTransaction method to properly handle date/time parsing
  void populateFromTransaction(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] as double? ?? 0.0;
    final absoluteAmount = amount.abs();
    final isIncome = amount > 0;

    // Set the controllers with transaction data
    priceController.text = absoluteAmount.toString();
    descriptionController.text = transaction['description'] as String? ?? '';

    final paymentMethod = transaction['paymentMethod'] as String? ?? 'Cash';
    if (paymentMethods.contains(paymentMethod)) {
      updatePaymentMethod(paymentMethod);
    }

    // Fix category selection - use the actual category from transaction
    final transactionCategory = transaction['category'] as String? ?? '';
    final availableCategories = isIncome ? incomeCategories : expenseCategories;

    // Set category based on what's available in the dropdown
    if (transactionCategory.isNotEmpty &&
        availableCategories.contains(transactionCategory)) {
      categoryController.text = transactionCategory;
    } else {
      categoryController.text =
          availableCategories.isNotEmpty ? availableCategories.first : '';
    }

    // Parse and set date from the transaction date string
    try {
      final dateStr = transaction['date'] as String? ?? '';
      if (dateStr.isNotEmpty) {
        // Try to parse date in format "dd MMMM yyyy"
        try {
          final parsedDate = DateFormat('dd MMMM yyyy', 'id_ID').parse(dateStr);
          _selectedDate = parsedDate;
          dateController.text = dateStr;
        } catch (e) {
          _selectedDate = DateTime.now();
          dateController.text = DateFormat(
            'dd MMMM yyyy',
            'id_ID',
          ).format(_selectedDate);
        }
      } else {
        _selectedDate = DateTime.now();
        dateController.text = DateFormat(
          'dd MMMM yyyy',
          'id_ID',
        ).format(_selectedDate);
      }
    } catch (e) {
      _selectedDate = DateTime.now();
      dateController.text = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(_selectedDate);
    }

    // Parse and set time from the transaction time string - USE DATABASE TIME
    try {
      final timeStr = transaction['time'] as String? ?? '';

      if (timeStr.isNotEmpty && timeStr != '00:00' && timeStr != 'null') {
        // Parse time in format "HH:mm" or "HH:mm:ss"
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;
          _selectedTime = TimeOfDay(hour: hour, minute: minute);
          timeController.text =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        } else {
          _selectedTime = const TimeOfDay(hour: 0, minute: 0);
          timeController.text = '00:00';
        }
      } else {
        // If time is empty or null, use 00:00
        _selectedTime = const TimeOfDay(hour: 0, minute: 0);
        timeController.text = '00:00';
      }
    } catch (e) {
      _selectedTime = const TimeOfDay(hour: 0, minute: 0);
      timeController.text = '00:00';
    }

    // Set quantity and price
    final quantity = transaction['quantity'] as int? ?? 1;
    final pricePerItem =
        transaction['pricePerItem'] as double? ?? absoluteAmount;

    quantityController.text = quantity.toString();
    // Fix: Remove .0 from price display
    if (pricePerItem == pricePerItem.roundToDouble()) {
      priceController.text = pricePerItem.toInt().toString();
    } else {
      priceController.text = pricePerItem.toString();
    }

    updateQuantityOrPrice();
    notifyListeners();
  }

  bool _isExporting = false;
  bool get isExporting => _isExporting;

  Future<String> exportTransactionsToCsv({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    _isExporting = true;
    notifyListeners();

    try {
      // Filter transactions by date range - use ALL transactions for export
      final filteredTransactions =
          _transactions.where((transaction) {
            final transactionDate = DateTime(
              transaction.date.year,
              transaction.date.month,
              transaction.date.day,
            );
            final start = DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            );
            final end = DateTime(endDate.year, endDate.month, endDate.day);

            return transactionDate.isAfter(
                  start.subtract(const Duration(days: 1)),
                ) &&
                transactionDate.isBefore(end.add(const Duration(days: 1)));
          }).toList();

      if (filteredTransactions.isEmpty) {
        throw Exception('Tidak ada transaksi dalam periode yang dipilih');
      }

      final filePath = await CsvExportService.exportTransactionsToCsv(
        transactions: filteredTransactions,
        startDate: startDate,
        endDate: endDate,
      );

      return filePath;
    } finally {
      _isExporting = false;
      notifyListeners();
    }
  }
}

// Global navigator key for context access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
