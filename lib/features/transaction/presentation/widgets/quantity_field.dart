import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

class QuantityField extends StatelessWidget {
  final TransactionProvider provider;

  const QuantityField({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Kuantitas',
          style: const TextStyle(
            color: Color(0xFF343434),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 4),

        // Quantity field with increment/decrement buttons
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field Content with buttons
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Decrement button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: provider.decrementQuantity,
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.remove,
                            color: Color(0xFF343434),
                            size: 18,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Text field
                    Expanded(
                      child: TextFormField(
                        controller: provider.quantityController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF343434),
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
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
                          filled: true,
                          fillColor: AppColors.background[200],
                        ),
                        validator: provider.validateQuantity,
                        onChanged: provider.updateQuantityFromText,
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Increment button
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: provider.incrementQuantity,
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.add,
                            color: Color(0xFF343434),
                            size: 18,
                          ),
                        ),
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
    );
  }
}
