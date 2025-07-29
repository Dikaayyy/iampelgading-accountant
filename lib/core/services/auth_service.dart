import 'package:iampelgading/core/storage/auth_local_storage.dart';

class AuthService {
  AuthService();

  // Token management
  Future<void> saveToken(String token) async {
    await AuthLocalStorage.saveAuthToken(token);
  }

  Future<String?> getToken() async {
    return await AuthLocalStorage.getAuthToken();
  }

  Future<void> removeToken() async {
    await AuthLocalStorage.clearAuthData();
  }

  // User data management
  Future<void> saveUserData(String userData) async {
    await AuthLocalStorage.saveUserData(userData);
  }

  Future<String?> getUserData() async {
    return await AuthLocalStorage.getUserData();
  }

  Future<void> removeUserData() async {
    await AuthLocalStorage.clearAuthData();
  }

  // Check if token is still valid (3 hours)
  Future<bool> isTokenValid() async {
    final isValid = await AuthLocalStorage.isTokenStillValid();
    if (!isValid) {
      await logout();
    }
    return isValid;
  }

  // Auth state
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    final userData = await getUserData();
    final isValid = await isTokenValid();

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
    await AuthLocalStorage.clearAuthData();
  }

  // Get remaining time until token expires
  Future<Duration?> getTokenRemainingTime() async {
    return await AuthLocalStorage.getTokenRemainingTime();
  }
}
