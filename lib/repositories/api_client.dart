import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/config/env_config.dart';

class ApiClient {
  static String get baseUrl => EnvConfig.backendBaseUrl;

  late final Dio dio;

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 8),
        receiveTimeout: const Duration(seconds: 8),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('auth_token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) {
          if (error.type == DioExceptionType.connectionTimeout ||
              error.type == DioExceptionType.sendTimeout ||
              error.type == DioExceptionType.receiveTimeout ||
              error.type == DioExceptionType.connectionError ||
              error.type == DioExceptionType.unknown) {
            final customError = DioException(
              requestOptions: error.requestOptions,
              response: error.response,
              type: error.type,
              error: 'Unable to connect to Virasat server. Check that your phone and laptop are on the same Wi-Fi.',
              message: 'Unable to connect to Virasat server. Check that your phone and laptop are on the same Wi-Fi.',
            );
            return handler.next(customError);
          }
          return handler.next(error);
        },
      ),
    );
  }

  static final ApiClient _instance = ApiClient();
  static ApiClient get instance => _instance;
}
