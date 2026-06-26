import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/data/models/dashboard_model.dart';

class DashboardRepository {
  final _dio = ApiClient.instance.dio;

  Future<DashboardModel> fetch() async {
    final res = await _dio.get('/dashboard/');
    return DashboardModel.fromJson(Map<String, dynamic>.from(res.data));
  }
}
