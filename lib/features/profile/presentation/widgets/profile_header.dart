import 'package:flutter/material.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header_background.dart';

class ProfileHeader extends StatelessWidget {
  final double screenWidth;

  const ProfileHeader({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 278,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: screenWidth,
              height: 278,
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

          Positioned(
            left: 0,
            top: 8,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: SizedBox(
                width: screenWidth,
                height: 278,
                child: const DashboardHeaderBackground(
                  height: 278,
                  child: SizedBox.shrink(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
