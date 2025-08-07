import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/core/widgets/minimal_text_field.dart';

class DateTimePicker extends StatefulWidget {
  final TransactionProvider provider;

  const DateTimePicker({super.key, required this.provider});

  @override
  State<DateTimePicker> createState() => _DateTimePickerState();
}

class _DateTimePickerState extends State<DateTimePicker> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update waktu real-time setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        final now = TimeOfDay.now();
        widget.provider.updateTime(now, context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Date picker
        MinimalTextField(
          label: 'Tanggal',
          hintText: 'Pilih tanggal',
          controller: widget.provider.dateController,
          readOnly: true,
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.base,
          ),
          onTap: () => _selectDate(context),
        ),

        const SizedBox(height: 16),

        // Time picker - Read only dengan waktu real-time
        MinimalTextField(
          label: 'Waktu',
          hintText: 'Waktu otomatis',
          controller: widget.provider.timeController,
          readOnly: true,
          enabled: false, // Disable field agar tidak bisa diklik
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.provider.selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(
            context,
          ).copyWith(dialogBackgroundColor: AppColors.white),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      widget.provider.updateDate(pickedDate);
    }
  }
}
