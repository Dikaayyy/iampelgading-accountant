import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iampelgading/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  static const String baseUrl = 'https://nf1nkx0k-8080.asse.devtunnels.ms/api';

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Assuming the API returns user data in 'data' field
        // Adjust according to your API response structure
        final userData = jsonData['data'] ?? jsonData;

        return UserModel.fromJson(userData);
      } else {
        final errorData = jsonDecode(response.body);
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
