import 'package:shopowner_mobile_app/data/models/order_model.dart';

class RevenueBar {
  final String label;
  final double amount;

  const RevenueBar({required this.label, required this.amount});

  factory RevenueBar.fromJson(Map<String, dynamic> json) {
    return RevenueBar(
      label: json['label']?.toString() ?? '',
      amount: double.tryParse('${json['amount']}') ?? 0,
    );
  }
}

class DashboardModel {
  final double totalSales;
  final int orders;
  final int products;
  final int customers;

  final double thisMonth;
  final double changePct;
  final List<RevenueBar> weekly;

  final List<OrderModel> recentOrders;

  const DashboardModel({
    required this.totalSales,
    required this.orders,
    required this.products,
    required this.customers,
    required this.thisMonth,
    required this.changePct,
    required this.weekly,
    required this.recentOrders,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    final stats = Map<String, dynamic>.from(json['stats'] ?? {});
    final revenue = Map<String, dynamic>.from(json['revenue'] ?? {});
    final recent = (json['recent_orders'] as List?) ?? const [];
    final weekly = (revenue['weekly'] as List?) ?? const [];

    return DashboardModel(
      totalSales: double.tryParse('${stats['total_sales']}') ?? 0,
      orders: stats['orders'] is int
          ? stats['orders']
          : int.tryParse('${stats['orders']}') ?? 0,
      products: stats['products'] is int
          ? stats['products']
          : int.tryParse('${stats['products']}') ?? 0,
      customers: stats['customers'] is int
          ? stats['customers']
          : int.tryParse('${stats['customers']}') ?? 0,
      thisMonth: double.tryParse('${revenue['this_month']}') ?? 0,
      changePct: double.tryParse('${revenue['change_pct']}') ?? 0,
      weekly: weekly
          .map((e) => RevenueBar.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      recentOrders: recent
          .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}
