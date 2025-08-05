import 'package:flutter/material.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      appBar: CustomAppBar(
        title: 'FAQ',
        backgroundColor: const Color(0xFFFFB74D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildFAQItem(
            context,
            question: 'Bagaimana cara menambah transaksi?',
            answer:
                'Tekan tombol + di halaman utama, lalu pilih Pemasukan atau Pengeluaran. Isi detail transaksi dan tekan Simpan.',
          ),
          _buildFAQItem(
            context,
            question: 'Bagaimana cara export data ke CSV?',
            answer:
                'Masuk ke halaman Catatan Keuangan, tekan tombol download, pilih periode tanggal, lalu tekan Ekspor CSV.',
          ),
          _buildFAQItem(
            context,
            question: 'Apakah data saya aman?',
            answer:
                'Ya, semua data disimpan secara lokal di perangkat Anda dan tidak dikirim ke server eksternal.',
          ),
          _buildFAQItem(
            context,
            question: 'Bagaimana cara mencari transaksi?',
            answer:
                'Gunakan fitur pencarian di halaman Catatan Keuangan untuk menemukan transaksi berdasarkan nama atau kategori.',
          ),
          _buildFAQItem(
            context,
            question: 'Bagaimana cara mengubah password?',
            answer:
                'Masuk ke halaman Profile, pilih Ganti Password, lalu masukkan password lama dan password baru.',
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent, // Hilangkan divider
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: AppTextStyles.h4.copyWith(
              color: const Color(0xFF202D41),
              fontWeight: FontWeight.w500,
            ),
          ),
          shape: const Border(),
          collapsedShape: const Border(),
          iconColor: const Color(0xFF6A788D),
          collapsedIconColor: const Color(0xFF6A788D),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: AppTextStyles.body.copyWith(
                  color: const Color(0xFF6A788D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
