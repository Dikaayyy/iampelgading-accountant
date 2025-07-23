import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> refreshProfile() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void onChangePassword() {
    // Navigation will be handled in the UI
  }

  void onChangeUsername() {}

  void onAppInfo() {}
}
