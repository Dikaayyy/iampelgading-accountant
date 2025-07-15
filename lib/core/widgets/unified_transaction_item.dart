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
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Map<String, dynamic>? transactionData;
  final bool showMenu;

  const UnifiedTransactionItem({
    super.key,
    required this.title,
    required this.time,
    required this.date,
    required this.amount,
    required this.icon,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.transactionData,
    this.showMenu = true,
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
      child: GestureDetector(
        onTap: onTap ?? () => _navigateToDetail(context),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left side - Icon and Transaction Details
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 158,
                      child: Text(
                        title,
                        style: AppTextStyles.h4.copyWith(
                          color: const Color(0xFF1F2C40),
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          time,
                          style: AppTextStyles.body.copyWith(
                            color: const Color(0xFF6A788C),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 1,
                          height: 13,
                          decoration: const BoxDecoration(
                            color: Color(0xFF6A788D),
                          ),
                        ),
                        const SizedBox(width: 10),
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
              ],
            ),

            // Right side - Amount and Menu
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Amount
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 128),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        child: Icon(
                          isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                          size: 20,
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
                ),

                // Menu Button
                if (showMenu) ...[
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit' && onEdit != null) {
                          onEdit!();
                        } else if (value == 'delete' && onDelete != null) {
                          onDelete!();
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: const Color(0xFF343434),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: const Color(0xFF343434),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Divider line
                            PopupMenuItem(
                              enabled: false,
                              height: 1,
                              child: Container(
                                width: double.infinity,
                                height: 1,
                                color: const Color(0xFFE5E5E5),
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: const Color(0xFFEF4444),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Hapus',
                                      style: TextStyle(
                                        color: const Color(0xFFEF4444),
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                      color: const Color(0xFFFDFCFA),
                      surfaceTintColor: Colors.transparent,
                      shadowColor: const Color(0x3FB4ADAD),
                      elevation: 10.90,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      icon: const Icon(
                        Icons.more_vert,
                        size: 20,
                        color: Color(0xFF6A788C),
                      ),
                      padding: EdgeInsets.zero,
                      splashRadius: 1,
                    ),
                  ),
                ],
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
