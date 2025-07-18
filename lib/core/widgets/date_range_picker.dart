import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/widgets/minimal_text_field.dart';
import 'package:intl/intl.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(DateTime startDate, DateTime endDate)? onDateRangeSelected;

  const DateRangePicker({
    super.key,
    this.initialStartDate,
    this.initialEndDate,
    this.onDateRangeSelected,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  late TextEditingController _startDateController;
  late TextEditingController _endDateController;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _startDate =
        widget.initialStartDate ??
        DateTime.now().subtract(const Duration(days: 30));
    _endDate = widget.initialEndDate ?? DateTime.now();

    _startDateController = TextEditingController();
    _endDateController = TextEditingController();

    // Use post frame callback to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
    });
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    if (_startDate != null) {
      _startDateController.text = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(_startDate!);
    }
    if (_endDate != null) {
      _endDateController.text = DateFormat(
        'dd MMMM yyyy',
        'id_ID',
      ).format(_endDate!);
    }

    // Notify parent if both dates are selected
    if (_startDate != null &&
        _endDate != null &&
        widget.onDateRangeSelected != null) {
      // Use post frame callback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onDateRangeSelected!(_startDate!, _endDate!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Start Date picker
        MinimalTextField(
          label: 'Tanggal Mulai',
          hintText: 'Pilih tanggal mulai',
          controller: _startDateController,
          readOnly: true,
          backgroundColor: Colors.white, // Tambahkan ini
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.base,
          ),
          onTap: () => _selectStartDate(context),
        ),

        const SizedBox(height: 16),

        // End Date picker
        MinimalTextField(
          label: 'Tanggal Akhir',
          hintText: 'Pilih tanggal akhir',
          controller: _endDateController,
          readOnly: true,
          backgroundColor: Colors.white, // Tambahkan ini
          suffixIcon: const Icon(
            Icons.calendar_month_rounded,
            color: AppColors.base,
          ),
          onTap: () => _selectEndDate(context),
        ),
      ],
    );
  }

  void _selectStartDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: _endDate ?? DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _startDate = pickedDate;
      });
      _updateControllers();
    }
  }

  void _selectEndDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        _endDate = pickedDate;
      });
      _updateControllers();
    }
  }
}
