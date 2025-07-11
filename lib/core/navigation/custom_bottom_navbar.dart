import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/navigation/navigation_service.dart';
import 'package:iampelgading/core/navigation/navigation_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iampelgading/core/assets/app_assets.dart';

class CustomBottomNavbar extends StatefulWidget {
  final List<Widget> screens;

  const CustomBottomNavbar({super.key, required this.screens});

  @override
  State<CustomBottomNavbar> createState() => _CustomBottomNavbarState();
}

class _CustomBottomNavbarState extends State<CustomBottomNavbar> {
  bool _isFloatingMenuVisible = false;
  int _previousIndex = 0; // Track the previous selected index

  @override
  void initState() {
    super.initState();
    // Set initial previous index to current controller index
    _previousIndex = NavigationService().controller.index;
    // Listen to controller changes to track current index
    NavigationService().controller.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    NavigationService().controller.removeListener(_onTabChanged);
    super.dispose();
  }

  void _onTabChanged() {
    final currentIndex = NavigationService().controller.index;
    // Only update _previousIndex if it's not the add transaction index
    // and if it's different from the current _previousIndex
    if (currentIndex != NavigationHelper.addTransactionIndex &&
        currentIndex != _previousIndex) {
      setState(() {
        _previousIndex = currentIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PersistentTabView(
          context,
          controller: NavigationService().controller,
          screens: widget.screens,
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
              screenTransitionAnimationType:
                  ScreenTransitionAnimationType.fadeIn,
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
              // Prevent the default navigation by immediately jumping back
              // This prevents the flicker
              NavigationService().controller.jumpToTab(_previousIndex);

              // Show floating menu
              _showFloatingMenu();

              // Return to prevent further processing
              return;
            }

            // For other tabs, update _previousIndex and allow normal navigation
            setState(() {
              _previousIndex = index;
            });
          },
        ),

        // Floating menu overlay
        if (_isFloatingMenuVisible)
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideFloatingMenu,
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: Stack(
                  children: [
                    Positioned(
                      bottom: 90, // Adjust based on your navbar height
                      left: 24,
                      right: 24,
                      child: _buildFloatingMenu(),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFloatingMenu() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 364),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
              children: [
                // Income button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _hideFloatingMenu();
                      _navigateToAddTransaction(isIncome: true);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pemasukkan',
                            style: TextStyle(
                              color: const Color(0xFF343434),
                              fontSize: 16,
                              fontFamily: 'Poppins',
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
                      _hideFloatingMenu();
                      _navigateToAddTransaction(isIncome: false);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Pengeluaran',
                            style: TextStyle(
                              color: const Color(0xFF343434),
                              fontSize: 16,
                              fontFamily: 'Poppins',
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
        ],
      ),
    );
  }

  void _showFloatingMenu() {
    setState(() {
      _isFloatingMenuVisible = true;
    });
  }

  void _hideFloatingMenu() {
    setState(() {
      _isFloatingMenuVisible = false;
    });
  }

  void _navigateToAddTransaction({required bool isIncome}) {
    NavigationHelper.navigateToAddTransactionPage(context, isIncome: isIncome);
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
          child: Icon(
            _isFloatingMenuVisible ? Icons.close : Icons.add,
            color: Colors.white,
            size: 28,
          ),
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
