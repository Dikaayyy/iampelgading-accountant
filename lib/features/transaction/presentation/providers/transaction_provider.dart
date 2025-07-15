import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/features/transaction/domain/usecases/add_transaction.dart';

class TransactionProvider with ChangeNotifier {
  final AddTransaction? _addTransaction;

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

  // Getters
  DateTime get selectedDate => _selectedDate;
  TimeOfDay get selectedTime => _selectedTime;
  bool get isLoading => _isLoading;
  String? get selectedPaymentMethod => _selectedPaymentMethod;
  double get totalAmount => _totalAmount;

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

  TransactionProvider([this._addTransaction]) {
    _initializeDefaultValues();
    // Set default quantity to 0
    quantityController.text = '0';
  }

  void _initializeDefaultValues() {
    try {
      // Set default date to today
      _selectedDate = DateTime.now();

      // Try to format with Indonesian locale, fallback to English if not available
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

      // Set default time to current time
      _selectedTime = TimeOfDay.now();
      timeController.text = _formatTimeOfDay(_selectedTime);
    } catch (e) {
      // Fallback values if initialization fails
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      dateController.text =
          '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
      timeController.text = _formatTimeOfDay(_selectedTime);
    }
  }

  // Helper method to format TimeOfDay without context
  String _formatTimeOfDay(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
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
    notifyListeners();

    try {
      // Use the injected use case if available
      if (_addTransaction != null) {
        // Create transaction data and call use case
        // await _addTransaction!.call(transactionData);
      } else {
        // Fallback: simulate API call
        await Future.delayed(const Duration(seconds: 2));
      }

      // Clear form after successful save
      _clearForm();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransaction({
    required bool isIncome,
    required String transactionId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Use the injected use case if available
      if (_addTransaction != null) {
        // Create updated transaction data and call update use case
        // await _updateTransaction!.call(transactionId, transactionData);
      } else {
        // Fallback: simulate API call
        await Future.delayed(const Duration(seconds: 2));
      }

      // Don't clear form after successful update (user might want to see the result)

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
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
    // Validate that it's a valid number
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
    // Reset to default values
    quantityController.text = '0'; // Set default to 0
    priceController.clear();
    descriptionController.clear();
    categoryController.clear();
    _selectedPaymentMethod = null;
    _totalAmount = 0.0;

    // Reset date and time to current
    _initializeDefaultValues();
  }

  void populateFromTransaction(Map<String, dynamic> transaction) {
    // Parse existing transaction data
    final amount = transaction['amount'] as double? ?? 0.0;
    final absoluteAmount = amount.abs();

    // Set basic transaction details
    descriptionController.text = transaction['description'] as String? ?? '';

    // Set payment method if exists
    final paymentMethod = transaction['paymentMethod'] as String? ?? 'Cash';
    if (paymentMethods.contains(paymentMethod)) {
      updatePaymentMethod(paymentMethod);
    }

    // Set category - you might need to map from transaction title to category
    final defaultCategory = amount > 0 ? 'Penjualan' : 'Operasional';
    categoryController.text = defaultCategory;

    // Parse date from string format "20 August 2024"
    try {
      final dateStr = transaction['date'] as String? ?? '';
      final dateParts = dateStr.split(' ');
      if (dateParts.length >= 3) {
        final day = int.parse(dateParts[0]);
        final monthName = dateParts[1];
        final year = int.parse(dateParts[2]);

        // Map month names to numbers
        final monthMap = {
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

        final month = monthMap[monthName] ?? DateTime.now().month;
        final parsedDate = DateTime(year, month, day);
        updateDate(parsedDate);
      }
    } catch (e) {
      // If parsing fails, use current date
      updateDate(DateTime.now());
    }

    // Parse time from string format "14:30"
    try {
      final timeStr = transaction['time'] as String? ?? '';
      final timeParts = timeStr.split(':');
      if (timeParts.length >= 2) {
        final hour = int.parse(timeParts[0]);
        final minute = int.parse(timeParts[1]);
        final parsedTime = TimeOfDay(hour: hour, minute: minute);
        _selectedTime = parsedTime;
        timeController.text = _formatTimeOfDay(parsedTime);
      }
    } catch (e) {
      // If parsing fails, use current time
      final currentTime = TimeOfDay.now();
      _selectedTime = currentTime;
      timeController.text = _formatTimeOfDay(currentTime);
    }

    // For editing, we'll assume quantity is 1 and price is the total amount
    quantityController.text = '1';
    priceController.text = absoluteAmount.toString();
    updateQuantityOrPrice();

    notifyListeners();
  }

  @override
  void dispose() {
    dateController.dispose();
    timeController.dispose();
    quantityController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    categoryController.dispose();
    super.dispose();
  }
}
