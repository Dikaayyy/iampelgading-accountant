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
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: GestureDetector(
        onTap: onTap ?? () => _navigateToDetail(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon - Fixed width
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

            // Transaction Details - Flexible
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

                  const SizedBox(height: 2),

                  // Time and Date Row - Responsive
                  Row(
                    children: [
                      Text(
                        time,
                        style: AppTextStyles.body.copyWith(
                          color: const Color(0xFF6A788C),
                          fontSize: 12,
                        ),
                      ),

                      // Separator
                      Container(
                        width: 1,
                        height: 10,
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: const BoxDecoration(
                          color: Color(0xFF6A788D),
                        ),
                      ),

                      // Date - Flexible to prevent overflow
                      Flexible(
                        child: Text(
                          date,
                          style: AppTextStyles.body.copyWith(
                            color: const Color(0xFF6A788C),
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Amount and Menu - Fixed width based on screen size
            Container(
              constraints: BoxConstraints(
                maxWidth: screenWidth * 0.35, // 35% of screen width
                minWidth:
                    screenWidth > 350
                        ? 120
                        : 100, // Minimum width based on screen
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Amount Section - Flexible within constraints
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Direction Icon
                        Icon(
                          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 16,
                          color: isIncome ? Colors.green : Colors.red,
                        ),

                        const SizedBox(width: 4),

                        // Amount Text - Flexible
                        Flexible(
                          child: Text(
                            CurrencyFormatter.format(amount.abs()),
                            style: AppTextStyles.h4.copyWith(
                              color: amountColor,
                              fontWeight: FontWeight.w700,
                              fontSize:
                                  screenWidth > 350
                                      ? 14
                                      : 12, // Responsive font size
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menu Button - Only show if there's space and showMenu is true
                  if (showMenu && screenWidth > 320) ...[
                    const SizedBox(width: 8),
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
                                    children: [
                                      const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Color(0xFF343434),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Edit',
                                        style: TextStyle(
                                          color: Color(0xFF343434),
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
                              const PopupMenuItem(
                                enabled: false,
                                height: 1,
                                child: Divider(
                                  height: 1,
                                  color: Color(0xFFE5E5E5),
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
                                    children: [
                                      const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Color(0xFFEF4444),
                                      ),
                                      const SizedBox(width: 10),
                                      const Text(
                                        'Hapus',
                                        style: TextStyle(
                                          color: Color(0xFFEF4444),
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
                          size: 18,
                          color: Color(0xFF6A788C),
                        ),
                        padding: EdgeInsets.zero,
                        splashRadius: 1,
                      ),
                    ),
                  ],
                ],
              ),
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
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}
