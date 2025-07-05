import 'package:flutter/material.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';

class FinancialTransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final double amount;
  final IconData icon;
  final bool isExpense;
  final VoidCallback? onTap;

  const FinancialTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.icon,
    required this.isExpense,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color amountColor =
        isExpense ? const Color(0xFFFF4545) : const Color(0xFF40B029);

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            // Icon
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: amountColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 16, color: amountColor),
            ),

            const SizedBox(width: 24),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF1F2C40),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          color: Color(0xFF6A788C),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Container(
                        width: 1,
                        height: 13,
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6A788D),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          date,
                          style: const TextStyle(
                            color: Color(0xFF6A788C),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Amount
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 128),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: amountColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      isExpense ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: amountColor,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      CurrencyFormatter.format(amount),
                      style: TextStyle(
                        color: amountColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
