import 'package:shopowner_mobile_app/core/network/api_client.dart';
import 'package:shopowner_mobile_app/presentation/auth/models/auth_model.dart';

class AuthRepository {
  final _dio = ApiClient.instance.dio;

  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post('/auth/login/', data: {
      'email': email,
      'password': password,
    });
    return AuthModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<AuthModel> register({
    required String email,
    required String password,
    required String shopName,
    required String market,
    required String subMarket,
    required String country,
    required String state,
  }) async {
    final res = await _dio.post('/auth/register/', data: {
      'email': email,
      'password': password,
      'shop_name': shopName,
      'market': market,
      'sub_market': subMarket,
      'country': country,
      'state': state,
    });
    return AuthModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<AuthModel> profile() async {
    final res = await _dio.get('/auth/profile/');
    return AuthModel.fromJson(Map<String, dynamic>.from(res.data));
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout/');
    } catch (_) {
      // Token may already be invalid — clearing local state is enough.
    }
  }
}
