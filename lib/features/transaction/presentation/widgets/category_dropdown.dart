import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';

class CategoryDropdown extends StatelessWidget {
  final TransactionProvider provider;
  final bool isIncome;

  const CategoryDropdown({
    super.key,
    required this.provider,
    required this.isIncome,
  });

  @override
  Widget build(BuildContext context) {
    final categories =
        isIncome ? provider.incomeCategories : provider.expenseCategories;

    return SizedBox(
      width: 364,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Text(
            'Kategori',
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
                          value:
                              provider.categoryController.text.isEmpty
                                  ? null
                                  : provider.categoryController.text,
                          decoration: InputDecoration(
                            hintText: 'Pilih kategori',
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
                              categories.map((category) {
                                return DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(
                                    category,
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
                              provider.categoryController.text = value;
                            }
                          },
                          validator: provider.validateCategory,
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
