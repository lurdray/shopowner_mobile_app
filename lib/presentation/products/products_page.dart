import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_text_field.dart';
import 'package:shopowner_mobile_app/presentation/products/pages/add_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final searchCtr = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = ['All', 'In Stock', 'Low Stock', 'Out of Stock'];

  final List<_ProductData> _products = [
    _ProductData(
      id: '1',
      name: 'Premium Phone Case',
      price: 4500,
      stock: 24,
      category: 'Accessories',
      status: 'In Stock',
    ),
    _ProductData(
      id: '2',
      name: 'Wireless Earbuds Pro',
      price: 18500,
      stock: 8,
      category: 'Electronics',
      status: 'Low Stock',
    ),
    _ProductData(
      id: '3',
      name: 'Smart Watch Series 3',
      price: 45000,
      stock: 0,
      category: 'Electronics',
      status: 'Out of Stock',
    ),
    _ProductData(
      id: '4',
      name: 'USB-C Fast Charger',
      price: 6000,
      stock: 50,
      category: 'Accessories',
      status: 'In Stock',
    ),
    _ProductData(
      id: '5',
      name: 'Bluetooth Speaker',
      price: 22000,
      stock: 12,
      category: 'Electronics',
      status: 'In Stock',
    ),
    _ProductData(
      id: '6',
      name: 'Screen Protector Pack',
      price: 2000,
      stock: 3,
      category: 'Accessories',
      status: 'Low Stock',
    ),
  ];

  List<_ProductData> get _filtered {
    return _products.where((p) {
      final matchFilter =
          _selectedFilter == 'All' || p.status == _selectedFilter;
      final matchSearch = searchCtr.text.isEmpty ||
          p.name.toLowerCase().contains(searchCtr.text.toLowerCase());
      return matchFilter && matchSearch;
    }).toList();
  }

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
        child: Column(
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
                    onTap: () {
                      context.push(
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
                onChanged: (_) => setState(() {}),
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
                  final isSelected = _selectedFilter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
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
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 60,
                            color: AppColors.primaryClr.withOpacity(.3),
                          ),
                          const Gap(12),
                          AppText(
                            text: 'No products found',
                            fontSize: 16,
                            fontClr: AppColors.primaryClr.withOpacity(.5),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) => const Gap(10),
                      itemBuilder: (_, i) =>
                          _ProductCard(product: _filtered[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductData {
  final String id, name, category, status;
  final double price;
  final int stock;

  _ProductData({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.status,
  });
}

class _ProductCard extends StatelessWidget {
  final _ProductData product;
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
                    onTap: () {},
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
}
