import 'package:flutter/material.dart';
import 'package:iampelgading/features/transaction/domain/usecases/get_transactions_usecase.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/features/transaction/domain/usecases/add_transaction.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:iampelgading/core/di/service_locator.dart' as di;

class TransactionProvider with ChangeNotifier {
  final AddTransaction? _addTransaction;
  final GetTransactions? _getTransactions;

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
    'Penjualan',
    'Jasa',
    'Investasi',
    'Bonus',
    'Lainnya',
  ];

  List<String> get expenseCategories => [
    'Operasional',
    'Pemeliharaan',
    'Konsumsi',
    'Transport',
    'Lainnya',
  ];

  TransactionProvider([this._addTransaction, this._getTransactions]) {
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
      'time': _formatTimeOnly(transaction.date),
      'date': DateFormat('dd MMMM yyyy', 'id_ID').format(transaction.date),
      'amount': transaction.amount,
      'icon': transaction.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
      'paymentMethod': transaction.paymentMethod,
      'description': transaction.description,
      'category': transaction.category,
      'quantity': transaction.quantity,
      'pricePerItem': transaction.pricePerItem,
    };
  }

  // Add this helper method
  String _formatTimeOnly(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
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
      try {
        // Try to use context if available
        final context = navigatorKey.currentContext;
        if (context != null) {
          timeController.text = _selectedTime.format(context);
        } else {
          timeController.text =
              '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
        }
      } catch (e) {
        timeController.text =
            '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      dateController.text = DateFormat(
        'dd MMMM yyyy',
        'en_US',
      ).format(_selectedDate);
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
    timeController.text = time.format(context);
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

  Future<void> saveTransaction({required bool isIncome}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_addTransaction != null) {
        // Create transaction entity
        final transaction = Transaction(
          title: categoryController.text,
          amount: isIncome ? _totalAmount : -_totalAmount,
          category: categoryController.text,
          date: _selectedDate,
          paymentMethod: _selectedPaymentMethod ?? 'Cash',
          description: descriptionController.text,
          isIncome: isIncome,
          quantity: int.tryParse(quantityController.text) ?? 0,
          pricePerItem: double.tryParse(priceController.text) ?? 0.0,
        );

        await _addTransaction!.call(transaction);

        // Refresh transactions after adding
        await loadTransactions();
      } else {
        await Future.delayed(const Duration(seconds: 2));
      }

      _clearForm();
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

  Future<void> updateTransaction({
    required bool isIncome,
    required String transactionId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_addTransaction != null) {
        // For now, we'll treat update as add since the API structure might be different
        await saveTransaction(isIncome: isIncome);
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

  void incrementQuantity() {
    final currentValue = double.tryParse(quantityController.text) ?? 0.0;
    final newValue = currentValue + 1;
    quantityController.text = newValue.toInt().toString();
    updateQuantityOrPrice();
  }

  void decrementQuantity() {
    final currentValue = double.tryParse(quantityController.text) ?? 0.0;
    if (currentValue > 0) {
      final newValue = currentValue - 1;
      quantityController.text = newValue.toInt().toString();
      updateQuantityOrPrice();
    }
  }

  void updateQuantityFromText(String value) {
    if (value.isEmpty) {
      quantityController.text = '0';
    } else {
      final numValue = double.tryParse(value);
      if (numValue == null || numValue < 0) {
        quantityController.text = '0';
      }
    }
    updateQuantityOrPrice();
  }

  void _clearForm() {
    quantityController.text = '0';
    priceController.clear();
    descriptionController.clear();
    categoryController.clear();
    _selectedPaymentMethod = null;
    _totalAmount = 0.0;
    _initializeDefaultValues();
  }

  void populateFromTransaction(Map<String, dynamic> transaction) {
    final amount = transaction['amount'] as double? ?? 0.0;
    final absoluteAmount = amount.abs();

    descriptionController.text = transaction['description'] as String? ?? '';

    final paymentMethod = transaction['paymentMethod'] as String? ?? 'Cash';
    if (paymentMethods.contains(paymentMethod)) {
      updatePaymentMethod(paymentMethod);
    }

    final defaultCategory = amount > 0 ? 'Penjualan' : 'Operasional';
    categoryController.text = defaultCategory;

    try {
      final dateStr = transaction['date'] as String? ?? '';
      final dateParts = dateStr.split(' ');
      if (dateParts.length >= 3) {
        final monthNames = {
          'January': 1,
          'February': 2,
          'March': 3,
          'April': 4,
          'May': 5,
          'June': 6,
          'July': 7,
          'August': 8,
          'September': 9,
          'October': 10,
          'November': 11,
          'December': 12,
        };

        final day = int.tryParse(dateParts[0]) ?? 1;
        final month = monthNames[dateParts[1]] ?? 1;
        final year = int.tryParse(dateParts[2]) ?? DateTime.now().year;

        final parsedDate = DateTime(year, month, day);
        updateDate(parsedDate);
      }
    } catch (e) {
      updateDate(DateTime.now());
    }

    final timeStr = transaction['time'] as String? ?? '';
    try {
      final timeParts = timeStr.split(':');
      if (timeParts.length >= 2) {
        final hour = int.tryParse(timeParts[0]) ?? 0;
        final minute = int.tryParse(timeParts[1]) ?? 0;
        final timeOfDay = TimeOfDay(hour: hour, minute: minute);

        // Use a more robust way to format time
        final context = navigatorKey.currentContext;
        if (context != null) {
          updateTime(timeOfDay, context);
        } else {
          _selectedTime = timeOfDay;
          timeController.text =
              '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        }
      }
    } catch (e) {
      _selectedTime = TimeOfDay.now();
      timeController.text =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}';
    }

    final quantity = transaction['quantity'] as int? ?? 1;
    final pricePerItem =
        transaction['pricePerItem'] as double? ?? absoluteAmount;

    quantityController.text = quantity.toString();
    priceController.text = pricePerItem.toString();

    updateQuantityOrPrice();
    notifyListeners();
  }
}

// Global navigator key for context access
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
