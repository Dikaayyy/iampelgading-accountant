import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';
  static const String _loginTimestampKey = 'login_timestamp';

  AuthService(this._prefs);

  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
    // Save current timestamp when token is saved
    await _prefs.setInt(
      _loginTimestampKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
    await _prefs.remove(_loginTimestampKey);
  }

  // User data management
  Future<void> saveUserData(String userData) async {
    await _prefs.setString(_userDataKey, userData);
  }

  Future<String?> getUserData() async {
    return _prefs.getString(_userDataKey);
  }

  Future<void> removeUserData() async {
    await _prefs.remove(_userDataKey);
  }

  // Check if token is still valid (24 hours)
  bool isTokenValid() {
    final token = getToken();
    if (token == null) return false;

    final loginTimestamp = _prefs.getInt(_loginTimestampKey);
    if (loginTimestamp == null) return false;

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    final now = DateTime.now();
    final difference = now.difference(loginTime);

    // Token valid for 24 hours
    return difference.inHours < 24;
  }

  // Auth state
  Future<bool> isLoggedIn() async {
    final token = getToken();
    final userData = await getUserData();
    final isValid = isTokenValid();

    if (token != null && userData != null && isValid) {
      return true;
    } else {
      // If token is expired, clear all data
      if (token != null && !isValid) {
        await logout();
      }
      return false;
    }
  }

  Future<void> logout() async {
    await removeToken();
    await removeUserData();
  }

  // Get remaining time until token expires
  Duration? getTokenRemainingTime() {
    final loginTimestamp = _prefs.getInt(_loginTimestampKey);
    if (loginTimestamp == null) return null;

    final loginTime = DateTime.fromMillisecondsSinceEpoch(loginTimestamp);
    final expiryTime = loginTime.add(const Duration(hours: 24));
    final now = DateTime.now();

    if (now.isAfter(expiryTime)) {
      return null; // Token expired
    }

    return expiryTime.difference(now);
  }
}
