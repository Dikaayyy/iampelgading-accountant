import 'package:flutter/material.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String category;
  final String time;
  final String date;
  final double amount;
  final IconData? categoryIcon;
  final Color? categoryIconColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const TransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.time,
    required this.date,
    required this.amount,
    this.categoryIcon,
    this.categoryIconColor,
    this.onTap,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      margin: margin,
      padding: padding ?? const EdgeInsets.symmetric(vertical: 7),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadows: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Category Icon
                SizedBox(
                  width: 32,
                  height: 32,

                  child: Icon(
                    categoryIcon ??
                        (isIncome ? Icons.arrow_downward : Icons.arrow_upward),
                    size: 20,
                    color:
                        categoryIconColor ??
                        (isIncome ? Colors.green : Colors.red),
                  ),
                ),

                const SizedBox(width: 16),

                // Transaction Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        title,
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF1F2C40),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      // Time and Date Row
                      Row(
                        children: [
                          // Time
                          Text(
                            time,
                            style: AppTextStyles.body.copyWith(
                              color: const Color(0xFF6A788C),
                            ),
                          ),

                          // Separator
                          Container(
                            width: 1,
                            height: 13,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: Color(0xFF6A788D),
                            ),
                          ),

                          // Date - Flexible to handle different screen sizes
                          Flexible(
                            child: Text(
                              date,
                              style: AppTextStyles.body.copyWith(
                                color: const Color(0xFF6A788C),
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

                // Amount Section
                _buildAmountSection(screenWidth, isIncome),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAmountSection(double screenWidth, bool isIncome) {
    // Responsive width constraint based on screen size
    final maxWidth = screenWidth > 400 ? 150.0 : 120.0;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Amount Direction Icon
          SizedBox(
            width: 20,
            height: 20,

            child: Icon(
              isIncome ? Icons.arrow_upward : Icons.arrow_downward,
              size: 20,
              color: isIncome ? Colors.green : Colors.red,
            ),
          ),

          const SizedBox(width: 4),

          // Amount Text
          Flexible(
            child: Text(
              CurrencyFormatter.format(amount.abs()),
              style: AppTextStyles.h4.copyWith(
                color: isIncome ? const Color(0xFF40B029) : Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// Extension widget for compact transaction card (smaller version)
class CompactTransactionCard extends StatelessWidget {
  final String title;
  final String category;
  final String date;
  final double amount;
  final IconData? categoryIcon;
  final VoidCallback? onTap;

  const CompactTransactionCard({
    super.key,
    required this.title,
    required this.category,
    required this.date,
    required this.amount,
    this.categoryIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = amount > 0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Row(
            children: [
              // Category Icon
              SizedBox(
                width: 28,
                height: 28,
                child: Icon(
                  categoryIcon ??
                      (isIncome ? Icons.arrow_upward : Icons.arrow_downward),
                  size: 20,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),

              const SizedBox(width: 12),

              // Transaction Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$category • $date',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Amount
              Text(
                CurrencyFormatter.format(amount.abs()),
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isIncome ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
