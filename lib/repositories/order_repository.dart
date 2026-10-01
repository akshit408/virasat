import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/order_model.dart';

class OrderRepository {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<OrderModel>> getMyOrders() async {
    try {
      final response = await _dio.get('/orders/my');
      if (response.statusCode == 200 && response.data['orders'] != null) {
        final List list = response.data['orders'];
        return list.map((item) => OrderModel.fromJson(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<OrderModel?> createOrder({
    required List<Map<String, dynamic>> products,
    required Map<String, dynamic> shippingAddress,
    required double totalAmount,
    String? artisanId,
  }) async {
    try {
      final response = await _dio.post('/orders', data: {
        'products': products,
        'shippingAddress': shippingAddress,
        'totalAmount': totalAmount,
        'artisanId': artisanId,
      });

      if (response.statusCode == 201 && response.data['order'] != null) {
        return OrderModel.fromJson(response.data['order']);
      }
    } catch (_) {}
    return null;
  }
}
