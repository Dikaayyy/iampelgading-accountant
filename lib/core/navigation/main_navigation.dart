import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';
import 'package:iampelgading/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:iampelgading/features/financial_records/presentation/pages/financial_records_page.dart';
import 'package:iampelgading/features/profile/presentation/pages/profile_page.dart';

class MainNavigation extends StatelessWidget {
  const MainNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: NavigationService().controller,
      screens: _buildScreens(),
      items: _navBarsItems(context),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppColors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: kBottomNavigationBarHeight,
      navBarStyle: NavBarStyle.style15,
    );
  }

  List<Widget> _buildScreens() {
    return [
      const DashboardPage(),
      const FinancialRecordsPage(),
      const _AddTransactionPage(),
      const _WalletPage(),
      const ProfilePage(), // Replace _ProfilePage with ProfilePage
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(BuildContext context) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home_outlined),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: const Color(0xFF6A788C),
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.bar_chart_outlined),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: const Color(0xFF6A788C),
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.base,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 24),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.base,
        iconSize: 40,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.account_balance_wallet_outlined),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: const Color(0xFF6A788C),
        iconSize: 24,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person_outline),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: const Color(0xFF6A788C),
        iconSize: 24,
      ),
    ];
  }
}

class ScreenTransitionAnimation {}

// Placeholder pages - replace with actual implementations
class _AddTransactionPage extends StatelessWidget {
  const _AddTransactionPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Transaksi'),
        backgroundColor: AppColors.base,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Tambah Transaksi', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

class _WalletPage extends StatelessWidget {
  const _WalletPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dompet'),
        backgroundColor: AppColors.base,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Text('Halaman Dompet', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
