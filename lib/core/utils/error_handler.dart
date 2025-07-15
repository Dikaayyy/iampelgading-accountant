import 'package:dio/dio.dart';
import 'dart:io';

class ErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (error is HttpException) {
      return _handleHttpError(error);
    } else if (error is FormatException) {
      return 'Format data tidak valid.';
    } else if (error is Exception) {
      return _handleGeneralException(error);
    }
    return 'Terjadi kesalahan yang tidak diketahui.';
  }

  static String _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Silakan coba lagi.';

      case DioExceptionType.badResponse:
        return _handleHttpStatusError(error.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';

      case DioExceptionType.connectionError:
        return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
        }
        return 'Terjadi kesalahan yang tidak diketahui.';

      default:
        return 'Terjadi kesalahan jaringan.';
    }
  }

  static String _handleHttpError(HttpException error) {
    final message = error.message.toLowerCase();

    if (message.contains('connection') || message.contains('network')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }

    return 'Terjadi kesalahan server.';
  }

  static String _handleGeneralException(Exception error) {
    final errorString = error.toString();

    // Handle different types of errors
    if (errorString.contains('SocketException') ||
        errorString.contains('Network error') ||
        errorString.contains('Failed host lookup')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    } else if (errorString.contains('TimeoutException') ||
        errorString.contains('timeout')) {
      return 'Permintaan timeout. Silakan coba lagi.';
    } else if (errorString.contains('401') ||
        errorString.contains('Unauthorized') ||
        errorString.contains('Invalid credentials')) {
      return 'Username atau password yang Anda masukkan salah.';
    } else if (errorString.contains('403') ||
        errorString.contains('Forbidden')) {
      return 'Akses ditolak. Silakan hubungi administrator.';
    } else if (errorString.contains('404') ||
        errorString.contains('Not Found')) {
      return 'Layanan tidak ditemukan. Silakan hubungi administrator.';
    } else if (errorString.contains('500') ||
        errorString.contains('Internal Server Error')) {
      return 'Terjadi kesalahan server. Silakan coba lagi nanti.';
    } else if (errorString.contains('Exception:')) {
      return errorString.replaceFirst('Exception: ', '');
    }

    return 'Terjadi kesalahan yang tidak diketahui.';
  }

  static String _handleHttpStatusError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Permintaan tidak valid.';
      case 401:
        return 'Username atau password yang Anda masukkan salah.';
      case 403:
        return 'Akses ditolak. Silakan hubungi administrator.';
      case 404:
        return 'Layanan tidak ditemukan. Silakan hubungi administrator.';
      case 408:
        return 'Permintaan timeout. Silakan coba lagi.';
      case 422:
        return 'Data yang dikirim tidak valid.';
      case 429:
        return 'Terlalu banyak permintaan. Silakan coba lagi nanti.';
      case 500:
        return 'Terjadi kesalahan server. Silakan coba lagi nanti.';
      case 502:
        return 'Server tidak dapat diakses. Silakan coba lagi nanti.';
      case 503:
        return 'Layanan sedang tidak tersedia. Silakan coba lagi nanti.';
      case 504:
        return 'Gateway timeout. Silakan coba lagi nanti.';
      default:
        return 'Terjadi kesalahan server ($statusCode).';
    }
  }

  // Method untuk mendapatkan error title berdasarkan error type
  static String getErrorTitle(dynamic error) {
    if (error is DioException) {
      return _getDioErrorTitle(error);
    } else if (error is SocketException) {
      return 'Koneksi Bermasalah';
    } else if (error is Exception) {
      return _getGeneralExceptionTitle(error);
    }
    return 'Terjadi Kesalahan';
  }

  static String _getDioErrorTitle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Timeout';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) return 'Kredensial Salah';
        if (statusCode == 403) return 'Akses Ditolak';
        if (statusCode == 404) return 'Tidak Ditemukan';
        if (statusCode != null && statusCode >= 500) return 'Server Error';
        return 'Request Error';

      case DioExceptionType.cancel:
        return 'Dibatalkan';

      case DioExceptionType.connectionError:
        return 'Koneksi Bermasalah';

      default:
        return 'Network Error';
    }
  }

  static String _getGeneralExceptionTitle(Exception error) {
    final errorString = error.toString();

    if (errorString.contains('SocketException') ||
        errorString.contains('Network error') ||
        errorString.contains('Failed host lookup')) {
      return 'Koneksi Bermasalah';
    } else if (errorString.contains('TimeoutException') ||
        errorString.contains('timeout')) {
      return 'Timeout';
    } else if (errorString.contains('401') ||
        errorString.contains('Unauthorized') ||
        errorString.contains('Invalid credentials')) {
      return 'Kredensial Salah';
    } else if (errorString.contains('403') ||
        errorString.contains('Forbidden')) {
      return 'Akses Ditolak';
    } else if (errorString.contains('404') ||
        errorString.contains('Not Found')) {
      return 'Tidak Ditemukan';
    } else if (errorString.contains('500') ||
        errorString.contains('Internal Server Error')) {
      return 'Server Error';
    }

    return 'Terjadi Kesalahan';
  }
}
