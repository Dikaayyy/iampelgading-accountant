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

class EditTransactionPage extends StatefulWidget {
  final Map<String, dynamic> transaction;
  final bool isIncome;

  const EditTransactionPage({
    super.key,
    required this.transaction,
    required this.isIncome,
  });

  @override
  State<EditTransactionPage> createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // Initialize form with transaction data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized) {
        final provider = context.read<TransactionProvider>();
        // Populate form with existing transaction data
        provider.populateFromTransaction(widget.transaction);
        _isInitialized = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background[200],
      appBar: CustomAppBar(
        title: widget.isIncome ? 'Edit Pemasukan' : 'Edit Pengeluaran',
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
                          text: 'Simpan Perubahan',
                          isLoading: provider.isLoading,
                          onPressed: () => _updateTransaction(provider),
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

  void _updateTransaction(TransactionProvider provider) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        // Call the updateTransaction method with a transaction ID
        await provider.updateTransaction(
          isIncome: widget.isIncome,
          transactionId:
              widget.transaction['id']?.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
        );

        if (context.mounted) {
          SnackbarManager.showSuccess(
            context: context,
            title: 'Berhasil',
            message:
                widget.isIncome
                    ? 'Pemasukan berhasil diperbarui'
                    : 'Pengeluaran berhasil diperbarui',
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (context.mounted) {
          SnackbarManager.showError(
            context: context,
            error: e,
            customTitle: 'Gagal Memperbarui',
          );
        }
      }
    }
  }
}
