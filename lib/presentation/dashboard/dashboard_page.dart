import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/extensions/general_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/utils/generics.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_image_view.dart';
import 'package:shopowner_mobile_app/data/models/dashboard_model.dart';
import 'package:shopowner_mobile_app/data/models/order_model.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';
import 'package:shopowner_mobile_app/presentation/dashboard/cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authS) {
        final shopName = authS.authModel?.shopName ?? appName;
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppAssets.ASSETS_IMAGES_APP_BG_JPG),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: BlocBuilder<DashboardCubit, DashboardState>(
              builder: (context, state) {
                if (state.isLoading && state.data == null) {
                  return loadingCircle();
                }
                final data = state.data;
                return RefreshIndicator(
                  onRefresh: () => context.read<DashboardCubit>().load(),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      _buildHeader(shopName, authS),
                      const Gap(20),
                      _buildStatCards(data),
                      const Gap(20),
                      _buildSectionTitle('Recent Orders'),
                      const Gap(12),
                      _buildRecentOrders(data?.recentOrders ?? const []),
                      const Gap(20),
                      _buildSectionTitle('Quick Actions'),
                      const Gap(12),
                      _buildQuickActions(context),
                      const Gap(20),
                      _buildSectionTitle('Revenue Overview'),
                      const Gap(12),
                      _buildRevenueCard(data),
                      const Gap(20),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String shopName, AuthState authS) {
    final logo = authS.authModel?.shopLogo;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppText(
              text: 'Good morning,',
              fontSize: 13,
              fontClr: AppColors.primaryClr,
              fontFamily: FontFamily.philosopher,
            ),
            AppText(
              text: shopName,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              fontClr: AppColors.primaryClr,
            ),
          ],
        ),
        Material(
          elevation: 10,
          shadowColor: AppColors.primaryClr,
          borderRadius: BorderRadius.circular(40),
          child: CustomImageView(
            imagePath: (logo != null && logo.isNotEmpty)
                ? logo
                : AppAssets.ASSETS_IMAGES_APP_LOGO_PNG,
            height: 46,
            width: 46,
            radius: BorderRadius.circular(40),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(DashboardModel? data) {
    final stats = [
      _StatData(
        label: 'Total Sales',
        value: (data?.totalSales ?? 0).toMoneyFormat(),
        prefix: '₦',
        icon: Icons.trending_up,
        color: AppColors.success,
      ),
      _StatData(
        label: 'Orders',
        value: '${data?.orders ?? 0}',
        icon: Icons.shopping_bag_outlined,
        color: AppColors.info,
      ),
      _StatData(
        label: 'Products',
        value: '${data?.products ?? 0}',
        icon: Icons.inventory_2_outlined,
        color: AppColors.warning,
      ),
      _StatData(
        label: 'Customers',
        value: '${data?.customers ?? 0}',
        icon: Icons.people_outline,
        color: AppColors.primaryClr,
      ),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.6,
      children: stats.map((s) => _StatCard(data: s)).toList(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: 17,
      fontWeight: FontWeight.w900,
      fontClr: AppColors.primaryClr,
    );
  }

  Widget _buildRecentOrders(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.85),
          borderRadius: BorderRadius.circular(14),
        ),
        child: AppText(
          text: 'No orders yet',
          fontSize: 13,
          fontClr: AppColors.grey700,
        ),
      );
    }
    return Column(
      children: orders.map((o) => _OrderCard(order: o)).toList(),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(label: 'Add Product', icon: Icons.add_box_outlined, color: AppColors.success),
      _QuickAction(label: 'View Orders', icon: Icons.list_alt_outlined, color: AppColors.info),
      _QuickAction(label: 'Analytics', icon: Icons.bar_chart_outlined, color: AppColors.warning),
      _QuickAction(label: 'Promotions', icon: Icons.local_offer_outlined, color: AppColors.red),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) => _QuickActionButton(action: a)).toList(),
    );
  }

  Widget _buildRevenueCard(DashboardModel? data) {
    final thisMonth = data?.thisMonth ?? 0;
    final change = data?.changePct ?? 0;
    final positive = change >= 0;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryClr,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: 'This Month',
            fontSize: 13,
            fontClr: AppColors.secClr,
            fontFamily: FontFamily.philosopher,
          ),
          const Gap(4),
          AppText(
            text: '₦${thisMonth.toMoneyFormat()}',
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontClr: Colors.white,
          ),
          const Gap(8),
          Row(
            children: [
              Icon(
                positive ? Icons.arrow_upward : Icons.arrow_downward,
                color: positive ? AppColors.success : AppColors.red,
                size: 16,
              ),
              const Gap(4),
              AppText(
                text:
                    '${positive ? '+' : ''}${change.toStringAsFixed(1)}% vs last month',
                fontSize: 12,
                fontClr: positive ? AppColors.success : AppColors.red,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const Gap(16),
          _buildMiniBarChart(data?.weekly ?? const []),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart(List<RevenueBar> weekly) {
    if (weekly.isEmpty) {
      return const SizedBox(height: 80);
    }
    final maxAmount =
        weekly.map((e) => e.amount).fold<double>(0, (a, b) => a > b ? a : b);

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          weekly.length,
          (i) {
            final ratio = maxAmount <= 0 ? 0.0 : weekly[i].amount / maxAmount;
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 28,
                  height: 6 + 54 * ratio,
                  decoration: BoxDecoration(
                    color: AppColors.secClr
                        .withOpacity(i == weekly.length - 1 ? 1 : 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const Gap(4),
                Text(
                  weekly[i].label,
                  style: const TextStyle(
                    color: AppColors.secClr,
                    fontSize: 9,
                    fontFamily: FontFamily.nunitoSans,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final String? prefix;
  final IconData icon;
  final Color color;

  _StatData({
    required this.label,
    required this.value,
    this.prefix,
    required this.icon,
    required this.color,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData data;

  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryClr.withOpacity(.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(data.icon, color: data.color, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: '${data.prefix ?? ''}${data.value}',
                fontSize: 18,
                fontWeight: FontWeight.w900,
                fontClr: AppColors.primaryClr,
                maxLines: 1,
              ),
              AppText(
                text: data.label,
                fontSize: 11,
                fontClr: AppColors.grey700,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case 'Delivered':
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      default:
        return AppColors.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: order.id,
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  fontClr: AppColors.primaryClr,
                ),
                const Gap(2),
                AppText(
                  text: order.items.isNotEmpty ? order.items : order.customer,
                  fontSize: 12,
                  fontClr: AppColors.grey700,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: '₦${order.total.toStringAsFixed(0)}',
                fontSize: 13,
                fontWeight: FontWeight.w900,
                fontClr: AppColors.primaryClr,
              ),
              const Gap(4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(.1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AppText(
                  text: order.status,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  fontClr: _statusColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  _QuickAction({required this.label, required this.icon, required this.color});
}

class _QuickActionButton extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionButton({required this.action});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: action.color.withOpacity(.12),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(action.icon, color: action.color, size: 26),
        ),
        const Gap(6),
        AppText(
          text: action.label,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          fontClr: AppColors.primaryClr,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
