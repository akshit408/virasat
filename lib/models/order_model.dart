import 'gi_product_model.dart';

enum OrderStatus { placed, processing, shipped, delivered, cancelled }

class OrderItemModel {
  final GiProductModel product;
  final int quantity;
  final bool isSavedForLater;

  const OrderItemModel({
    required this.product,
    required this.quantity,
    this.isSavedForLater = false,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      product: GiProductModel.fromJson(json['product'] as Map<String, dynamic>? ?? {}),
      quantity: json['quantity'] as int? ?? 1,
      isSavedForLater: json['isSavedForLater'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'isSavedForLater': isSavedForLater,
    };
  }

  OrderItemModel copyWith({
    GiProductModel? product,
    int? quantity,
    bool? isSavedForLater,
  }) {
    return OrderItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      isSavedForLater: isSavedForLater ?? this.isSavedForLater,
    );
  }

  double get totalPrice => product.price * quantity;
}

class OrderModel {
  final String id;
  final List<OrderItemModel> items;
  final double totalAmount;
  final DateTime orderDate;
  final OrderStatus status;
  final String shippingAddress;
  final String trackingId;

  const OrderModel({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    required this.shippingAddress,
    required this.trackingId,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['status'] as String? ?? 'placed').toLowerCase();
    OrderStatus parsedStatus = OrderStatus.placed;
    if (rawStatus == 'processing') parsedStatus = OrderStatus.processing;
    if (rawStatus == 'shipped') parsedStatus = OrderStatus.shipped;
    if (rawStatus == 'delivered') parsedStatus = OrderStatus.delivered;
    if (rawStatus == 'cancelled') parsedStatus = OrderStatus.cancelled;

    return OrderModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      orderDate: json['orderDate'] != null
          ? DateTime.tryParse(json['orderDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      status: parsedStatus,
      shippingAddress: json['shippingAddress'] as String? ?? '',
      trackingId: json['trackingId'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => e.toJson()).toList(),
      'totalAmount': totalAmount,
      'orderDate': orderDate.toIso8601String(),
      'status': status.name,
      'shippingAddress': shippingAddress,
      'trackingId': trackingId,
    };
  }
}
