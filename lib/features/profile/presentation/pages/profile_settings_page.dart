import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/core/widgets/custom_text_field.dart';
import 'package:iampelgading/core/widgets/custom_button.dart';
import 'package:iampelgading/core/widgets/custom_app_bar.dart';
import 'package:iampelgading/core/colors/app_colors.dart';
import 'package:iampelgading/features/profile/presentation/providers/profile_settings_provider.dart';

class ProfileSettingsPage extends StatelessWidget {
  final String currentUsername;
  final String? currentImageUrl;

  const ProfileSettingsPage({
    super.key,
    required this.currentUsername,
    this.currentImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create:
          (_) =>
              ProfileSettingsProvider()
                ..initializeData(currentUsername, currentImageUrl),
      child: const ProfileSettingsView(),
    );
  }
}

class ProfileSettingsView extends StatefulWidget {
  const ProfileSettingsView({super.key});

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProfileSettingsProvider>(
        context,
        listen: false,
      );
      _usernameController.text = provider.username;
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: 'Pengaturan Profil',
        backgroundColor: AppColors.base,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<ProfileSettingsProvider>(
        builder: (context, provider, child) {
          return Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Image Section
                          Center(
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: const ShapeDecoration(
                                        color: Color(0xFFFFB74D),
                                        shape: OvalBorder(),
                                      ),
                                      child: ClipOval(
                                        child: _buildProfileImage(provider),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        decoration: ShapeDecoration(
                                          color: AppColors.base,
                                          shape: const OvalBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: IconButton(
                                          icon: const Icon(
                                            Icons.camera_alt,
                                            size: 18,
                                            color: Colors.white,
                                          ),
                                          onPressed:
                                              () => _showImagePickerDialog(
                                                context,
                                                provider,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Username Field
                          CustomTextField(
                            label: 'Username',
                            hintText: 'Masukkan username',
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            validator: provider.validateUsername,
                            onChanged: provider.updateUsername,
                          ),

                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom section with button
                Container(
                  padding: const EdgeInsets.all(24),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      text: 'Simpan Perubahan',
                      onPressed:
                          provider.hasChanges &&
                                  provider.isFormValid &&
                                  !provider.isLoading
                              ? () => _handleUpdateProfile(context, provider)
                              : null,
                      isLoading: provider.isLoading,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(ProfileSettingsProvider provider) {
    if (provider.selectedImage != null) {
      return Image.file(
        provider.selectedImage!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
      );
    } else if (provider.currentImageUrl != null) {
      return Image.network(
        provider.currentImageUrl!,
        width: 120,
        height: 120,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 60, color: Colors.white);
        },
      );
    } else {
      return const Icon(Icons.person, size: 60, color: Colors.white);
    }
  }

  void _showImagePickerDialog(
    BuildContext context,
    ProfileSettingsProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pilih Foto Profil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  provider.pickImage();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  provider.takePhoto();
                },
              ),
              if (provider.selectedImage != null ||
                  provider.currentImageUrl != null)
                ListTile(
                  leading: const Icon(Icons.delete),
                  title: const Text('Hapus Foto'),
                  onTap: () {
                    Navigator.of(context).pop();
                    provider.removeSelectedImage();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleUpdateProfile(
    BuildContext context,
    ProfileSettingsProvider provider,
  ) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await provider.updateProfile();

        if (context.mounted) {
          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profil berhasil diperbarui'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
            ),
          );

          // Navigate back to profile with updated data
          Navigator.of(context).pop({
            'username': provider.username,
            'imageUrl': provider.currentImageUrl,
          });
        }
      } catch (e) {
        if (context.mounted) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal memperbarui profil: ${e.toString()}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }
}
