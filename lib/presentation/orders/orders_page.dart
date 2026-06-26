import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/enums/route_enum.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/utils/generics.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_text_field.dart';
import 'package:shopowner_mobile_app/data/models/order_model.dart';
import 'package:shopowner_mobile_app/presentation/orders/cubit/orders_cubit.dart';
import 'package:shopowner_mobile_app/presentation/orders/pages/order_detail_page.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final searchCtr = TextEditingController();

  final List<String> _statuses = [
    'All', 'Pending', 'Processing', 'Delivered', 'Cancelled',
  ];

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
        child: BlocBuilder<OrdersCubit, OrdersState>(
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
                        text: 'Orders',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontClr: AppColors.primaryClr,
                      ),
                      _buildOrderSummaryBadge(state.pendingCount),
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
                    hintText: 'Search by order ID or customer...',
                    radius: 14,
                    onChanged: (v) => context.read<OrdersCubit>().setSearch(v),
                  ),
                ),
                const Gap(12),
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: _statuses.length,
                    separatorBuilder: (_, __) => const Gap(8),
                    itemBuilder: (_, i) {
                      final s = _statuses[i];
                      final isSelected = state.filter == s;
                      return GestureDetector(
                        onTap: () => context.read<OrdersCubit>().setFilter(s),
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
                            text: s,
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

  Widget _buildBody(BuildContext context, OrdersState state) {
    if (state.isLoading && state.orders.isEmpty) {
      return loadingCircle();
    }
    if (state.errorMsg != null && state.orders.isEmpty) {
      return _emptyState(state.errorMsg!, Icons.cloud_off_outlined);
    }
    final items = state.visible;
    if (items.isEmpty) {
      return _emptyState('No orders found', Icons.shopping_bag_outlined);
    }
    return RefreshIndicator(
      onRefresh: () => context.read<OrdersCubit>().load(),
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Gap(10),
        itemBuilder: (_, i) => _OrderCard(
          order: items[i],
          onTap: () {
            context.push(
              OrderDetailPage(order: items[i]),
              transition: RouteTransition.slideFromRight,
            );
          },
        ),
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

  Widget _buildOrderSummaryBadge(int pending) {
    if (pending == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withOpacity(.15),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.circle, color: AppColors.warning, size: 8),
          const Gap(6),
          AppText(
            text: '$pending Pending',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            fontClr: AppColors.warning,
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;

  const _OrderCard({required this.order, required this.onTap});

  Color get _statusColor {
    switch (order.status) {
      case 'Delivered':
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      case 'Processing':
        return AppColors.info;
      case 'Cancelled':
        return AppColors.red;
      default:
        return AppColors.grey700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.85),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: order.id,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  fontClr: AppColors.primaryClr,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: AppText(
                    text: order.status,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    fontClr: _statusColor,
                  ),
                ),
              ],
            ),
            const Gap(6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: 14,
                  color: AppColors.grey700,
                ),
                const Gap(4),
                AppText(
                  text: order.customer,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  fontClr: AppColors.darkBlue,
                ),
              ],
            ),
            const Gap(4),
            AppText(
              text: order.items,
              fontSize: 12,
              fontClr: AppColors.grey700,
              fontFamily: FontFamily.philosopher,
              maxLines: 1,
            ),
            const Gap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: order.date,
                  fontSize: 11,
                  fontClr: AppColors.grey700,
                ),
                AppText(
                  text: '₦${order.total.toStringAsFixed(0)}',
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  fontClr: AppColors.primaryClr,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
