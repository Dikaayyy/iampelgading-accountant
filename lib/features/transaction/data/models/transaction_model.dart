import 'package:iampelgading/features/transaction/domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    super.id,
    required super.title,
    required super.amount,
    required super.category,
    required super.date,
    required super.paymentMethod,
    required super.description,
    required super.isIncome,
    required super.quantity,
    required super.pricePerItem,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final pemasukan = json['pemasukan'] as int?;
    final pengeluaran = json['pengeluaran'] as int?;
    final isIncome = (pemasukan != null && pemasukan > 0);
    final amount =
        isIncome ? pemasukan.toDouble() : -(pengeluaran?.toDouble() ?? 0.0);

    return TransactionModel(
      id: json['id']?.toString(),
      title: json['nama_akun'] ?? '',
      amount: amount,
      category: isIncome ? 'Penjualan' : 'Operasional',
      date: _parseDateTime(
        json['tanggal'] ?? '',
        json['waktu'] ?? json['Waktu'] ?? '',
      ), // Handle both cases
      paymentMethod: 'Cash',
      description: json['keterangan'] ?? '',
      isIncome: isIncome,
      quantity: 1,
      pricePerItem: amount.abs(),
    );
  }

  static DateTime _parseDateTime(String dateString, String timeString) {
    try {
      print('Parsing date: "$dateString", time: "$timeString"');

      // Parse date from format "23-07-2025" or "2025-07-23"
      final dateParts = dateString.split('-');
      if (dateParts.length == 3) {
        int day, month, year;

        // Handle both formats: "23-07-2025" and "2025-07-23"
        if (dateParts[0].length == 4) {
          // Format: "2025-07-23"
          year = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          day = int.parse(dateParts[2]);
        } else {
          // Format: "23-07-2025"
          day = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          year = int.parse(dateParts[2]);
        }

        // Parse time if provided
        int hour = 0;
        int minute = 0;
        int second = 0;

        if (timeString.isNotEmpty && timeString != 'null') {
          final timeParts = timeString.split(':');
          if (timeParts.isNotEmpty) {
            hour = int.tryParse(timeParts[0]) ?? 0;
          }
          if (timeParts.length > 1) {
            minute = int.tryParse(timeParts[1]) ?? 0;
          }
          if (timeParts.length > 2) {
            second = int.tryParse(timeParts[2]) ?? 0;
          }
        }

        final parsedDateTime = DateTime(year, month, day, hour, minute, second);
        print('Parsed DateTime: $parsedDateTime');

        return parsedDateTime;
      }
    } catch (e) {
      print('Error parsing date/time: $e');
    }

    // Fallback to current date/time
    return DateTime.now();
  }

  // Updated toJson method to handle null time
  Map<String, dynamic> toJson() {
    // Format date as YYYY-MM-DD
    final formattedDate =
        '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

    // Format time as YYYY-MM-DD HH:MM:SS, or null if time is default/empty
    String? formattedTime;

    // Only include time if it's not default midnight
    if (date.hour != 0 || date.minute != 0 || date.second != 0) {
      formattedTime =
          '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.second.toString().padLeft(2, '0')}';
    }

    return {
      'tanggal': formattedDate,
      'waktu': formattedTime, // This will be null if time is default
      'pengeluaran': isIncome ? null : amount.abs().toInt(),
      'pemasukan': isIncome ? amount.toInt() : null,
      'nama_akun': title,
      'keterangan': description,
    };
  }

  factory TransactionModel.fromEntity(Transaction transaction) {
    return TransactionModel(
      id: transaction.id,
      title: transaction.title,
      amount: transaction.amount,
      category: transaction.category,
      date: transaction.date,
      paymentMethod: transaction.paymentMethod,
      description: transaction.description,
      isIncome: transaction.isIncome,
      quantity: transaction.quantity,
      pricePerItem: transaction.pricePerItem,
    );
  }
}
