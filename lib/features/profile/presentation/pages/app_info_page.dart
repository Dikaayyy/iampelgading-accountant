import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/widgets/snackbar_helper.dart'; // Add this import
import 'package:iampelgading/features/profile/presentation/pages/faq_page.dart';
import 'package:iampelgading/features/profile/presentation/widgets/app_info_item.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppInfoPage extends StatefulWidget {
  const AppInfoPage({super.key});

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _packageInfo = packageInfo;
        });
      }
    } catch (e) {
      // Handle error
      debugPrint('Error loading package info: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      appBar: CustomAppBar(
        title: 'Informasi Aplikasi',
        backgroundColor: const Color(0xFFFFB74D),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Name Section
            _buildAppHeader(),

            const SizedBox(height: 32),

            // App Information Section
            _buildAppInfoSection(),

            const SizedBox(height: 24),

            // Developer Information Section
            _buildDeveloperSection(),

            const SizedBox(height: 24),

            // Features Section
            _buildFeaturesSection(),

            const SizedBox(height: 24),

            // Legal Section
            _buildLegalSection(),

            const SizedBox(height: 24),

            // Support Section
            _buildSupportSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // App Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.base.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: SvgPicture.asset(
              'assets/svg/app/logo.svg',
              width: 40,
              height: 40,
            ),
          ),

          const SizedBox(height: 16),

          // App Name
          Text(
            'I\'AMPay',
            style: AppTextStyles.h2.copyWith(
              color: const Color(0xFF202D41),
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          // App Description
          Text(
            'Aplikasi Manajemen Keuangan\nuntuk Wisata I\'AMPelgading HOMELAND',
            style: AppTextStyles.body.copyWith(color: const Color(0xFF6A788D)),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Version
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.base.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Versi ${_packageInfo?.version ?? '1.0.0'}',
              style: AppTextStyles.body.copyWith(
                color: AppColors.base,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoSection() {
    return _buildSection(
      title: 'Informasi Aplikasi',
      children: [
        AppInfoItem(
          icon: Icons.info_outline,
          title: 'Nama Aplikasi',
          subtitle: 'I\'AMPay',
        ),
        AppInfoItem(
          icon: Icons.tag,
          title: 'Versi',
          subtitle: _packageInfo?.version ?? '1.0.0',
        ),
        AppInfoItem(
          icon: Icons.build_outlined,
          title: 'Build Number',
          subtitle: _packageInfo?.buildNumber ?? '1',
        ),
        AppInfoItem(
          icon: Icons.calendar_today,
          title: 'Tanggal Rilis',
          subtitle: 'Agustus 2025',
        ),
        AppInfoItem(
          icon: Icons.phone_android,
          title: 'Platform',
          subtitle: 'Android',
        ),
      ],
    );
  }

  Widget _buildDeveloperSection() {
    return _buildSection(
      title: 'Developer',
      children: [
        AppInfoItem(
          icon: Icons.person_outline,
          title: 'Dikembangkan oleh',
          subtitle: 'Tim PMM Giat 12 UNNES',
        ),
        AppInfoItem(
          icon: Icons.email_outlined,
          title: 'Email Kontak',
          subtitle: 'adikakurniawan4@gmail.com',
          onTap: () => _launchEmail('adikakurniawan4@gmail.com'),
        ),
        AppInfoItem(
          icon: Icons.code,
          title: 'Framework',
          subtitle: 'Flutter / Dart',
        ),
        AppInfoItem(icon: Icons.storage, title: 'Database', subtitle: 'MySQL'),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return _buildSection(
      title: 'Fitur Utama',
      children: [
        AppInfoItem(
          icon: Icons.receipt_long,
          title: 'Pencatatan Transaksi',
          subtitle: 'Catat pemasukan dan pengeluaran harian',
        ),
        AppInfoItem(
          icon: Icons.analytics,
          title: 'Dashboard Analitik',
          subtitle: 'Lihat ringkasan keuangan dan tren',
        ),
        AppInfoItem(
          icon: Icons.file_download,
          title: 'Export Data CSV',
          subtitle: 'Unduh laporan dalam format CSV',
        ),
        AppInfoItem(
          icon: Icons.category,
          title: 'Kategori Transaksi',
          subtitle: 'Organisir transaksi berdasarkan kategori',
        ),
        AppInfoItem(
          icon: Icons.search,
          title: 'Pencarian & Filter',
          subtitle: 'Temukan transaksi dengan mudah',
        ),
      ],
    );
  }

  Widget _buildLegalSection() {
    return _buildSection(
      title: 'Legal & Kebijakan',
      children: [
        AppInfoItem(
          icon: Icons.privacy_tip_outlined,
          title: 'Kebijakan Privasi',
          subtitle: 'Data Anda aman dan tidak dibagikan',
          onTap: () => _showPrivacyPolicy(),
        ),
        AppInfoItem(
          icon: Icons.description_outlined,
          title: 'Syarat & Ketentuan',
          subtitle: 'Ketentuan penggunaan aplikasi',
          onTap: () => _showTermsOfService(),
        ),
        AppInfoItem(
          icon: Icons.security,
          title: 'Keamanan Data',
          subtitle: 'Data tersimpan lokal di perangkat Anda',
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _buildSection(
      title: 'Bantuan & Support',
      children: [
        AppInfoItem(
          icon: Icons.help_outline,
          title: 'FAQ',
          subtitle: 'Pertanyaan yang sering diajukan',
          onTap: () => _showFAQ(),
        ),
        AppInfoItem(
          icon: Icons.book_outlined,
          title: 'Panduan Penggunaan',
          subtitle: 'Tutorial lengkap menggunakan aplikasi',
          onTap: () => _showUserGuide(),
        ),
        AppInfoItem(
          icon: Icons.bug_report_outlined,
          title: 'Laporkan Bug',
          subtitle: 'Bantu kami meningkatkan aplikasi',
          onTap: () => _reportBug(),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: const Color(0xFF202D41),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  void _launchEmail(String email) async {
    try {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path: email,
        query: Uri.encodeQueryComponent(
          'subject=Support I\'AMPay - Bantuan Aplikasi&body=Halo tim support I\'AMPay,\n\nSaya membutuhkan bantuan terkait:\n\n[Jelaskan masalah atau pertanyaan Anda di sini]\n\nTerima kasih.',
        ),
      );

      // Check if email can be launched
      if (await canLaunchUrl(emailUri)) {
        final success = await launchUrl(
          emailUri,
          mode: LaunchMode.externalApplication,
        );

        if (success && mounted) {
          SnackbarHelper.showSuccess(
            context: context,
            title: 'Email Dibuka',
            message: 'Aplikasi email telah dibuka. Silakan kirim pesan Anda.',
            showAtTop: true,
          );
        } else if (mounted) {
          _showEmailFallback(email);
        }
      } else {
        if (mounted) {
          _showEmailFallback(email);
        }
      }
    } catch (e) {
      if (mounted) {
        _showEmailFallback(email);
      }
    }
  }

  void _showEmailFallback(String email) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Tidak Dapat Membuka Email',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aplikasi email tidak ditemukan di perangkat Anda. Silakan salin alamat email di bawah ini:',
                style: AppTextStyles.body,
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.neutral[50]!),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        email,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColors.base,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Copy to clipboard functionality
                        _copyEmailToClipboard(email);
                      },
                      icon: Icon(Icons.copy, color: AppColors.base, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Atau hubungi kami melalui:',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.neutral[100],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• WhatsApp: +62 812-3456-7890\n• Instagram: @iampelgading_homeland',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.neutral[200],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup', style: TextStyle(color: AppColors.base)),
            ),
          ],
        );
      },
    );
  }

  void _copyEmailToClipboard(String email) {
    Clipboard.setData(ClipboardData(text: email)).then((_) {
      if (mounted) {
        SnackbarHelper.showSuccess(
          context: context,
          title: 'Email Disalin',
          message: 'Alamat email telah disalin ke clipboard',
          showAtTop: true,
        );
      }
    });
  }

  void _showPrivacyPolicy() {
    _showInfoDialog(
      'Kebijakan Privasi',
      'I\'AMPay berkomitmen melindungi privasi Anda. Semua data transaksi disimpan di server internal. Kami tidak mengumpulkan, menyimpan, atau membagikan informasi pribadi Anda kepada pihak ketiga.',
    );
  }

  void _showTermsOfService() {
    _showInfoDialog(
      'Syarat & Ketentuan',
      'Dengan menggunakan aplikasi I\'AMPay, Anda menyetujui untuk:\n\n1. Menggunakan aplikasi sesuai tujuan yang dimaksud\n2. Tidak menyalahgunakan fitur aplikasi\n3. Bertanggung jawab atas keakuratan data yang diinput\n4. Memahami bahwa aplikasi disediakan "sebagaimana adanya"\n\nAplikasi ini dikembangkan untuk membantu pengelolaan keuangan wisata I\'AMPelgading HOMELAND.',
    );
  }

  void _showFAQ() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FAQPage()),
    );
  }

  void _showUserGuide() {
    _showInfoDialog(
      'Panduan Penggunaan',
      'Cara menggunakan aplikasi I\'AMPay:\n\n1. Dashboard: Lihat ringkasan keuangan\n2. Tambah Transaksi: Gunakan tombol + untuk menambah pemasukan/pengeluaran\n3. Catatan Keuangan: Lihat semua transaksi dengan fitur pencarian\n4. Export: Unduh laporan dalam format CSV\n5. Profile: Kelola akun dan ganti password',
    );
  }

  void _reportBug() {
    _launchEmail('adikakurniawan4@gmail.com');
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w600),
          ),
          content: SingleChildScrollView(
            child: Text(content, style: AppTextStyles.body),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Tutup', style: TextStyle(color: AppColors.base)),
            ),
          ],
        );
      },
    );
  }
}
