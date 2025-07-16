import 'package:flutter/material.dart';
import 'package:iampelgading/features/transaction/presentation/pages/transaction_page.dart';
import 'package:provider/provider.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

class NavigationHelper {
  static const int homeIndex = 0;
  static const int dashboardIndex = 1;
  static const int addTransactionIndex = 2;
  static const int walletIndex = 3;
  static const int profileIndex = 4;

  static void navigateToHome() {
    NavigationService().navigateToTab(homeIndex);
  }

  static void navigateToDashboard() {
    NavigationService().navigateToTab(dashboardIndex);
  }

  static void navigateToAddTransaction() {
    NavigationService().navigateToTab(addTransactionIndex);
  }

  static void navigateToWallet() {
    NavigationService().navigateToTab(walletIndex);
  }

  static void navigateToProfile() {
    NavigationService().navigateToTab(profileIndex);
  }

  // New method for showing floating menu
  static void showFloatingTransactionMenu(
    BuildContext context,
    VoidCallback onClose,
  ) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => FloatingTransactionMenu(onClose: onClose),
    );
  }

  // Navigate to add transaction page - using existing provider
  static void navigateToAddTransactionPage(
    BuildContext context, {
    required bool isIncome,
  }) {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: TransactionPage(isIncome: isIncome),
      withNavBar: false,
      pageTransitionAnimation: PageTransitionAnimation.cupertino,
    );
  }
}

class FloatingTransactionMenu extends StatelessWidget {
  final VoidCallback onClose;

  const FloatingTransactionMenu({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: onClose,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              // Positioned above the bottom navbar
              Positioned(
                bottom: 90, // Adjust based on your navbar height
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width - 48,
                    constraints: const BoxConstraints(maxWidth: 364),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Main menu container
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            shadows: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Income button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    onClose();
                                    NavigationHelper.navigateToAddTransactionPage(
                                      context,
                                      isIncome: true,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_downward,
                                          color: const Color(0xFF40B029),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Pemasukkan',
                                          style: AppTextStyles.h4.copyWith(
                                            color: const Color(0xFF343434),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                              // Divider
                              Container(
                                width: double.infinity,
                                height: 1,
                                color: Colors.grey.withOpacity(0.2),
                              ),

                              // Expense button
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    onClose();
                                    NavigationHelper.navigateToAddTransactionPage(
                                      context,
                                      isIncome: false,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.arrow_upward,
                                          color: const Color(0xFFFF4545),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'Pengeluaran',
                                          style: AppTextStyles.h4.copyWith(
                                            color: const Color(0xFF343434),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Cancel button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onClose,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(16),
                              decoration: ShapeDecoration(
                                color: AppColors.error[50],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Batal',
                                    style: AppTextStyles.h4.copyWith(
                                      color: AppColors.error[600],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
