import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  bool _isLoading = false;
  String _userName = 'I\'AMpelgading Homeland';
  String _profileImageUrl = 'https://placehold.co/111x111';

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get profileImageUrl => _profileImageUrl;

  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void updateProfileImage(String newImageUrl) {
    _profileImageUrl = newImageUrl;
    notifyListeners();
  }

  Future<void> refreshProfile() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _isLoading = false;
    notifyListeners();
  }

  void onChangePassword() {
    // Navigation will be handled in the UI
    print('Change password tapped');
  }

  void onChangeUsername() {
    print('Change username tapped');
  }

  void onAppInfo() {
    print('App info tapped');
  }
}
