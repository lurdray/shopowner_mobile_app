import 'package:dio/dio.dart';

import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/product_model.dart';

class ProductRepository {
  final _dio = ApiClient.instance.dio;

  Future<List<ProductModel>> list({String? status, String? search}) async {
    final res = await _dio.get('/products/', queryParameters: {
      if (status != null && status != 'All') 'status': status,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    final data = res.data as List;
    return data
        .map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<ProductModel> create({
    required String name,
    required double price,
    required int stock,
    required String category,
    String description = '',
    String? imagePath,
  }) async {
    final data = FormData.fromMap({
      'name': name,
      'price': price,
      'stock': stock,
      'category': category,
      'description': description,
      if (imagePath != null && imagePath.isNotEmpty)
        'image': await MultipartFile.fromFile(imagePath),
    });
    final res = await _dio.post('/products/', data: data);
    return ProductModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<ProductModel> update(
    int id, {
    String? name,
    double? price,
    int? stock,
    String? category,
    String? description,
  }) async {
    final res = await _dio.patch('/products/$id/', data: {
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (category != null) 'category': category,
      if (description != null) 'description': description,
    });
    return ProductModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> delete(int id) async {
    await _dio.delete('/products/$id/');
  }
}
