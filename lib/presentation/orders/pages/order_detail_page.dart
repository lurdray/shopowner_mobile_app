import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:shopowner_mobile_app/core/app_assets.dart';
import 'package:shopowner_mobile_app/core/extensions/context_extension.dart';
import 'package:shopowner_mobile_app/core/theme/app_colors.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';
import 'package:shopowner_mobile_app/core/utils/font_family.dart';
import 'package:shopowner_mobile_app/core/utils/generics.dart';
import 'package:shopowner_mobile_app/core/widgets/app_text.dart';
import 'package:shopowner_mobile_app/core/widgets/nice_button.dart';
import 'package:shopowner_mobile_app/data/models/order_model.dart';
import 'package:shopowner_mobile_app/presentation/orders/cubit/orders_cubit.dart';

class OrderDetailPage extends StatefulWidget {
  final OrderModel order;

  const OrderDetailPage({super.key, required this.order});

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  late OrderModel order;
  bool _loading = true;
  bool _updating = false;

  @override
  void initState() {
    super.initState();
    order = widget.order;
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    try {
      final full = await context.read<OrdersCubit>().detail(widget.order.pk);
      if (!mounted) return;
      setState(() {
        order = full;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _setStatus(String status, {Color? bgColor}) async {
    setState(() => _updating = true);
    final ok = await context.read<OrdersCubit>().updateStatus(order.pk, status);
    if (!mounted) return;
    setState(() => _updating = false);
    showScaffoldSnackBar(
      context,
      text: ok ? 'Order marked as $status' : 'Could not update order',
      bgColor: ok ? bgColor : AppColors.red,
    );
    if (ok) context.pop();
  }

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
                          AppText(
                            text: order.customerLocation?.isNotEmpty == true
                                ? order.customerLocation!
                                : 'Lagos, Nigeria',
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
                  child: _loading
                      ? Padding(
                          padding: const EdgeInsets.all(8),
                          child: loadingCircle(28),
                        )
                      : Column(children: _buildItemRows()),
                ),
                const Gap(14),
                _buildSectionTitle('Payment Summary'),
                const Gap(8),
                _buildCard(
                  child: Column(
                    children: [
                      _buildSummaryRow(
                        'Subtotal',
                        '₦${(order.subtotal ?? order.total).toStringAsFixed(0)}',
                      ),
                      const Gap(6),
                      _buildSummaryRow(
                        'Delivery Fee',
                        '₦${(order.deliveryFee ?? 0).toStringAsFixed(0)}',
                      ),
                      const Divider(height: 16),
                      _buildSummaryRow(
                        'Total',
                        '₦${order.total.toStringAsFixed(0)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
                const Gap(24),
                ..._buildActions(),
                const Gap(20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildItemRows() {
    if (order.itemList.isEmpty) {
      return [
        AppText(
          text: order.items.isNotEmpty ? order.items : 'No item details',
          fontSize: 13,
          fontClr: AppColors.grey700,
        ),
      ];
    }
    final rows = <Widget>[];
    for (var i = 0; i < order.itemList.length; i++) {
      final item = order.itemList[i];
      rows.add(_buildOrderItem(
        '${item.name} x${item.quantity}',
        '₦${item.lineTotal.toStringAsFixed(0)}',
      ));
      if (i != order.itemList.length - 1) {
        rows.add(const Divider(height: 20));
      }
    }
    return rows;
  }

  List<Widget> _buildActions() {
    if (_updating) return [loadingCircle(28)];
    if (order.status == 'Pending') {
      return [
        NiceButton(
          padding: EdgeInsets.zero,
          btnText: 'Mark as Processing',
          borderRadius: BorderRadius.circular(14),
          canContinue: true,
          onPressed: () => _setStatus('Processing'),
        ),
        const Gap(10),
        NiceButton(
          padding: EdgeInsets.zero,
          btnText: 'Cancel Order',
          borderRadius: BorderRadius.circular(14),
          canContinue: true,
          loadingClr: AppColors.red,
          onPressed: () => _setStatus('Cancelled', bgColor: AppColors.red),
        ),
      ];
    } else if (order.status == 'Processing') {
      return [
        NiceButton(
          padding: EdgeInsets.zero,
          btnText: 'Mark as Delivered',
          borderRadius: BorderRadius.circular(14),
          canContinue: true,
          onPressed: () => _setStatus('Delivered', bgColor: AppColors.success),
        ),
      ];
    }
    return [];
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
