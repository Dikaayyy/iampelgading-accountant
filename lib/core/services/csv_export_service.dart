import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';
import 'package:iampelgading/core/services/permission_service.dart';

class CsvExportService {
  static Future<String> exportTransactionsToCsv({
    required List<Transaction> transactions,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // Request permission first
    bool hasPermission = await PermissionService.requestStoragePermission();
    if (!hasPermission) {
      throw Exception('Izin akses storage diperlukan untuk mengekspor file');
    }

    // Prepare CSV data
    String csvContent = _generateCsvContent(transactions, startDate, endDate);

    // Get directory and save file
    final directory = await _getDownloadsDirectory();
    final fileName = _generateFileName(startDate, endDate);
    final filePath = '${directory.path}/$fileName';

    // Write file
    final file = File(filePath);
    await file.writeAsString(csvContent);

    return filePath;
  }

  static Future<Directory> _getDownloadsDirectory() async {
    if (Platform.isAndroid) {
      // Try to get Downloads directory
      try {
        // For Android, use external storage Downloads folder
        final directory = Directory(
          '/storage/emulated/0/Download/iampelgading/csv',
        );

        // Create directory if it doesn't exist
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        return directory;
      } catch (e) {
        // Fallback to app external directory
        final externalDir = await getExternalStorageDirectory();
        if (externalDir != null) {
          final csvDir = Directory('${externalDir.path}/iampelgading/csv');
          if (!await csvDir.exists()) {
            await csvDir.create(recursive: true);
          }
          return csvDir;
        }

        // Final fallback to app documents
        return await getApplicationDocumentsDirectory();
      }
    } else {
      // For iOS, use app documents directory
      return await getApplicationDocumentsDirectory();
    }
  }

  static String _generateFileName(DateTime startDate, DateTime endDate) {
    final startStr = DateFormat('dd-MM-yyyy').format(startDate);
    final endStr = DateFormat('dd-MM-yyyy').format(endDate);
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    return 'transaksi_${startStr}_sampai_${endStr}_${timestamp}.csv';
  }

  static String _generateCsvContent(
    List<Transaction> transactions,
    DateTime startDate,
    DateTime endDate,
  ) {
    final buffer = StringBuffer();

    // Add header
    buffer.writeln(
      'Tanggal,Waktu,Kategori,Keterangan,Metode Pembayaran,Jumlah,Kuantitas,Harga per Item,Jenis',
    );

    // Add data rows
    for (final transaction in transactions) {
      final date = DateFormat('dd/MM/yyyy').format(transaction.date);
      final time = DateFormat('HH:mm').format(transaction.date);
      final amount = transaction.amount.abs().toStringAsFixed(0);
      final jenis = transaction.isIncome ? 'Pemasukan' : 'Pengeluaran';

      // Escape CSV values
      final row = [
        date,
        time,
        _escapeCsvValue(transaction.category),
        _escapeCsvValue(transaction.description),
        _escapeCsvValue(transaction.paymentMethod),
        amount,
        transaction.quantity?.toString() ?? '1',
        transaction.pricePerItem?.toStringAsFixed(0) ?? amount,
        jenis,
      ].join(',');

      buffer.writeln(row);
    }

    return buffer.toString();
  }

  static String _escapeCsvValue(String value) {
    // Handle quotes and commas in CSV
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
