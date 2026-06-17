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
import 'package:shopowner_mobile_app/presentation/auth/screens/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailCtr = TextEditingController();
  final passwordCtr = TextEditingController();
  final shopNameCtr = TextEditingController();
  bool isPasswordVisible = false;

  String? selectedMarket;
  String? selectedSubMarket;
  String? selectedCountry;
  String? selectedState;

  final List<String> markets = [
    'Electronics', 'Fashion', 'Food & Grocery', 'Health & Beauty',
    'Sports', 'Home & Garden', 'Automotive', 'Books & Media',
  ];

  final Map<String, List<String>> subMarketsMap = {
    'Electronics': ['Phones', 'Laptops', 'Accessories', 'TVs & Audio'],
    'Fashion': ['Men', 'Women', 'Kids', 'Footwear', 'Bags'],
    'Food & Grocery': ['Fresh Produce', 'Packaged Food', 'Beverages', 'Snacks'],
    'Health & Beauty': ['Skincare', 'Haircare', 'Supplements', 'Medical'],
    'Sports': ['Equipment', 'Apparel', 'Footwear', 'Outdoor'],
    'Home & Garden': ['Furniture', 'Decor', 'Gardening', 'Kitchen'],
    'Automotive': ['Parts', 'Accessories', 'Tools', 'Tyres'],
    'Books & Media': ['Books', 'Music', 'Movies', 'Games'],
  };

  @override
  void dispose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    shopNameCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authS) {
        final subMarkets = selectedMarket != null
            ? (subMarketsMap[selectedMarket] ?? [])
            : <String>[];

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Gap(20),
                      AppText(
                        text: 'Create Your Account',
                        wordHighlight: const ['Account'],
                        shadows: fontShadow,
                        fontFamily: FontFamily.moul,
                        txtHighlightClr: AppColors.darkBlue,
                        fontClr: AppColors.primaryClr,
                        fontWeight: FontWeight.w400,
                        fontSize: 26,
                        textAlign: TextAlign.center,
                      ),
                      const Gap(6),
                      AppText(
                        text:
                            'Join $appName and unlock a world of opportunities.\nConnect, Discover, and Grow.',
                        fontClr: AppColors.primaryClr,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        fontStyle: FontStyle.italic,
                        fontFamily: FontFamily.philosopher,
                        maxLines: 3,
                      ),
                      const Gap(24),
                      _buildField(
                        controller: shopNameCtr,
                        hint: 'Shop Name',
                        icon: Icons.storefront_outlined,
                        autofill: const [AutofillHints.organizationName],
                        validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                      ),
                      const Gap(12),
                      _buildField(
                        controller: emailCtr,
                        hint: 'Email',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        autofill: const [AutofillHints.email],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (!v.isValidEmail()) return 'Enter a valid email';
                          return null;
                        },
                      ),
                      const Gap(12),
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
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (v.length < 8) return 'Min 8 characters';
                          return null;
                        },
                      ),
                      const Gap(12),
                      _buildDropdown(
                        hint: 'Select Market Category',
                        icon: Icons.category_outlined,
                        value: selectedMarket,
                        items: markets,
                        onChanged: (v) => setState(() {
                          selectedMarket = v;
                          selectedSubMarket = null;
                        }),
                        validator: (v) =>
                            selectedMarket == null ? 'Required' : null,
                      ),
                      const Gap(12),
                      _buildDropdown(
                        hint: subMarkets.isEmpty
                            ? 'Select market first'
                            : 'Select Sub-Market',
                        icon: Icons.store_outlined,
                        value: selectedSubMarket,
                        items: subMarkets,
                        onChanged: subMarkets.isEmpty
                            ? null
                            : (v) => setState(() => selectedSubMarket = v),
                        validator: (v) =>
                            selectedSubMarket == null ? 'Required' : null,
                      ),
                      const Gap(24),
                      NiceButton(
                        padding: EdgeInsets.zero,
                        btnText: 'Create Account',
                        borderRadius: BorderRadius.circular(20),
                        canContinue: true,
                        isLoading: authS.isLoading,
                        onPressed: () {
                          removeKeyboard();
                          if (formKey.currentState!.validate()) {
                            context.read<AuthCubit>().signUp(
                                  context,
                                  email: emailCtr.text.trim(),
                                  password: passwordCtr.text,
                                  shopName: shopNameCtr.text.trim(),
                                  market: selectedMarket!,
                                  subMarket: selectedSubMarket!,
                                  country: selectedCountry ?? 'Nigeria',
                                  countryState: selectedState ?? 'Lagos',
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
                                text: 'Already have an account? ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: const TextStyle(
                                  color: AppColors.primaryClr,
                                  fontWeight: FontWeight.w900,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    context.pushReplacement(const LoginScreen());
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
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    Iterable<String>? autofill,
    FormFieldValidator<String>? validator,
  }) {
    return CustomTextFormField(
      controller: controller,
      fillColor: Colors.white54,
      isFilled: true,
      textInputType: keyboardType,
      prefix: Icon(icon, color: AppColors.primaryClr),
      width: double.infinity,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      height: 54,
      hintText: hint,
      radius: 20,
      autofillHints: autofill,
      validator: validator,
    );
  }

  Widget _buildDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
    FormFieldValidator<String?>? validator,
  }) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        color: Colors.white54,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryClr),
          const Gap(8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(border: InputBorder.none),
                hint: Text(
                  hint,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontFamily: FontFamily.philosopher,
                  ),
                ),
                items: items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: AppColors.primaryClr,
                            fontWeight: FontWeight.w600,
                            fontFamily: FontFamily.philosopher,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                validator: validator,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
