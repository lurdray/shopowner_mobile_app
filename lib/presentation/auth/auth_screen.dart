import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_elevated_button.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_image_view.dart';
import 'package:shopowner_mobile_app/presentation/auth/screens/login_screen.dart';
import 'package:shopowner_mobile_app/presentation/auth/screens/register_screen.dart';

class AuthGatewayScreen extends StatelessWidget {
  const AuthGatewayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Gap(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    elevation: 15,
                    shadowColor: AppColors.primaryClr,
                    borderRadius: BorderRadius.circular(54),
                    child: CustomImageView(
                      imagePath: AppAssets.ASSETS_IMAGES_APP_LOGO_PNG,
                      height: 54,
                      width: 54,
                      radius: BorderRadius.circular(54),
                    ),
                  ),
                  const Gap(12),
                  AppText(
                    text: appNameCamel,
                    fontSize: 30,
                    shadows: fontShadow,
                    fontFamily: FontFamily.moul,
                    fontWeight: FontWeight.w400,
                    fontClr: AppColors.primaryClr,
                  ),
                ],
              ),
              const Gap(16),
              const AppText(
                text: appTagline,
                fontSize: 14,
                fontClr: AppColors.primaryClr,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.italic,
                fontFamily: FontFamily.philosopher,
                textAlign: TextAlign.center,
              ),
              Expanded(
                child: CustomImageView(
                  imagePath: AppAssets.ASSETS_IMAGES_AUTHSCREEN_PNG,
                  fit: BoxFit.scaleDown,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    CustomElevatedButton(
                      fixedSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primaryClr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      onPressed: () {
                        context.push(
                          const LoginScreen(),
                          transition: RouteTransition.slideFromRight,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.login, color: AppColors.secClr, size: 18),
                          Gap(8),
                          AppText(
                            text: 'Sign In to your Shop',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            fontClr: AppColors.secClr,
                          ),
                        ],
                      ),
                    ),
                    const Gap(12),
                    CustomElevatedButton(
                      fixedSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.secClr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      onPressed: () {
                        context.push(
                          const RegisterScreen(),
                          transition: RouteTransition.slideFromRight,
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.storefront_outlined,
                            color: AppColors.primaryClr,
                            size: 18,
                          ),
                          Gap(8),
                          AppText(
                            text: 'Create a Shop Account',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            fontClr: AppColors.primaryClr,
                          ),
                        ],
                      ),
                    ),
                    const Gap(32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
