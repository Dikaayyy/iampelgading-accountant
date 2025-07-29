import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthLocalStorage {
  // Keys
  static const String _authTokenKey = 'auth_token';
  static const String _authTokenExpiryKey = 'auth_token_expiry';
  static const String _userDataKey = 'user_data';

  static Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token);

    // Set token expiry to 24 hours
    final expiry = DateTime.now().add(const Duration(hours: 24));
    await prefs.setString(_authTokenExpiryKey, expiry.toIso8601String());

    final duration = expiry.difference(DateTime.now());
    debugPrint(
      '[LOCAL STORAGE TOKEN] Token akan expired dalam ${duration.inHours} jam pada $expiry',
    );
  }

  static Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey);
  }

  static Future<void> saveUserData(String userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDataKey, userData);
  }

  static Future<String?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDataKey);
  }

  static Future<void> clearAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authTokenKey);
    await prefs.remove(_authTokenExpiryKey);
    await prefs.remove(_userDataKey);
    debugPrint('[LOCAL STORAGE] Auth data cleared');
  }

  static Future<bool> isTokenStillValid() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString(_authTokenExpiryKey);

    if (expiryStr == null) {
      debugPrint('[LOCAL STORAGE] Token expiry not found');
      return false;
    }

    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null || DateTime.now().isAfter(expiry)) {
      debugPrint('[LOCAL STORAGE] Token expired at $expiry');
      await clearAuthData();
      return false;
    }

    debugPrint('[LOCAL STORAGE] Token is still valid until $expiry');
    return true;
  }

  static Future<Duration?> getTokenRemainingTime() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryStr = prefs.getString(_authTokenExpiryKey);

    if (expiryStr == null) return null;

    final expiry = DateTime.tryParse(expiryStr);
    if (expiry == null) return null;

    final now = DateTime.now();
    if (now.isAfter(expiry)) {
      return null; // Token expired
    }

    return expiry.difference(now);
  }
}
