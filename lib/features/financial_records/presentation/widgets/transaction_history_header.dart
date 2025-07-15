import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iampelgading/core/assets/app_assets.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class TransactionHistoryHeader extends StatelessWidget {
  final VoidCallback? onDownloadPressed;

  const TransactionHistoryHeader({super.key, this.onDownloadPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Riwayat Transaksi',
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF202D41),
              fontWeight: FontWeight.w500,
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDownloadPressed,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 30,
                height: 30,
                decoration: ShapeDecoration(
                  color: AppColors.warning[50]?.withOpacity(0.45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.download,
                    width: 16,
                    height: 16,
                    colorFilter: ColorFilter.mode(
                      AppColors.base,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
