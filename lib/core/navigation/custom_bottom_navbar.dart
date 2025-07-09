import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';
import 'package:iampelgading/core/navigation/navigation_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iampelgading/core/assets/app_assets.dart';

class CustomBottomNavbar extends StatelessWidget {
  final List<Widget> screens;

  const CustomBottomNavbar({super.key, required this.screens});

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: NavigationService().controller,
      screens: screens,
      items: _buildNavItems(context),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: false,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppColors.white,
      isVisible: true,
      animationSettings: const NavBarAnimationSettings(
        navBarItemAnimation: ItemAnimationSettings(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        ),
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          animateTabTransition: false,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
        ),
      ),
      confineToSafeArea: true,
      navBarHeight: 70,
      navBarStyle: NavBarStyle.style15,
      decoration: NavBarDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
        colorBehindNavBar: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      onItemSelected: (index) {
        if (index == NavigationHelper.addTransactionIndex) {
          NavigationHelper.showAddTransactionModal(context);
        }
      },
    );
  }

  List<PersistentBottomNavBarItem> _buildNavItems(BuildContext context) {
    return [
      // Home
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.home,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(AppColors.base, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.home,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(
            AppColors.neutral[100]!,
            BlendMode.srcIn,
          ),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.neutral[100],
        iconSize: 26,
      ),

      // Dashboard (Graph)
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.graph,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(AppColors.base, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.graph,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(
            AppColors.neutral[100]!,
            BlendMode.srcIn,
          ),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.neutral[100],
        iconSize: 26,
      ),

      // Add Transaction (Center button)
      PersistentBottomNavBarItem(
        icon: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.base,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.base.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.base,
        iconSize: 50,
      ),

      // Wallet
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.wallet,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(AppColors.base, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.wallet,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(
            AppColors.neutral[100]!,
            BlendMode.srcIn,
          ),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.neutral[100],
        iconSize: 26,
      ),

      // Profile
      PersistentBottomNavBarItem(
        icon: SvgPicture.asset(
          AppAssets.person,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(AppColors.base, BlendMode.srcIn),
        ),
        inactiveIcon: SvgPicture.asset(
          AppAssets.person,
          width: 26,
          height: 26,
          colorFilter: ColorFilter.mode(
            AppColors.neutral[100]!,
            BlendMode.srcIn,
          ),
        ),
        activeColorPrimary: AppColors.base,
        inactiveColorPrimary: AppColors.neutral[100],
        iconSize: 26,
      ),
    ];
  }
}
