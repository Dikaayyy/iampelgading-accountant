import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileSettingsProvider with ChangeNotifier {
  bool _isLoading = false;
  String _username = '';
  String _originalUsername = '';
  File? _selectedImage;
  String? _currentImageUrl;

  bool get isLoading => _isLoading;
  String get username => _username;
  File? get selectedImage => _selectedImage;
  String? get currentImageUrl => _currentImageUrl;

  void initializeData(String currentUsername, String? currentImageUrl) {
    _username = currentUsername;
    _originalUsername = currentUsername;
    _currentImageUrl = currentImageUrl;
    notifyListeners();
  }

  void updateUsername(String newUsername) {
    _username = newUsername;
    notifyListeners();
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> takePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 80,
      );

      if (image != null) {
        _selectedImage = File(image.path);
        notifyListeners();
      }
    } catch (e) {
      // Handle error
    }
  }

  void removeSelectedImage() {
    _selectedImage = null;
    notifyListeners();
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username harus diisi';
    }
    if (value.length < 3) {
      return 'Username minimal 3 karakter';
    }
    if (value.length > 20) {
      return 'Username maksimal 20 karakter';
    }
    if (!RegExp(r'^[a-zA-Z0-9_\s]+$').hasMatch(value)) {
      return 'Username hanya boleh mengandung huruf, angka, underscore, dan spasi';
    }
    return null;
  }

  Future<void> updateProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // In real implementation, upload image and update profile here
      // Example:
      // if (_selectedImage != null) {
      //   final imageUrl = await uploadImage(_selectedImage!);
      //   _currentImageUrl = imageUrl;
      // }
      // await updateUserProfile(_username, _currentImageUrl);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  bool get hasChanges {
    return _username != _originalUsername || _selectedImage != null;
  }

  bool get isFormValid {
    return _username.isNotEmpty &&
        _username.length >= 3 &&
        _username.length <= 20 &&
        RegExp(r'^[a-zA-Z0-9_\s]+$').hasMatch(_username);
  }
}
