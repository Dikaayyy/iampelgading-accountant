import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final VoidCallback? onToggleVisibility;
  final bool isVisible;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.onToggleVisibility,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        shadows: [
          BoxShadow(
            color: const Color(0x3FB4ADAD),
            blurRadius: 10.90,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Balance Section
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Saldo',
                    style: AppTextStyles.h4.copyWith(
                      color: const Color(0xFF202D41),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    isVisible ? CurrencyFormatter.format(balance) : '••••••••',
                    style: AppTextStyles.h1.copyWith(
                      color: const Color(0xFF202D41),
                      letterSpacing: -1.50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: onToggleVisibility,
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        isVisible ? Icons.visibility : Icons.visibility_off,
                        size: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // Income and Expense Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Income
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,

                        child: const Icon(
                          Icons.arrow_downward,
                          size: 20,
                          color: Color(0xFF40B029),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pemasukan',
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF40B029),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isVisible ? CurrencyFormatter.format(income) : '••••••••',
                    style: AppTextStyles.h3.copyWith(
                      color: const Color(0xFF202D41),
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),

              // Expense
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: const Icon(
                          Icons.arrow_upward,
                          size: 20,
                          color: Color(0xFFFF4545),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Pengeluaran',
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFFFF4545),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.80,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    isVisible ? CurrencyFormatter.format(expense) : '••••••••',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.h3.copyWith(
                      color: const Color(0xFF202D41),
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
