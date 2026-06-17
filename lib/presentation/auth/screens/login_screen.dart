import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/extensions/general_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/nice_button.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_text_field.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';
import 'package:shopowner_mobile_app/presentation/auth/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  bool isPasswordVisible = false;

  @override
  void dispose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authS) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(forceMaterialTransparency: true),
          body: Container(
            height: context.screenHeight,
            width: context.screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
                fit: BoxFit.cover,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Gap(40),
                        AppText(
                          text: 'Welcome Back!',
                          wordHighlight: const ['Back!'],
                          shadows: fontShadow,
                          fontFamily: FontFamily.moul,
                          txtHighlightClr: AppColors.darkBlue,
                          fontClr: AppColors.primaryClr,
                          fontWeight: FontWeight.w400,
                          fontSize: 30,
                        ),
                        const Gap(8),
                        const AppText(
                          text: 'Sign in to manage your shop',
                          fontClr: AppColors.primaryClr,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontStyle: FontStyle.italic,
                          fontFamily: FontFamily.philosopher,
                        ),
                        const Gap(32),
                        CustomTextFormField(
                          controller: emailCtr,
                          fillColor: Colors.white54,
                          isFilled: true,
                          textInputType: TextInputType.emailAddress,
                          prefix: const Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryClr,
                          ),
                          width: double.infinity,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          height: 54,
                          hintText: 'Email',
                          radius: 20,
                          autofillHints: const [AutofillHints.email],
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            if (!value.isValidEmail()) return 'Enter a valid email';
                            return null;
                          },
                        ),
                        const Gap(16),
                        CustomTextFormField(
                          controller: passwordCtr,
                          fillColor: Colors.white54,
                          isFilled: true,
                          isObscureText: !isPasswordVisible,
                          prefix: const Icon(
                            Icons.lock_outline,
                            color: AppColors.primaryClr,
                          ),
                          suffix: IconButton(
                            onPressed: () =>
                                setState(() => isPasswordVisible = !isPasswordVisible),
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.primaryClr,
                            ),
                          ),
                          width: double.infinity,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          height: 54,
                          hintText: 'Password',
                          radius: 20,
                          autofillHints: const [AutofillHints.password],
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'Required';
                            return null;
                          },
                        ),
                        const Gap(8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const AppText(
                              text: 'Forgot Password?',
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w700,
                              fontFamily: FontFamily.philosopher,
                              fontClr: AppColors.primaryClr,
                            ),
                          ),
                        ),
                        const Gap(8),
                        NiceButton(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          btnText: 'Sign In',
                          borderRadius: BorderRadius.circular(20),
                          canContinue: true,
                          isLoading: authS.isLoading,
                          onPressed: () {
                            removeKeyboard();
                            if (formKey.currentState!.validate()) {
                              context.read<AuthCubit>().signIn(
                                    context,
                                    email: emailCtr.text.trim(),
                                    password: passwordCtr.text,
                                  );
                            }
                          },
                        ),
                        const Gap(20),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: FontFamily.philosopher,
                                fontWeight: FontWeight.w700,
                                color: AppColors.darkBlue,
                                fontSize: 15,
                              ),
                              children: [
                                const TextSpan(
                                  text: "Don't have an account? ",
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                                TextSpan(
                                  text: 'Create one',
                                  style: const TextStyle(
                                    color: AppColors.primaryClr,
                                    fontWeight: FontWeight.w900,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushReplacement(
                                        const RegisterScreen(),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(40),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
