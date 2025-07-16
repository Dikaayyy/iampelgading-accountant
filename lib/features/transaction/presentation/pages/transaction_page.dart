import 'package:flutter/material.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/managers/snackbar_manager.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/minimal_text_field.dart';
import 'package:iampelgading/features/transaction/presentation/providers/transaction_provider.dart';
import 'package:iampelgading/features/transaction/presentation/widgets/category_dropdown.dart';
import 'package:iampelgading/features/transaction/presentation/widgets/date_time_picker.dart';
import 'package:iampelgading/features/transaction/presentation/widgets/payment_method.dart';
import 'package:iampelgading/features/transaction/presentation/widgets/quantity_field.dart';
import 'package:provider/provider.dart';

class TransactionPage extends StatefulWidget {
  final bool isIncome;

  const TransactionPage({super.key, required this.isIncome});

  @override
  State<TransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<TransactionPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize form only once when page is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final provider = context.read<TransactionProvider>();
        provider.resetForm();
        provider.updateDate(DateTime.now());
        provider.updateTime(TimeOfDay.now(), context);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background[200],
      appBar: CustomAppBar(
        title: widget.isIncome ? 'Tambah Pemasukan' : 'Tambah Pengeluaran',
        backgroundColor: const Color(0xFFFFB74D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),

                        // Date and Time pickers
                        DateTimePicker(provider: provider),

                        const SizedBox(height: 16),

                        // Category dropdown
                        CategoryDropdown(
                          provider: provider,
                          isIncome: widget.isIncome,
                        ),

                        const SizedBox(height: 16),

                        // Price per item field
                        MinimalTextField(
                          label: 'Harga per Item',
                          hintText: 'Masukkan harga per item',
                          controller: provider.priceController,
                          keyboardType: TextInputType.number,
                          validator: provider.validatePrice,
                          onChanged: (_) => provider.updateQuantityOrPrice(),
                        ),

                        const SizedBox(height: 16),

                        // Quantity field
                        QuantityField(provider: provider),

                        const SizedBox(height: 16),

                        // Payment method dropdown
                        PaymentMethodDropdown(provider: provider),

                        const SizedBox(height: 16),

                        // Description field
                        MinimalTextField(
                          label: 'Keterangan',
                          hintText: 'Masukkan keterangan transaksi',
                          controller: provider.descriptionController,
                          maxLines: 3,
                          minLines: 3,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Total amount display (moved to bottom)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Total Harga',
                        style: const TextStyle(
                          color: Color(0xFF343434),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(provider.totalAmount),
                        style: TextStyle(
                          color: AppColors.neutral[50],
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          height: 1.50,
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom buttons
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SecondaryButton(
                          text: 'Batal',
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: PrimaryButton(
                          text: 'Simpan',
                          isLoading: provider.isLoading,
                          onPressed: () => _saveTransaction(provider),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _saveTransaction(TransactionProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await provider.saveTransaction(isIncome: widget.isIncome);

        if (context.mounted) {
          SnackbarManager.showSuccess(
            context: context,
            title: 'Berhasil',
            message:
                widget.isIncome
                    ? 'Pemasukan berhasil disimpan'
                    : 'Pengeluaran berhasil disimpan',
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarManager.showError(
            context: context,
            error: e,
            customTitle: 'Gagal Menyimpan',
          );
        }
      }
    }
  }
}
