import 'package:flutter/material.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/utils/currency_formater.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends StatelessWidget {
  final Map<String, dynamic> transaction;
  final bool isExpense;

  const TransactionDetailPage({
    super.key,
    required this.transaction,
    required this.isExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      appBar: CustomAppBar(
        title: 'Detail Transaksi',
        backgroundColor: const Color(0xFFFFB74D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Transaction Header
              _buildTransactionHeader(),

              const SizedBox(height: 12),

              // Divider
              _buildDivider(),

              const SizedBox(height: 12),

              // Transaction Details
              _buildTransactionDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionHeader() {
    final Color amountColor =
        isExpense ? const Color(0xFFFF4545) : const Color(0xFF40B029);

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Icon Container
        Container(
          width: 65,
          height: 65,
          decoration: ShapeDecoration(
            color: amountColor.withOpacity(0.1),
            shape: const OvalBorder(),
          ),
          child: Icon(
            transaction['icon'] as IconData? ??
                (isExpense ? Icons.arrow_upward : Icons.arrow_downward),
            size: 30,
            color: amountColor,
          ),
        ),

        const SizedBox(width: 12),

        // Transaction Info
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isExpense ? 'Uang Keluar' : 'Uang Masuk',
                style: AppTextStyles.h4.copyWith(
                  color: const Color(0xFF343434),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                transaction['title'] as String? ?? 'Transaksi',
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xFF6A788D),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Opacity(
      opacity: 0.10,
      child: Container(
        width: double.infinity,
        height: 1,
        decoration: ShapeDecoration(
          color: const Color(0xFF6A788D),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildTransactionDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow('Tanggal', _formatDate()),
        const SizedBox(height: 12),
        _buildDetailRow('Waktu', _formatTime()),
        const SizedBox(height: 12),
        _buildDetailRow('Pembayaran', _getPaymentMethod()),
        const SizedBox(height: 12),
        _buildDetailRow('Jumlah', _formatAmount()),
        if (transaction['description'] != null) ...[
          const SizedBox(height: 12),
          _buildDetailRow('Keterangan', transaction['description'] as String),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.body.copyWith(
              color: const Color(0xFF343434),
              fontWeight: FontWeight.w400,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.body.copyWith(
                color: const Color(0xFF343434),
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate() {
    try {
      final dateStr = transaction['date'] as String? ?? '';
      // Try to parse the date string
      final date = DateFormat('d MMMM yyyy', 'id_ID').parse(dateStr);
      final dayName = DateFormat('EEEE', 'id_ID').format(date);
      return '$dayName, $dateStr';
    } catch (e) {
      return transaction['date'] as String? ?? 'Tanggal tidak tersedia';
    }
  }

  String _formatTime() {
    final timeStr = transaction['time'] as String? ?? '';
    if (timeStr.isNotEmpty) {
      return '$timeStr WIB';
    }
    return 'Waktu tidak tersedia';
  }

  String _getPaymentMethod() {
    return transaction['paymentMethod'] as String? ?? 'Cash';
  }

  String _formatAmount() {
    final amount = transaction['amount'] as double? ?? 0.0;
    return CurrencyFormatter.format(amount.abs());
  }
}
