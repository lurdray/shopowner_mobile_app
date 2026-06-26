import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/order_model.dart';

class OrderRepository {
  final _dio = ApiClient.instance.dio;

  Future<List<OrderModel>> list({String? status, String? search}) async {
    final res = await _dio.get('/orders/', queryParameters: {
      if (status != null && status != 'All') 'status': status,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    final data = res.data as List;
    return data
        .map((e) => OrderModel.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<OrderModel> detail(int pk) async {
    final res = await _dio.get('/orders/$pk/');
    return OrderModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<OrderModel> updateStatus(int pk, String status) async {
    final res = await _dio.post('/orders/$pk/status/', data: {'status': status});
    return OrderModel.fromJson(Map<String, dynamic>.from(res.data));
  }
}
