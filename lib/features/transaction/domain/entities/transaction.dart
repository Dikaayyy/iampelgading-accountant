class Transaction {
  final String? id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final String paymentMethod;
  final String description;
  final bool isIncome;
  final int quantity;
  final double pricePerItem;

  Transaction({
    this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.paymentMethod,
    required this.description,
    required this.isIncome,
    required this.quantity,
    required this.pricePerItem,
  });

  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? category,
    DateTime? date,
    String? paymentMethod,
    String? description,
    bool? isIncome,
    int? quantity,
    double? pricePerItem,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      description: description ?? this.description,
      isIncome: isIncome ?? this.isIncome,
      quantity: quantity ?? this.quantity,
      pricePerItem: pricePerItem ?? this.pricePerItem,
    );
  }
}
