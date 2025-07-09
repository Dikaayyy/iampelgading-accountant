import 'package:flutter/material.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';

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

  static void showAddTransactionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Center(
              child: Text(
                'Modal Tambah Transaksi',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
    );
  }
}
