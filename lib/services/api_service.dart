import 'package:dio/dio.dart';
import '../core/config/env_config.dart';

class ApiService {
  late final Dio _dio;

  ApiService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.backendBaseUrl,
        connectTimeout: const Duration(milliseconds: EnvConfig.connectTimeout),
        receiveTimeout: const Duration(milliseconds: EnvConfig.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Client-App': EnvConfig.appName,
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Attach Bearer token if available
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

  // Collection-based GET endpoint
  Future<Response> getCollection(String collectionName, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get('/$collectionName', queryParameters: queryParams);
  }

  // Collection-based POST endpoint
  Future<Response> createDocument(String collectionName, Map<String, dynamic> data) async {
    return await _dio.post('/$collectionName', data: data);
  }

  // Collection-based GET by ID endpoint
  Future<Response> getDocumentById(String collectionName, String id) async {
    return await _dio.get('/$collectionName/$id');
  }

  // Collection-based PUT/PATCH endpoint
  Future<Response> updateDocument(String collectionName, String id, Map<String, dynamic> data) async {
    return await _dio.patch('/$collectionName/$id', data: data);
  }

  // Collection-based DELETE endpoint
  Future<Response> deleteDocument(String collectionName, String id) async {
    return await _dio.delete('/$collectionName/$id');
  }
}
