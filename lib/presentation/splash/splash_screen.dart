import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/extensions/general_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_image_view.dart';
import 'package:shopowner_mobile_app/presentation/home/root_page.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.ASSETS_IMAGES_SPLASH_BG_JPG),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                  const Gap(10),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 30,
                      shadows: fontShadow,
                      fontFamily: FontFamily.moul,
                      color: AppColors.primaryClr,
                    ),
                    child: AnimatedTextKit(
                      totalRepeatCount: 1,
                      onFinished: () {
                        context.pushAndRemoveUntil(
                          const RootPage(),
                          transition: RouteTransition.scale,
                        );
                      },
                      pause: 700.milliseconds,
                      animatedTexts: [
                        TyperAnimatedText(
                          appNameCamel,
                          speed: 200.milliseconds,
                          textAlign: TextAlign.center,
                          curve: Curves.easeIn,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              DefaultTextStyle(
                style: TextStyle(
                  fontSize: 13,
                  shadows: fontShadow,
                  fontFamily: FontFamily.philosopher,
                  color: AppColors.primaryClr,
                  fontStyle: FontStyle.italic,
                ),
                child: AnimatedTextKit(
                  totalRepeatCount: 1,
                  animatedTexts: [
                    FadeAnimatedText(
                      appTagline,
                      duration: const Duration(milliseconds: 2500),
                    ),
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
