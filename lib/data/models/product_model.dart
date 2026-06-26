class ProductModel {
  final int id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String description;
  final String status; // In Stock / Low Stock / Out of Stock (derived by backend)
  final String? image;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.description,
    required this.status,
    this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      price: double.tryParse('${json['price']}') ?? 0,
      stock: json['stock'] is int
          ? json['stock']
          : int.tryParse('${json['stock']}') ?? 0,
      category: json['category']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'In Stock',
      image: json['image']?.toString(),
    );
  }
}
