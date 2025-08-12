import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';

class BalanceCard extends StatelessWidget {
  final double balance;
  final double income;
  final double expense;
  final VoidCallback? onToggleVisibility;
  final bool isVisible;

  // New properties for slider functionality
  final bool showSlider;
  final int selectedIndex; // 0 = All time, 1 = This month
  final ValueChanged<int>? onSliderChanged;
  final double? monthlyBalance;
  final double? monthlyIncome;
  final double? monthlyExpense;

  const BalanceCard({
    super.key,
    required this.balance,
    required this.income,
    required this.expense,
    this.onToggleVisibility,
    this.isVisible = true,
    this.showSlider = false,
    this.selectedIndex = 0,
    this.onSliderChanged,
    this.monthlyBalance,
    this.monthlyIncome,
    this.monthlyExpense,
  });

  @override
  Widget build(BuildContext context) {
    // Determine which data to show based on selected index
    final currentBalance = selectedIndex == 0 ? balance : (monthlyBalance ?? 0);
    final currentIncome = selectedIndex == 0 ? income : (monthlyIncome ?? 0);
    final currentExpense = selectedIndex == 0 ? expense : (monthlyExpense ?? 0);

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
          // Slider (if enabled)
          if (showSlider) ...[_buildSlider(), const SizedBox(height: 16)],

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
                    isVisible
                        ? CurrencyFormatter.format(currentBalance)
                        : '••••••••',
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
                    isVisible
                        ? CurrencyFormatter.format(currentIncome)
                        : '••••••••',
                    style: AppTextStyles.h3.copyWith(
                      color: const Color(0xFF202D41),
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),

              // Expense - Aligned to the right
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                      const SizedBox(width: 8),
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
                    isVisible
                        ? CurrencyFormatter.format(currentExpense)
                        : '••••••••',
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

  Widget _buildSlider() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: const Color(0xFFF5F5F5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => onSliderChanged?.call(0),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: ShapeDecoration(
                  color: selectedIndex == 0 ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows:
                      selectedIndex == 0
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  'Semua Waktu',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color:
                        selectedIndex == 0
                            ? const Color(0xFF202D41)
                            : const Color(0xFF6A788C),
                    fontWeight:
                        selectedIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onSliderChanged?.call(1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: ShapeDecoration(
                  color: selectedIndex == 1 ? Colors.white : Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  shadows:
                      selectedIndex == 1
                          ? [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ]
                          : null,
                ),
                child: Text(
                  'Bulan Ini',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.body.copyWith(
                    color:
                        selectedIndex == 1
                            ? const Color(0xFF202D41)
                            : const Color(0xFF6A788C),
                    fontWeight:
                        selectedIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
