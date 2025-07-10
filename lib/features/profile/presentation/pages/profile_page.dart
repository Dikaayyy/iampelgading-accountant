import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/features/profile/presentation/providers/profile_provider.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_header.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_menu_section.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFBFA),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return RefreshIndicator(
            onRefresh: provider.refreshProfile,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                width: double.infinity,
                height: 890,
                child: Stack(
                  children: [
                    ProfileHeader(screenWidth: screenWidth),

                    Positioned(
                      left: 0,
                      top: 222,
                      child: SizedBox(
                        width: screenWidth,
                        child: ProfileMenuSection(
                          onChangePassword: provider.onChangePassword,
                          onChangeUsername: provider.onChangeUsername,
                          onAppInfo: provider.onAppInfo,
                        ),
                      ),
                    ),

                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 166),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 111,
                                height: 111,
                                decoration: const ShapeDecoration(
                                  color: Color(0xFFFFB74D),
                                  shape: OvalBorder(),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  size: 60,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                provider.userName,
                                style: AppTextStyles.h4.copyWith(
                                  color: const Color(0xFF343434),
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if (provider.isLoading)
                      const Positioned.fill(
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
