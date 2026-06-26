import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/utils/generics.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_text_field.dart';
import 'package:shopowner_mobile_app/data/models/product_model.dart';
import 'package:shopowner_mobile_app/presentation/products/cubit/products_cubit.dart';
import 'package:shopowner_mobile_app/presentation/products/pages/add_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final searchCtr = TextEditingController();

  final List<String> _filters = ['All', 'In Stock', 'Low Stock', 'Out of Stock'];

  @override
  void dispose() {
    searchCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: 'My Products',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontClr: AppColors.primaryClr,
                      ),
                      GestureDetector(
                        onTap: () async {
                          await context.push(
                            const AddProductPage(),
                            transition: RouteTransition.slideFromBottom,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryClr,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.secClr,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: CustomTextFormField(
                    controller: searchCtr,
                    fillColor: Colors.white54,
                    isFilled: true,
                    prefix: const Icon(
                      CupertinoIcons.search,
                      color: AppColors.primaryClr,
                      size: 18,
                    ),
                    width: double.infinity,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    height: 48,
                    hintText: 'Search products...',
                    radius: 14,
                    onChanged: (v) =>
                        context.read<ProductsCubit>().setSearch(v),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const Gap(8),
                    itemBuilder: (_, i) {
                      final f = _filters[i];
                      final isSelected = state.filter == f;
                      return GestureDetector(
                        onTap: () => context.read<ProductsCubit>().setFilter(f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryClr
                                : Colors.white.withOpacity(.7),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          alignment: Alignment.center,
                          child: AppText(
                            text: f,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontClr: isSelected
                                ? AppColors.secClr
                                : AppColors.primaryClr,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const Gap(12),
                Expanded(child: _buildBody(context, state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    if (state.isLoading && state.products.isEmpty) {
      return loadingCircle();
    }
    if (state.errorMsg != null && state.products.isEmpty) {
      return _emptyState(state.errorMsg!, Icons.cloud_off_outlined);
    }
    final items = state.visible;
    if (items.isEmpty) {
      return _emptyState('No products found', Icons.inventory_2_outlined);
    }
    return RefreshIndicator(
      onRefresh: () => context.read<ProductsCubit>().load(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Gap(10),
        itemBuilder: (_, i) => _ProductCard(product: items[i]),
      ),
    );
  }

  Widget _emptyState(String text, IconData icon) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 60, color: AppColors.primaryClr.withOpacity(.3)),
          const Gap(12),
          AppText(
            text: text,
            fontSize: 16,
            fontClr: AppColors.primaryClr.withOpacity(.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  Color get _statusColor {
    switch (product.status) {
      case 'In Stock':
        return AppColors.success;
      case 'Low Stock':
        return AppColors.warning;
      default:
        return AppColors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.secClr.withOpacity(.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primaryClr,
            ),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: product.name,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  fontClr: AppColors.primaryClr,
                  maxLines: 1,
                ),
                const Gap(2),
                AppText(
                  text: product.category,
                  fontSize: 11,
                  fontClr: AppColors.grey700,
                  fontFamily: FontFamily.philosopher,
                ),
                const Gap(4),
                Row(
                  children: [
                    AppText(
                      text: '₦${product.price.toStringAsFixed(0)}',
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      fontClr: AppColors.primaryClr,
                    ),
                    const Gap(8),
                    AppText(
                      text: '${product.stock} units',
                      fontSize: 11,
                      fontClr: AppColors.grey700,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AppText(
                  text: product.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontClr: _statusColor,
                ),
              ),
              const Gap(8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 18,
                      color: AppColors.info,
                    ),
                  ),
                  const Gap(8),
                  GestureDetector(
                    onTap: () => _confirmDelete(context),
                    child: const Icon(
                      Icons.delete_outline,
                      size: 18,
                      color: AppColors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showAlertDialog(
      context,
      title: 'Delete product?',
      content: 'Remove "${product.name}" from your shop?',
      confirmText: 'Delete',
      changeR: true,
      onConfirm: () async {
        final ok = await context.read<ProductsCubit>().deleteProduct(product.id);
        if (context.mounted) {
          showScaffoldSnackBar(
            context,
            text: ok ? 'Product deleted' : 'Could not delete product',
            bgColor: ok ? AppColors.red : null,
          );
        }
      },
    );
  }
}
