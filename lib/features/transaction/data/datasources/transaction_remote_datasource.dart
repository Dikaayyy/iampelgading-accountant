import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iampelgading/features/transaction/data/models/transaction_model.dart';
import 'package:iampelgading/core/services/auth_service.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final http.Client client;
  final AuthService authService;
  static const String baseUrl = 'https://nf1nkx0k-8080.asse.devtunnels.ms/api';

  TransactionRemoteDataSourceImpl({
    required this.client,
    required this.authService,
  });

  Map<String, String> _getHeaders() {
    final token = authService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/transactions'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => TransactionModel.fromJson(json)).toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/transactions'),
        headers: _getHeaders(),
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/transactions/${transaction.id}'),
        headers: _getHeaders(),
        body: json.encode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final response = await client.delete(
        Uri.parse('$baseUrl/transactions/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to delete transaction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
