import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

class PaymentMethodDropdown extends StatelessWidget {
  final TransactionProvider provider;

  const PaymentMethodDropdown({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 364,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Metode Pembayaran',
            style: const TextStyle(
              color: Color(0xFF343434),
              fontSize: 16,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 4),

          SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dropdown Content
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: provider.selectedPaymentMethod,
                          decoration: InputDecoration(
                            hintText: 'Pilih metode pembayaran',
                            hintStyle: TextStyle(
                              color: AppColors.neutral[50],
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedErrorBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            isDense: true,
                            filled: true,
                            fillColor: AppColors.background[200],
                          ),
                          style: TextStyle(
                            color: AppColors.neutral[200],
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: AppColors.neutral[50],
                          ),
                          items:
                              provider.paymentMethods.map((method) {
                                return DropdownMenuItem<String>(
                                  value: method,
                                  child: Text(
                                    method,
                                    style: TextStyle(
                                      color: AppColors.neutral[200],
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              provider.updatePaymentMethod(value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Bottom Border Line
                Container(
                  width: double.infinity,
                  height: 1,
                  decoration: const ShapeDecoration(
                    color: Color(0xFFCACACA),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        strokeAlign: BorderSide.strokeAlignCenter,
                        color: Color(0xFFEBEBEB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
