import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/core/widgets/minimal_text_field.dart';

class DateTimePicker extends StatelessWidget {
  final TransactionProvider provider;

  const DateTimePicker({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date picker
        MinimalTextField(
          label: 'Tanggal',
          hintText: 'Pilih tanggal',
          controller: provider.dateController,
          readOnly: true,
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.base,
          ),
          onTap: () => _selectDate(context),
        ),

        const SizedBox(height: 16),

        // Time picker
        MinimalTextField(
          label: 'Waktu',
          hintText: 'Pilih waktu',
          controller: provider.timeController,
          readOnly: true,
          onTap: () => _selectTime(context),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null) {
      provider.updateDate(pickedDate);
    }
  }

  void _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: provider.selectedTime,
    );

    if (pickedTime != null) {
      provider.updateTime(pickedTime, context);
    }
  }
}
