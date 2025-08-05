import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:iampelgading/core/theme/app_text_styles.dart';
import 'package:iampelgading/features/dashboard/presentation/widgets/dashboard_header_background.dart';
import 'package:iampelgading/features/profile/presentation/pages/profile_page.dart';
import 'package:iampelgading/features/auth/domain/usecases/change_password_usecase.dart';
import 'package:iampelgading/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:iampelgading/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:iampelgading/core/services/auth_service.dart';
import 'package:http/http.dart' as http;

class DashboardHeader extends StatelessWidget {
  final String? userName;
  final double screenWidth;

  const DashboardHeader({super.key, required this.screenWidth, this.userName});

  ChangePasswordUsecase _createChangePasswordUsecase() {
    final client = http.Client();
    final authService = AuthService();
    final authRemoteDataSource = AuthRemoteDataSourceImpl(
      client: client,
      authService: authService,
    );
    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      authService: authService,
    );
    return ChangePasswordUsecase(repository: authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Orange Background with Rounded Bottom
        Positioned(
          left: 0,
          top: 0,
          child: Container(
            width: screenWidth,
            height: 278,
            decoration: const ShapeDecoration(
              color: Color(0xFFFFB74D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
            ),
          ),
        ),

        // Background Pattern using SVG
        Positioned(
          left: 0,
          top: 0,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: SizedBox(
              width: screenWidth,
              height: 278,
              child: const DashboardHeaderBackground(
                height: 278,
                child: SizedBox.shrink(),
              ),
            ),
          ),
        ),

        // Welcome Text
        Positioned(
          left: 24,
          top: 68,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Halo,',
                style: AppTextStyles.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.80,
                ),
              ),
              Text(
                userName ?? 'Admin Iampelgading',
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
        ),

        // Profile Button (Top Right)
        Positioned(
          right: 24,
          top: 68,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ProfilePage(
                    changePasswordUsecase: _createChangePasswordUsecase(),
                  ),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
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
                  Icons.settings_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
