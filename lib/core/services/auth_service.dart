import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final SharedPreferences _prefs;

  static const String _tokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  AuthService(this._prefs);

  // Token management
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  String? getToken() {
    return _prefs.getString(_tokenKey);
  }

  Future<void> removeToken() async {
    await _prefs.remove(_tokenKey);
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

  // Auth state
  Future<bool> isLoggedIn() async {
    final token = getToken();
    final userData = await getUserData();
    return token != null && userData != null;
  }

  Future<void> logout() async {
    await removeToken();
    await removeUserData();
  }
}
