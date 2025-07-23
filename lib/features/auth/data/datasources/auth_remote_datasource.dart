import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iampelgading/features/auth/data/models/user_model.dart';
import 'package:iampelgading/core/services/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final AuthService authService;
  static const String baseUrl = 'http://202.10.40.191/api';

  AuthRemoteDataSourceImpl({required this.client, required this.authService});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        // Save token if exists
        if (responseData.containsKey('token') &&
            responseData['token'] != null) {
          await authService.saveToken(responseData['token']);
        }

        // Handle different response structures
        Map<String, dynamic> userData;
        if (responseData.containsKey('user') && responseData['user'] != null) {
          userData = responseData['user'] as Map<String, dynamic>;
        } else if (responseData.containsKey('data') &&
            responseData['data'] != null) {
          userData = responseData['data'] as Map<String, dynamic>;
        } else {
          // If no nested user data, use the response directly
          userData = responseData;
        }

        return UserModel.fromJson(userData);
      } else if (response.statusCode == 401) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage =
            errorData['message'] ?? 'Invalid username or password';
        throw Exception(errorMessage);
      } else if (response.statusCode == 422) {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'Validation failed';
        throw Exception(errorMessage);
      } else {
        final errorData = json.decode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['message'] ?? 'Login failed';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: ${e.toString()}');
    }
  }
}
