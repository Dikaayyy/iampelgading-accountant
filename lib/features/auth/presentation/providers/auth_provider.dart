import 'package:flutter/material.dart';
import 'package:iampelgading/features/auth/domain/entities/user.dart';
import 'package:iampelgading/features/auth/domain/usecases/login_usecase.dart';
import 'package:iampelgading/core/utils/error_handler.dart';

class AuthProvider with ChangeNotifier {
  final LoginUsecase _loginUsecase;

  bool _isLoading = false;
  bool _isPasswordVisible = false;
  String _username = '';
  String _password = '';
  String _errorMessage = '';
  User? _currentUser;

  AuthProvider({required LoginUsecase loginUsecase})
    : _loginUsecase = loginUsecase;

  bool get isLoading => _isLoading;
  bool get isPasswordVisible => _isPasswordVisible;
  String get username => _username;
  String get password => _password;
  String get errorMessage => _errorMessage;
  User? get currentUser => _currentUser;

  bool get isFormValid {
    return _username.isNotEmpty &&
        _password.isNotEmpty &&
        _username.length >= 3 &&
        _password.length >= 6;
  }

  void updateUsername(String username) {
    _username = username;
    _clearError();
    notifyListeners();
  }

  void updatePassword(String password) {
    _password = password;
    _clearError();
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void _clearError() {
    if (_errorMessage.isNotEmpty) {
      _errorMessage = '';
      notifyListeners();
    }
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username harus diisi';
    }
    if (value.length < 3) {
      return 'Username minimal 3 karakter';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password harus diisi';
    }
    if (value.length < 6) {
      return 'Password minimal 6 karakter';
    }
    return null;
  }

  Future<void> login() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final user = await _loginUsecase.call(
        username: _username,
        password: _password,
      );

      _currentUser = user;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = ErrorHandler.getErrorMessage(e);
      notifyListeners();
      rethrow;
    }
  }

  void clearForm() {
    _username = '';
    _password = '';
    _errorMessage = '';
    _isPasswordVisible = false;
    _currentUser = null;
    notifyListeners();
  }
}
