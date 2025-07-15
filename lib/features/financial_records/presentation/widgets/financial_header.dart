import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/financial_records/presentation/widgets/financial_header_bg.dart';

class FinancialHeader extends StatelessWidget {
  final String? userName;
  final double screenWidth;
  final bool showGreeting;

  const FinancialHeader({
    super.key,
    required this.screenWidth,
    this.userName,
    this.showGreeting = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Orange Background with Rounded Bottom
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: screenWidth,
            height: 179,
            decoration: const ShapeDecoration(
              color: Color(0xFFFFB74D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
        ),

        // Background Pattern using SVG
        Positioned(
          left: 0,
          top: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: SizedBox(
              width: screenWidth,
              height: 278,
              child: const FinancialHeaderBg(
                height: 278,
                child: SizedBox.shrink(),
              ),
            ),
          ),
        ),

        // Welcome Text - Only show if showGreeting is true
        if (showGreeting)
          Positioned(
            left: 24,
            top: 68,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo,',
                  style: AppTextStyles.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.80,
                  ),
                ),
                Text(
                  userName ?? 'Admin Iampelgading',
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
