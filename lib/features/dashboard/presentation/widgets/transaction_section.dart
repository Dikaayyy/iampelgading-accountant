import 'package:flutter/material.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/transaction_list.dart';

class TransactionSection extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final bool isLoading;
  final VoidCallback? onViewAllTap;
  final Function(Map<String, dynamic>)? onTransactionTap;

  const TransactionSection({
    super.key,
    required this.transactions,
    this.isLoading = false,
    this.onViewAllTap,
    this.onTransactionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Transaksi Terbaru',
                style: TextStyle(
                  color: Color(0xFF202D41),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: onViewAllTap,
                child: const Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: Color(0xFF64B5F6),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Transaction List
          if (isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: CircularProgressIndicator(),
              ),
            )
          else
            TransactionList(
              transactions: transactions,
              onTransactionTap: onTransactionTap,
            ),
        ],
      ),
    );
  }
}
