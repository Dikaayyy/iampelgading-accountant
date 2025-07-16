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
      date: _parseDateTime(json['tanggal'] ?? '', json['Waktu'] ?? ''),
      paymentMethod: 'Cash',
      description: json['keterangan'] ?? '',
      isIncome: isIncome,
      quantity: 1,
      pricePerItem: amount.abs(),
    );
  }

  static DateTime _parseDateTime(String dateString, String timeString) {
    try {
      // Parse date from format "12-07-2025"
      final dateParts = dateString.split('-');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);

        // Parse time from ISO format "2025-07-16T05:59:54.000Z"
        if (timeString.isNotEmpty) {
          try {
            final timeDate = DateTime.parse(timeString);
            return DateTime(
              year,
              month,
              day,
              timeDate.hour,
              timeDate.minute,
              timeDate.second,
            );
          } catch (e) {
            // If time parsing fails, use date only
            return DateTime(year, month, day);
          }
        }

        return DateTime(year, month, day);
      }
    } catch (e) {
      // If parsing fails, return current date
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'category': category,
      'date': date.toIso8601String(),
      'paymentMethod': paymentMethod,
      'description': description,
      'isIncome': isIncome,
      'quantity': quantity,
      'pricePerItem': pricePerItem,
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
