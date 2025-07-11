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
    return TransactionModel(
      id: json['id'],
      title: json['title'],
      amount: json['amount'].toDouble(),
      category: json['category'],
      date: DateTime.parse(json['date']),
      paymentMethod: json['paymentMethod'],
      description: json['description'],
      isIncome: json['isIncome'],
      quantity: json['quantity'],
      pricePerItem: json['pricePerItem'].toDouble(),
    );
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
