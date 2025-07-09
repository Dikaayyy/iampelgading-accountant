import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class FinancialTabBar extends StatelessWidget {
  final TabController tabController;

  const FinancialTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(width: 1, color: Color(0x196A788D))),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 2, color: Color(0xFFFFB74D)),
          ),
        ),
        labelColor: const Color(0xFFFFB74D),
        unselectedLabelColor: const Color(0xFF202D41),
        labelStyle: AppTextStyles.h4.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: AppTextStyles.h4.copyWith(
          fontWeight: FontWeight.w600,
        ),
        tabs: const [Tab(text: 'Pengeluaran'), Tab(text: 'Pemasukan')],
      ),
    );
  }
}
