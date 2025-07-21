import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iampelgading/features/transaction/data/models/transaction_model.dart';
import 'package:iampelgading/core/services/auth_service.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> getTransactions();
  Future<PaginatedTransactionResponse> getTransactionsPaginated({
    int page = 1,
    int limit = 10,
    String? search,
  });
  Future<TransactionModel> addTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
}

class PaginatedTransactionResponse {
  final List<TransactionModel> data;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final bool hasNextPage;
  final bool hasPrevPage;

  PaginatedTransactionResponse({
    required this.data,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  factory PaginatedTransactionResponse.fromJson(Map<String, dynamic> json) {
    // Handle nested pagination object
    final paginationData = json['pagination'] as Map<String, dynamic>? ?? {};

    return PaginatedTransactionResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map(
                (item) =>
                    TransactionModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalItems: paginationData['totalItems'] as int? ?? 0,
      totalPages: paginationData['totalPages'] as int? ?? 0,
      currentPage: paginationData['currentPage'] as int? ?? 1,
      hasNextPage: paginationData['hasNextPage'] as bool? ?? false,
      hasPrevPage: paginationData['hasPreviousPage'] as bool? ?? false,
    );
  }
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
  Future<PaginatedTransactionResponse> getTransactionsPaginated({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/transactions').replace(
        queryParameters: {
          'page': page.toString(),
          'limit': limit.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      print('Requesting URL: $uri'); // Debug log

      final response = await client.get(uri, headers: _getHeaders());

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        print('Response data: $responseData'); // Debug log

        if (responseData is Map<String, dynamic>) {
          final result = PaginatedTransactionResponse.fromJson(responseData);

          // Debug log pagination info
          print(
            'Pagination info - Current: ${result.currentPage}, Total: ${result.totalPages}, HasNext: ${result.hasNextPage}, Data count: ${result.data.length}',
          );

          return result;
        } else if (responseData is List) {
          // Fallback for non-paginated response
          final transactions =
              responseData
                  .map(
                    (json) =>
                        TransactionModel.fromJson(json as Map<String, dynamic>),
                  )
                  .toList();

          return PaginatedTransactionResponse(
            data: transactions,
            totalItems: transactions.length,
            totalPages: 1,
            currentPage: 1,
            hasNextPage: false,
            hasPrevPage: false,
          );
        } else {
          throw Exception(
            'Unexpected response format: ${responseData.runtimeType}',
          );
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getTransactionsPaginated: $e'); // Debug log
      if (e.toString().contains('Unauthorized')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/transactions'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);

        // Handle different response formats
        List<dynamic> jsonList;

        if (responseData is List) {
          // Direct list response
          jsonList = responseData;
        } else if (responseData is Map<String, dynamic>) {
          // Object response - check for common list property names
          if (responseData.containsKey('data')) {
            jsonList = responseData['data'] as List<dynamic>;
          } else if (responseData.containsKey('transactions')) {
            jsonList = responseData['transactions'] as List<dynamic>;
          } else if (responseData.containsKey('items')) {
            jsonList = responseData['items'] as List<dynamic>;
          } else {
            // If it's a single object, wrap it in a list
            jsonList = [responseData];
          }
        } else {
          throw Exception(
            'Unexpected response format: ${responseData.runtimeType}',
          );
        }

        return jsonList
            .map(
              (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
            )
            .toList();
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    try {
      final requestBody = transaction.toJson();

      final response = await client.post(
        Uri.parse('$baseUrl/transactions'),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Parse response to get the created transaction
        final responseData = json.decode(response.body);
        return TransactionModel.fromJson(responseData);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to add transaction: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(
    TransactionModel transaction,
  ) async {
    try {
      final requestBody = transaction.toJson();

      final response = await client.put(
        Uri.parse('$baseUrl/transactions/${transaction.id}'),
        headers: _getHeaders(),
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // Parse response to get the updated transaction
        final responseData = json.decode(response.body);
        return TransactionModel.fromJson(responseData);
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception('Unauthorized: Please login again');
      } else {
        throw Exception('Failed to update transaction: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('Unauthorized')) {
        rethrow;
      }
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
      if (e.toString().contains('Unauthorized')) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
