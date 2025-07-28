import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iampelgading/features/profile/presentation/providers/profile_provider.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_header.dart';
import 'package:iampelgading/features/profile/presentation/widgets/profile_menu_section.dart';

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
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: double.infinity,
              height: 640, // Reduced height since we're removing profile image
              child: Stack(
                children: [
                  ProfileHeader(screenWidth: screenWidth),

                  // Back Button
                  Positioned(
                    left: 24,
                    top: MediaQuery.of(context).padding.top + 16,
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(25),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    top:
                        200, // Adjusted position since we're removing the profile image
                    child: SizedBox(
                      width: screenWidth,
                      child: ProfileMenuSection(
                        onChangePassword: provider.onChangePassword,
                        onChangeUsername: provider.onChangeUsername,
                        onAppInfo: provider.onAppInfo,
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
          );
        },
      ),
    );
  }
}
