import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/transaction_detail_page.dart';

class UnifiedTransactionItem extends StatelessWidget {
  final String title;
  final String time;
  final String date;
  final double amount;
  final IconData icon;
  final VoidCallback? onTap;
  final Map<String, dynamic>? transactionData;

  const UnifiedTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.icon,
    this.onTap,
    this.transactionData,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    final Color amountColor =
        isIncome ? const Color(0xFF40B029) : const Color(0xFFFF4545);

    return Container(
      width: double.infinity,
      height: 56,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: InkWell(
        onTap: onTap ?? () => _navigateToDetail(context),
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

            const SizedBox(width: 16),

            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.h4.copyWith(
                      color: const Color(0xFF1F2C40),
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
                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xFF6A788C),
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
                      Text(
                        date,
                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xFF6A788C),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Amount
            Row(
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
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 12,
                    color: amountColor,
                  ),
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    CurrencyFormatter.format(amount.abs()),
                    style: AppTextStyles.h4.copyWith(
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context) {
    final transaction =
        transactionData ??
        {
          'title': title,
          'time': time,
          'date': date,
          'amount': amount,
          'icon': icon,
        };

    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: TransactionDetailPage(
        transaction: transaction,
        isExpense: amount < 0,
      ),
      withNavBar: false, // This hides the bottom navbar
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
