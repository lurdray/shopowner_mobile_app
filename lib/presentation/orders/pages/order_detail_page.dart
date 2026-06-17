import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/nice_button.dart';

class OrderDetailPage extends StatelessWidget {
  final dynamic order;

  const OrderDetailPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.primaryClr),
        ),
        title: const AppText(
          text: 'Order Details',
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(10),
                _buildCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: order.id,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontClr: AppColors.primaryClr,
                          ),
                          _buildStatusBadge(order.status),
                        ],
                      ),
                      const Gap(4),
                      AppText(
                        text: 'Placed on ${order.date}',
                        fontSize: 12,
                        fontClr: AppColors.grey700,
                        fontFamily: FontFamily.philosopher,
                      ),
                    ],
                  ),
                ),
                const Gap(14),
                _buildSectionTitle('Customer'),
                const Gap(8),
                _buildCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.secClr.withOpacity(.4),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Icon(
                          Icons.person_outline,
                          color: AppColors.primaryClr,
                        ),
                      ),
                      const Gap(12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: order.customer,
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            fontClr: AppColors.primaryClr,
                          ),
                          const AppText(
                            text: 'Lagos, Nigeria',
                            fontSize: 12,
                            fontClr: AppColors.grey700,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Gap(14),
                _buildSectionTitle('Order Items'),
                const Gap(8),
                _buildCard(
                  child: Column(
                    children: [
                      _buildOrderItem('Phone Case x2', '₦9,000'),
                      const Divider(height: 20),
                      _buildOrderItem('USB Cable x1', '₦4,000'),
                    ],
                  ),
                ),
                const Gap(14),
                _buildSectionTitle('Payment Summary'),
                const Gap(8),
                _buildCard(
                  child: Column(
                    children: [
                      _buildSummaryRow('Subtotal', '₦13,000'),
                      const Gap(6),
                      _buildSummaryRow('Delivery Fee', '₦0'),
                      const Divider(height: 16),
                      _buildSummaryRow('Total', '₦13,000', isBold: true),
                    ],
                  ),
                ),
                const Gap(24),
                if (order.status == 'Pending') ...[
                  NiceButton(
                    padding: EdgeInsets.zero,
                    btnText: 'Mark as Processing',
                    borderRadius: BorderRadius.circular(14),
                    canContinue: true,
                    onPressed: () {
                      showScaffoldSnackBar(
                        context,
                        text: 'Order marked as Processing',
                      );
                      context.pop();
                    },
                  ),
                  const Gap(10),
                  NiceButton(
                    padding: EdgeInsets.zero,
                    btnText: 'Cancel Order',
                    borderRadius: BorderRadius.circular(14),
                    canContinue: true,
                    loadingClr: AppColors.red,
                    onPressed: () {
                      showScaffoldSnackBar(
                        context,
                        text: 'Order cancelled',
                        bgColor: AppColors.red,
                      );
                      context.pop();
                    },
                  ),
                ] else if (order.status == 'Processing') ...[
                  NiceButton(
                    padding: EdgeInsets.zero,
                    btnText: 'Mark as Delivered',
                    borderRadius: BorderRadius.circular(14),
                    canContinue: true,
                    onPressed: () {
                      showScaffoldSnackBar(
                        context,
                        text: 'Order marked as Delivered!',
                        bgColor: AppColors.success,
                      );
                      context.pop();
                    },
                  ),
                ],
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.85),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return AppText(
      text: title,
      fontSize: 15,
      fontWeight: FontWeight.w900,
      fontClr: AppColors.primaryClr,
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    switch (status) {
      case 'Delivered':
        statusColor = AppColors.success;
        break;
      case 'Pending':
        statusColor = AppColors.warning;
        break;
      case 'Processing':
        statusColor = AppColors.info;
        break;
      default:
        statusColor = AppColors.red;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: AppText(
        text: status,
        fontSize: 12,
        fontWeight: FontWeight.w700,
        fontClr: statusColor,
      ),
    );
  }

  Widget _buildOrderItem(String name, String price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: name,
          fontSize: 14,
          fontClr: AppColors.darkBlue,
          fontWeight: FontWeight.w600,
        ),
        AppText(
          text: price,
          fontSize: 14,
          fontWeight: FontWeight.w800,
          fontClr: AppColors.primaryClr,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          text: label,
          fontSize: isBold ? 15 : 13,
          fontWeight: isBold ? FontWeight.w900 : FontWeight.w600,
          fontClr: AppColors.primaryClr,
        ),
        AppText(
          text: value,
          fontSize: isBold ? 16 : 13,
          fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
          fontClr: AppColors.primaryClr,
        ),
      ],
    );
  }
}
