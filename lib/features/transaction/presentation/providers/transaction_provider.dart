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
