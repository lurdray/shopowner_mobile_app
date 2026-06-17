import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/app_const.dart';
import 'package:shopowner_mobile_app/core/extensions/general_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/custom_image_view.dart';
import 'package:shopowner_mobile_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:shopowner_mobile_app/presentation/auth/state/auth_state.dart';

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
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildHeader(shopName, authS),
                const Gap(20),
                _buildStatCards(),
                const Gap(20),
                _buildSectionTitle('Recent Orders'),
                const Gap(12),
                _buildRecentOrders(),
                const Gap(20),
                _buildSectionTitle('Quick Actions'),
                const Gap(12),
                _buildQuickActions(context),
                const Gap(20),
                _buildSectionTitle('Revenue Overview'),
                const Gap(12),
                _buildRevenueCard(),
                const Gap(20),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(String shopName, AuthState authS) {
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
            imagePath: AppAssets.ASSETS_IMAGES_APP_LOGO_PNG,
            height: 46,
            width: 46,
            radius: BorderRadius.circular(40),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards() {
    final stats = [
      _StatData(
        label: 'Total Sales',
        value: 1240000.toMoneyFormat(),
        prefix: '₦',
        icon: Icons.trending_up,
        color: AppColors.success,
      ),
      _StatData(
        label: 'Orders',
        value: '86',
        icon: Icons.shopping_bag_outlined,
        color: AppColors.info,
      ),
      _StatData(
        label: 'Products',
        value: '34',
        icon: Icons.inventory_2_outlined,
        color: AppColors.warning,
      ),
      _StatData(
        label: 'Customers',
        value: '512',
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

  Widget _buildRecentOrders() {
    final orders = [
      _OrderData(id: '#ORD-001', item: '2x Phone Cases', amount: '₦8,500', status: 'Delivered'),
      _OrderData(id: '#ORD-002', item: '1x Smart Watch', amount: '₦45,000', status: 'Pending'),
      _OrderData(id: '#ORD-003', item: '3x Earbuds', amount: '₦12,000', status: 'Processing'),
    ];

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
      children: actions
          .map(
            (a) => _QuickActionButton(action: a),
          )
          .toList(),
    );
  }

  Widget _buildRevenueCard() {
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
          const AppText(
            text: '₦1,240,000',
            fontSize: 28,
            fontWeight: FontWeight.w900,
            fontClr: Colors.white,
          ),
          const Gap(8),
          Row(
            children: [
              const Icon(Icons.arrow_upward, color: AppColors.success, size: 16),
              const Gap(4),
              const AppText(
                text: '+12.5% vs last month',
                fontSize: 12,
                fontClr: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
          const Gap(16),
          _buildMiniBarChart(),
        ],
      ),
    );
  }

  Widget _buildMiniBarChart() {
    final List<double> data = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9, 1.0];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SizedBox(
      height: 80,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          data.length,
          (i) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 28,
                height: 60 * data[i],
                decoration: BoxDecoration(
                  color: AppColors.secClr.withOpacity(i == data.length - 1 ? 1 : 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Gap(4),
              Text(
                days[i],
                style: const TextStyle(
                  color: AppColors.secClr,
                  fontSize: 9,
                  fontFamily: FontFamily.nunitoSans,
                ),
              ),
            ],
          ),
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

class _OrderData {
  final String id, item, amount, status;
  _OrderData({
    required this.id,
    required this.item,
    required this.amount,
    required this.status,
  });
}

class _OrderCard extends StatelessWidget {
  final _OrderData order;
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
                  text: order.item,
                  fontSize: 12,
                  fontClr: AppColors.grey700,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              AppText(
                text: order.amount,
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
