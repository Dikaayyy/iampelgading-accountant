import 'package:flutter/material.dart';

class ChangePasswordProvider with ChangeNotifier {
  bool _isLoading = false;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  bool get isLoading => _isLoading;
  bool get isOldPasswordVisible => _isOldPasswordVisible;
  bool get isNewPasswordVisible => _isNewPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;

  void toggleOldPasswordVisibility() {
    _isOldPasswordVisible = !_isOldPasswordVisible;
    notifyListeners();
  }

  void toggleNewPasswordVisibility() {
    _isNewPasswordVisible = !_isNewPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  void updateOldPassword(String password) {
    _oldPassword = password;
    notifyListeners();
  }

  void updateNewPassword(String password) {
    _newPassword = password;
    notifyListeners();
  }

  void updateConfirmPassword(String password) {
    _confirmPassword = password;
    notifyListeners();
  }

  String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password lama harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password baru harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    if (value == _oldPassword) {
      return 'Password baru harus berbeda dengan password lama';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password harus diisi';
    }
    if (value != _newPassword) {
      return 'Password tidak sama';
    }
    return null;
  }

  Future<void> changePassword() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Simulate successful password change
      // In real implementation, call your API here

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  bool get isFormValid {
    return _oldPassword.isNotEmpty &&
        _newPassword.isNotEmpty &&
        _confirmPassword.isNotEmpty &&
        _newPassword == _confirmPassword &&
        _newPassword != _oldPassword &&
        _oldPassword.length >= 6 &&
        _newPassword.length >= 6;
  }
}
