import 'package:flutter/material.dart';
import 'package:iampelgading/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/features/transaction/domain/usecases/add_transaction.dart';
import 'package:iampelgading/features/transaction/domain/usecases/update_transaction_usecase.dart';
import 'package:iampelgading/features/transaction/domain/usecases/delete_transaction_usecase.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;

class TransactionProvider with ChangeNotifier {
  final AddTransaction? _addTransaction;
  final GetTransactions? _getTransactions;
  final UpdateTransaction? _updateTransaction;
  final DeleteTransaction? _deleteTransaction;

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

  // Getters
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isLoading => _isLoading;
  bool get isLoadingTransactions => _isLoadingTransactions;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  double get totalAmount => _totalAmount;
  List<Transaction> get transactions => _transactions;
  String? get errorMessage => _errorMessage;

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
    this._updateTransaction,
    this._deleteTransaction,
  ]) {
    _initializeDefaultValues();
    quantityController.text = '0';
    // Load transactions when provider is initialized
    loadTransactions();
  }

  // Load transactions from API
  Future<void> loadTransactions() async {
    if (_getTransactions == null) return;

    _isLoadingTransactions = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _transactions = await _getTransactions!.call();
      _isLoadingTransactions = false;
      notifyListeners();
    } catch (e) {
      _isLoadingTransactions = false;
      _errorMessage = e.toString();

      // If unauthorized, handle logout
      if (e.toString().contains('Unauthorized')) {
        await _handleUnauthorized();
      }

      notifyListeners();
      throw Exception('Failed to load transactions: $e');
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
    await loadTransactions();
  }

  // Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Get transactions grouped by month for UI
  Map<String, List<Transaction>> getTransactionsGroupedByMonth() {
    final Map<String, List<Transaction>> grouped = {};

    for (final transaction in _transactions) {
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
      'time': DateFormat(
        'HH:mm',
      ).format(transaction.date), // Use actual transaction time
      'icon': transaction.isIncome ? Icons.trending_up : Icons.trending_down,
    };
  }

  // Add this helper method
  String _formatTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  // Add this helper method
  String _formatNumber(double number) {
    if (number == number.roundToDouble()) {
      return number.toInt().toString();
    } else {
      return number.toString();
    }
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
        print('Sending transaction with date: ${combinedDateTime.toString()}');
        print('Selected date: $_selectedDate');
        print('Selected time: $_selectedTime');

        // Call API to create transaction
        final createdTransaction = await _addTransaction!.call(transaction);

        // Add the created transaction to local list
        _transactions.add(createdTransaction);

        // Refresh transactions from server
        await loadTransactions();

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
        print('Updating transaction with date: ${combinedDateTime.toString()}');

        // Call API to update transaction
        final updatedTransaction = await _updateTransaction!.call(transaction);

        // Update local list
        final index = _transactions.indexWhere((t) => t.id == transactionId);
        if (index != -1) {
          _transactions[index] = updatedTransaction;
        }

        // Refresh transactions from server
        await loadTransactions();
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
      await _deleteTransaction!.call(transactionId);

      // Remove transaction from local list
      _transactions.removeWhere(
        (transaction) => transaction.id == transactionId,
      );

      // Refresh transactions from server to ensure we have the latest data
      await loadTransactions();

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
          // If parsing fails, use current date
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
      print('Parsing time from transaction: "$timeStr"');

      if (timeStr.isNotEmpty && timeStr != '00:00' && timeStr != 'null') {
        // Parse time in format "HH:mm" or "HH:mm:ss"
        final timeParts = timeStr.split(':');
        if (timeParts.length >= 2) {
          final hour = int.tryParse(timeParts[0]) ?? 0;
          final minute = int.tryParse(timeParts[1]) ?? 0;

          // Use the actual time from database
          _selectedTime = TimeOfDay(hour: hour, minute: minute);
          timeController.text =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

          print(
            'Set time from database: ${_selectedTime.hour}:${_selectedTime.minute}',
          );
        } else {
          // If time format is invalid, use 00:00
          _selectedTime = const TimeOfDay(hour: 0, minute: 0);
          timeController.text = '00:00';
          print('Invalid time format, using 00:00');
        }
      } else {
        // If time is empty or null, use 00:00
        _selectedTime = const TimeOfDay(hour: 0, minute: 0);
        timeController.text = '00:00';
        print('Empty time, using 00:00');
      }
    } catch (e) {
      print('Error parsing time: $e');
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
}

// Global navigator key for context access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
