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
      // Debug logging
      print('Parsing date: "$dateString", time: "$timeString"');

      // Parse date from format "18-07-2025" or "2025-07-18"
      final dateParts = dateString.split('-');
      if (dateParts.length == 3) {
        int day, month, year;

        // Handle both formats: "18-07-2025" and "2025-07-18"
        if (dateParts[0].length == 4) {
          // Format: "2025-07-18"
          year = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          day = int.parse(dateParts[2]);
        } else {
          // Format: "18-07-2025"
          day = int.parse(dateParts[0]);
          month = int.parse(dateParts[1]);
          year = int.parse(dateParts[2]);
        }

        // Handle time parsing
        if (timeString.isNotEmpty && timeString != 'null') {
          try {
            // If timeString is in full datetime format "YYYY-MM-DD HH:MM:SS"
            if (timeString.contains(' ')) {
              final timeDate = DateTime.parse(timeString);
              final result = DateTime(
                year,
                month,
                day,
                timeDate.hour,
                timeDate.minute,
                timeDate.second,
              );
              print('Combined date and time from full format: $result');
              return result;
            }
            // If timeString is just time "HH:MM:SS" or "HH:MM"
            else if (timeString.contains(':')) {
              final timeParts = timeString.split(':');
              if (timeParts.length >= 2) {
                final hour = int.tryParse(timeParts[0]) ?? 0;
                final minute = int.tryParse(timeParts[1]) ?? 0;
                final second =
                    timeParts.length > 2
                        ? (int.tryParse(timeParts[2]) ?? 0)
                        : 0;

                final result = DateTime(year, month, day, hour, minute, second);
                print('Combined date and time from time format: $result');
                return result;
              }
            }
          } catch (e) {
            print('Failed to parse time component: $e');
          }
        }

        // If no valid time provided, use midnight (00:00:00) instead of current time
        final result = DateTime(year, month, day, 0, 0, 0);
        print('Using midnight as default: $result');
        return result;
      }
    } catch (e) {
      print('DateTime parsing error: $e');
    }

    // Fallback to current datetime only if everything fails
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
