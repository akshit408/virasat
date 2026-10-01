import '../models/order_model.dart';
import '../models/gi_product_model.dart';
import '../services/supabase_service.dart';

class OrderService {
  final List<OrderItemModel> _cart = [];
  final List<OrderModel> _orders = [];

  List<OrderItemModel> get cartItems => List.unmodifiable(_cart);

  double get cartTotal {
    return _cart.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addToCart(GiProductModel product, {int quantity = 1}) {
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _cart[index] = OrderItemModel(
        product: product,
        quantity: _cart[index].quantity + quantity,
      );
    } else {
      _cart.add(OrderItemModel(product: product, quantity: quantity));
    }
    final buyerId = SupabaseService.client.auth.currentUser?.id ?? '9af21e46-2791-43f2-bab8-67b3e87425c3';
    SupabaseService.addToCart(buyerId, product, quantity: quantity);
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    final buyerId = SupabaseService.client.auth.currentUser?.id ?? '9af21e46-2791-43f2-bab8-67b3e87425c3';
    SupabaseService.removeFromCart(buyerId, productId);
  }

  void updateQuantity(String productId, int delta) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final newQty = _cart[index].quantity + delta;
      final buyerId = SupabaseService.client.auth.currentUser?.id ?? '9af21e46-2791-43f2-bab8-67b3e87425c3';
      if (newQty <= 0) {
        final prodId = _cart[index].product.id;
        _cart.removeAt(index);
        SupabaseService.removeFromCart(buyerId, prodId);
      } else {
        _cart[index] = _cart[index].copyWith(quantity: newQty);
        SupabaseService.addToCart(buyerId, _cart[index].product, quantity: newQty);
      }
    }
  }

  void toggleSaveForLater(String productId) {
    final index = _cart.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _cart[index] = _cart[index].copyWith(isSavedForLater: !_cart[index].isSavedForLater);
    }
  }

  void clearCart() {
    _cart.clear();
    final buyerId = SupabaseService.client.auth.currentUser?.id ?? '9af21e46-2791-43f2-bab8-67b3e87425c3';
    SupabaseService.clearCart(buyerId);
  }

  Future<OrderModel> placeOrder(String shippingAddress) async {
    final orderNum = 'VIR-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final buyerId = SupabaseService.client.auth.currentUser?.id ?? '9af21e46-2791-43f2-bab8-67b3e87425c3';
    
    for (var item in _cart) {
      await SupabaseService.createOrder(
        orderNumber: orderNum,
        buyerId: buyerId,
        product: item.product,
        artisanId: item.product.artisanId.isNotEmpty ? item.product.artisanId : null,
        quantity: item.quantity,
        totalAmount: item.totalPrice,
        shippingAddress: shippingAddress,
      );
    }

    final order = OrderModel(
      id: orderNum,
      items: List.from(_cart),
      totalAmount: cartTotal,
      orderDate: DateTime.now(),
      status: OrderStatus.processing,
      shippingAddress: shippingAddress,
      trackingId: 'IP-ARTISAN-$orderNum',
    );
    _orders.insert(0, order);
    _cart.clear();
    return order;
  }

  Future<List<OrderModel>> getOrderHistory() async {
    final buyerId = SupabaseService.client.auth.currentUser?.id;
    if (buyerId != null && buyerId.isNotEmpty) {
      try {
        final res = await SupabaseService.client
            .from('orders')
            .select('*, products(*)')
            .eq('buyer_id', buyerId)
            .order('created_at', ascending: false);
            
        if ((res as List).isNotEmpty) {
          final List<OrderModel> supaOrders = [];
          for (var row in res) {
            final productMap = row['products'];
            GiProductModel? product;
            if (productMap != null) {
              product = GiProductModel.fromJson(productMap as Map<String, dynamic>);
            }
            if (product != null) {
              supaOrders.add(OrderModel(
                id: row['order_number'] ?? row['id'],
                items: [OrderItemModel(product: product, quantity: row['quantity'] ?? 1)],
                totalAmount: (row['total_amount'] as num?)?.toDouble() ?? 0.0,
                orderDate: DateTime.tryParse(row['created_at'] ?? '') ?? DateTime.now(),
                status: _parseStatus(row['status']),
                shippingAddress: row['shipping_address'] ?? 'Registered Address',
                trackingId: row['tracking_number'] ?? 'IP-ARTISAN-${row['id']}',
              ));
            }
          }
          if (supaOrders.isNotEmpty) return supaOrders;
        }
      } catch (_) {}
    }
    return _orders;
  }

  OrderStatus _parseStatus(String? status) {
    switch (status?.toUpperCase()) {
      case 'ACCEPTED':
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'PACKED':
      case 'SHIPPED':
        return OrderStatus.shipped;
      case 'DELIVERED':
        return OrderStatus.delivered;
      case 'CANCELLED':
      case 'REJECTED':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.placed;
    }
  }
}
