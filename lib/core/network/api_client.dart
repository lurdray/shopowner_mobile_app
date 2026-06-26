import 'package:dio/dio.dart';

import 'package:shopowner_mobile_app/core/network/api_config.dart';
import 'package:shopowner_mobile_app/core/utils/app_funcs.dart';

/// Holds the auth token in memory so the Dio interceptor can attach it to every
/// request. [AuthCubit] keeps this in sync (on login, session-restore, logout).
class TokenStore {
  static String? token;

  static void set(String? value) => token = value;
  static void clear() => token = null;
}

/// A thin wrapper around a configured Dio instance shared by all repositories.
class ApiClient {
  ApiClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: kApiBaseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = TokenStore.token;
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Token $token';
          }
          shopOwnerLogger('${options.method} ${options.uri}', logType: 'API');
          handler.next(options);
        },
        onError: (e, handler) {
          shopOwnerLogger(
            '${e.requestOptions.uri} -> ${e.response?.statusCode} ${e.response?.data}',
            logType: 'API',
            isError: true,
          );
          handler.next(e);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._();
  late final Dio _dio;

  Dio get dio => _dio;

  /// Turn a Dio error into a human-readable message for the UI.
  static String messageFromError(Object error) {
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        if (data['detail'] != null) return data['detail'].toString();
        // DRF field errors: {"email": ["already exists"]}
        for (final value in data.values) {
          if (value is List && value.isNotEmpty) return value.first.toString();
          if (value is String) return value;
        }
      }
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.connectionError) {
        return 'Cannot reach the server. Is the backend running?';
      }
      return error.message ?? 'Something went wrong.';
    }
    return error.toString();
  }
}
