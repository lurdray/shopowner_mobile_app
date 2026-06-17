import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_elevated_button.dart';

class NiceButton extends StatelessWidget {
  final bool canContinue, isLoading;
  final String btnText;
  final Function onPressed;
  final Size? fixedSize;
  final EdgeInsetsGeometry? margin, padding;
  final Widget? child;
  final BorderRadiusGeometry? borderRadius;
  final double? height, width;
  final Color? loadingClr;

  const NiceButton({
    super.key,
    this.isLoading = false,
    required this.canContinue,
    this.btnText = 'Next',
    required this.onPressed,
    this.fixedSize,
    this.padding,
    this.margin,
    this.borderRadius,
    this.child,
    this.height,
    this.width,
    this.loadingClr,
  });

  @override
  Widget build(BuildContext context) {
    Color btnClr() =>
        canContinue ? AppColors.primaryClr : AppColors.secClr;
    Color btnTxtClr() =>
        canContinue ? AppColors.secClr : AppColors.primaryClr;

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: SizedBox(
        height: height ?? 52,
        width: width,
        child: CustomElevatedButton(
          pressedColor: AppColors.secClr,
          showLoading: isLoading,
          loadingClr: loadingClr ?? Colors.white,
          fixedSize: fixedSize,
          onPressed: !canContinue || isLoading
              ? null
              : () {
                  FocusScope.of(context).unfocus();
                  onPressed();
                },
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ?? BorderRadius.circular(6),
          ),
          backgroundColor: btnClr(),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Padding(
              padding: margin ?? EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  child ?? const SizedBox.shrink(),
                  if (child != null) const Gap(10),
                  AppText(
                    text: btnText,
                    fontClr: btnTxtClr(),
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
