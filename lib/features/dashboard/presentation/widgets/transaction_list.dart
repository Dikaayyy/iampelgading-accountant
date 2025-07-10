import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/unified_transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(Map<String, dynamic>)? onTransactionTap;

  const TransactionList({
    super.key,
    required this.transactions,
    this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < transactions.length; i++) ...[
          UnifiedTransactionItem(
            title: transactions[i]['title'] as String,
            time: transactions[i]['time'] as String,
            date: transactions[i]['date'] as String,
            amount: transactions[i]['amount'] as double,
            icon: transactions[i]['icon'] as IconData,
            transactionData: transactions[i],
            onTap:
                onTransactionTap != null
                    ? () => onTransactionTap!(transactions[i])
                    : null,
          ),
          if (i < transactions.length - 1)
            Opacity(
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
        ],
        const SizedBox(height: 24),
      ],
    );
  }
}
