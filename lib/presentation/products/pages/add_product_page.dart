import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_text_field.dart';
import 'package:shopowner_mobile_app/core/widgets/nice_button.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final formKey = GlobalKey<FormState>();
  final nameCtr = TextEditingController();
  final priceCtr = TextEditingController();
  final stockCtr = TextEditingController();
  final descCtr = TextEditingController();
  String? selectedCategory;

  final List<String> categories = [
    'Electronics', 'Fashion', 'Food & Grocery', 'Health & Beauty',
    'Sports', 'Home & Garden', 'Automotive', 'Books & Media', 'Accessories',
  ];

  @override
  void dispose() {
    nameCtr.dispose();
    priceCtr.dispose();
    stockCtr.dispose();
    descCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close, color: AppColors.primaryClr),
        ),
        title: const AppText(
          text: 'Add New Product',
          fontSize: 18,
          fontWeight: FontWeight.w900,
          fontClr: AppColors.primaryClr,
        ),
        centerTitle: true,
      ),
      body: Container(
        height: context.screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(10),
                  _buildImagePicker(),
                  const Gap(24),
                  _buildLabel('Product Name'),
                  const Gap(6),
                  CustomTextFormField(
                    controller: nameCtr,
                    fillColor: Colors.white54,
                    isFilled: true,
                    width: double.infinity,
                    height: 54,
                    hintText: 'e.g. Premium Phone Case',
                    radius: 14,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const Gap(16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Price (₦)'),
                            const Gap(6),
                            CustomTextFormField(
                              controller: priceCtr,
                              fillColor: Colors.white54,
                              isFilled: true,
                              textInputType: TextInputType.number,
                              width: double.infinity,
                              height: 54,
                              hintText: '0.00',
                              radius: 14,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                      const Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('Stock Qty'),
                            const Gap(6),
                            CustomTextFormField(
                              controller: stockCtr,
                              fillColor: Colors.white54,
                              isFilled: true,
                              textInputType: TextInputType.number,
                              width: double.infinity,
                              height: 54,
                              hintText: '0',
                              radius: 14,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              validator: (v) =>
                                  (v == null || v.isEmpty) ? 'Required' : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(16),
                  _buildLabel('Category'),
                  const Gap(6),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(border: InputBorder.none),
                        hint: const Text(
                          'Select category',
                          style: TextStyle(color: Colors.black54, fontSize: 13),
                        ),
                        items: categories
                            .map(
                              (c) => DropdownMenuItem(
                                value: c,
                                child: Text(
                                  c,
                                  style: const TextStyle(
                                    color: AppColors.primaryClr,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedCategory = v),
                        validator: (v) =>
                            v == null ? 'Select a category' : null,
                      ),
                    ),
                  ),
                  const Gap(16),
                  _buildLabel('Description'),
                  const Gap(6),
                  CustomTextFormField(
                    controller: descCtr,
                    fillColor: Colors.white54,
                    isFilled: true,
                    width: double.infinity,
                    maxLines: 4,
                    hintText: 'Describe your product...',
                    radius: 14,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  const Gap(32),
                  NiceButton(
                    padding: EdgeInsets.zero,
                    btnText: 'Save Product',
                    borderRadius: BorderRadius.circular(14),
                    canContinue: true,
                    onPressed: () {
                      removeKeyboard();
                      if (formKey.currentState!.validate()) {
                        showScaffoldSnackBar(
                          context,
                          text: 'Product added successfully!',
                        );
                        context.pop();
                      }
                    },
                  ),
                  const Gap(20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return AppText(
      text: text,
      fontSize: 13,
      fontWeight: FontWeight.w700,
      fontClr: AppColors.primaryClr,
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white54,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryClr.withOpacity(.3),
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: AppColors.primaryClr.withOpacity(.5),
            ),
            const Gap(8),
            AppText(
              text: 'Tap to add product images',
              fontSize: 13,
              fontClr: AppColors.primaryClr.withOpacity(.6),
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }
}
