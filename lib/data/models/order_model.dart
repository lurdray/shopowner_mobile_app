class OrderItemModel {
  final String name;
  final int quantity;
  final double price;
  final double lineTotal;

  const OrderItemModel({
    required this.name,
    required this.quantity,
    required this.price,
    required this.lineTotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      name: json['name']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse('${json['quantity']}') ?? 1,
      price: double.tryParse('${json['price']}') ?? 0,
      lineTotal: double.tryParse('${json['line_total']}') ?? 0,
    );
  }
}

class OrderModel {
  /// Numeric primary key used for detail / status endpoints.
  final int pk;

  /// Human-readable order number, e.g. "#ORD-001".
  final String id;
  final String customer;
  final String items; // summary string in list view
  final double total;
  final String date;
  final String status;

  // Detail-only fields (null in list responses)
  final String? customerPhone;
  final String? customerLocation;
  final double? subtotal;
  final double? deliveryFee;
  final List<OrderItemModel> itemList;

  const OrderModel({
    required this.pk,
    required this.id,
    required this.customer,
    required this.items,
    required this.total,
    required this.date,
    required this.status,
    this.customerPhone,
    this.customerLocation,
    this.subtotal,
    this.deliveryFee,
    this.itemList = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return OrderModel(
      pk: json['pk'] is int ? json['pk'] : int.tryParse('${json['pk']}') ?? 0,
      id: json['id']?.toString() ?? '',
      customer: json['customer']?.toString() ?? '',
      // `items` is a summary string in the list endpoint and a list in detail.
      items: rawItems is String ? rawItems : '',
      total: double.tryParse('${json['total']}') ?? 0,
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      customerPhone: json['customer_phone']?.toString(),
      customerLocation: json['customer_location']?.toString(),
      subtotal: json['subtotal'] != null
          ? double.tryParse('${json['subtotal']}')
          : null,
      deliveryFee: json['delivery_fee'] != null
          ? double.tryParse('${json['delivery_fee']}')
          : null,
      itemList: rawItems is List
          ? rawItems
              .map((e) => OrderItemModel.fromJson(Map<String, dynamic>.from(e)))
              .toList()
          : const [],
    );
  }
}
