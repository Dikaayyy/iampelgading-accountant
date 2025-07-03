import 'package:flutter/material.dart';

class DashboardProvider with ChangeNotifier {
  bool _isLoading = false;
  double _totalIncome = 2700000.0;
  double _totalExpense = 500000.0;
  String? _userName = 'Admin Iampelgading';

  bool get isLoading => _isLoading;
  double get totalIncome => _totalIncome;
  double get totalExpense => _totalExpense;
  double get netIncome => _totalIncome - _totalExpense;
  String? get userName => _userName;

  Future<void> refreshDashboard() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    _isLoading = false;
    notifyListeners();
  }

  void updateData({double? income, double? expense, String? userName}) {
    if (income != null) _totalIncome = income;
    if (expense != null) _totalExpense = expense;
    if (userName != null) _userName = userName;
    notifyListeners();
  }
}
