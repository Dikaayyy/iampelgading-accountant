import 'package:flutter/material.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_transaction_item.dart';

class FinancialTransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isExpense;

  const FinancialTransactionList({
    super.key,
    required this.transactions,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ListView.separated(
        itemCount: transactions.length,
        separatorBuilder:
            (context, index) => Opacity(
              opacity: 0.10,
              child: Container(
                width: double.infinity,
                height: 1,
                margin: const EdgeInsets.symmetric(vertical: 6),
                decoration: ShapeDecoration(
                  color: const Color(0xFF6A788D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return FinancialTransactionItem(
            title: transaction['title'] as String,
            time: transaction['time'] as String,
            date: transaction['date'] as String,
            amount: transaction['amount'] as double,
            icon: transaction['icon'] as IconData,
            isExpense: isExpense,
            onTap: () {
              // Handle transaction tap
            },
          );
        },
      ),
    );
  }
}
