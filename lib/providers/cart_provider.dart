import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order_model.dart';
import '../models/gi_product_model.dart';
import '../services/order_service.dart';
import '../services/supabase_service.dart';
import 'auth_provider.dart';

final orderServiceProvider = Provider<OrderService>((ref) => OrderService());

class CartNotifier extends StateNotifier<List<OrderItemModel>> {
  final OrderService _orderService;
  static const String _storageKey = 'virasat_user_cart_json';
  StreamSubscription? _realtimeSub;
  String? _activeBuyerId;

  CartNotifier(this._orderService) : super([]) {
    state = _orderService.cartItems;
    _initCart();
  }

  Future<void> _initCart() async {
    await _loadFromLocal();
    await loadCartForUser();
  }

  String _resolveBuyerId([String? customId]) {
    if (customId != null && customId.isNotEmpty && customId != 'guest_user') {
      return customId;
    }
    final supaUser = SupabaseService.client.auth.currentUser;
    if (supaUser?.id != null && supaUser!.id.isNotEmpty) {
      return supaUser.id;
    }
    if (supaUser?.email != null && supaUser!.email!.isNotEmpty) {
      return supaUser.email!;
    }
    return '9af21e46-2791-43f2-bab8-67b3e87425c3';
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final List<OrderItemModel> items = decoded
            .map((e) => OrderItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (items.isNotEmpty && state.isEmpty) {
          for (var item in items) {
            _orderService.addToCart(item.product, quantity: item.quantity);
          }
          state = List.from(_orderService.cartItems);
          debugPrint('[CartNotifier] Restored ${items.length} cart items from local SharedPreferences');
        }
      }
    } catch (e) {
      debugPrint('[CartNotifier] Error loading local cart: $e');
    }
  }

  Future<void> _saveToLocal(List<OrderItemModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('[CartNotifier] Error saving local cart: $e');
    }
  }

  Future<void> loadCartForUser([String? customBuyerId]) async {
    final buyerId = _resolveBuyerId(customBuyerId);
    _activeBuyerId = buyerId;
    
    try {
      final itemsMap = await SupabaseService.getCartItems(buyerId);
      final List<OrderItemModel> loaded = itemsMap.map((map) {
        final product = map['product'] as GiProductModel;
        final quantity = (map['quantity'] as num).toInt();
        return OrderItemModel(product: product, quantity: quantity);
      }).toList();

      _orderService.clearCart();
      for (var item in loaded) {
        _orderService.addToCart(item.product, quantity: item.quantity);
      }
      state = List.from(_orderService.cartItems);
      _saveToLocal(state);
      debugPrint('[CartNotifier] Loaded ${loaded.length} cart items from Supabase DB for $buyerId');
      _subscribeRealtime(buyerId);
    } catch (e) {
      debugPrint('[CartNotifier] Error loading Supabase cart: $e');
    }
  }

  void _subscribeRealtime(String buyerId) {
    _realtimeSub?.cancel();
    try {
      _realtimeSub = SupabaseService.streamCart(buyerId).listen((_) async {
        debugPrint('[CartNotifier] Supabase Realtime cart update detected for $buyerId!');
        final itemsMap = await SupabaseService.getCartItems(buyerId);
        final List<OrderItemModel> loaded = itemsMap.map((map) {
          final product = map['product'] as GiProductModel;
          final quantity = (map['quantity'] as num).toInt();
          return OrderItemModel(product: product, quantity: quantity);
        }).toList();

        _orderService.clearCart();
        for (var item in loaded) {
          _orderService.addToCart(item.product, quantity: item.quantity);
        }
        state = List.from(_orderService.cartItems);
        _saveToLocal(state);
      }, onError: (err) {
        debugPrint('[CartNotifier] Realtime cart notice: $err');
      });
    } catch (_) {}
  }

  List<OrderItemModel> get activeItems => state.where((item) => !item.isSavedForLater).toList();
  List<OrderItemModel> get savedForLaterItems => state.where((item) => item.isSavedForLater).toList();
  int get totalItemsCount => activeItems.fold(0, (sum, item) => sum + item.quantity);

  void addToCart(GiProductModel product, {int quantity = 1}) {
    _orderService.addToCart(product, quantity: quantity);
    state = List.from(_orderService.cartItems);
    _saveToLocal(state);
    final buyerId = _resolveBuyerId(_activeBuyerId);
    SupabaseService.addToCart(buyerId, product, quantity: quantity);
  }

  void removeFromCart(String productId) {
    _orderService.removeFromCart(productId);
    state = List.from(_orderService.cartItems);
    _saveToLocal(state);
    final buyerId = _resolveBuyerId(_activeBuyerId);
    SupabaseService.removeFromCart(buyerId, productId);
  }

  void updateQuantity(String productId, int delta) {
    _orderService.updateQuantity(productId, delta);
    state = List.from(_orderService.cartItems);
    _saveToLocal(state);
  }

  void toggleSaveForLater(String productId) {
    _orderService.toggleSaveForLater(productId);
    state = List.from(_orderService.cartItems);
    _saveToLocal(state);
  }

  double get totalAmount => activeItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get subtotal => totalAmount;
  double get certificateFee => activeItems.isEmpty ? 0.0 : 99.0;
  double get deliveryFee => activeItems.isEmpty ? 0.0 : 150.0;
  double get grandTotal => activeItems.isEmpty ? 0.0 : (subtotal + certificateFee + deliveryFee);

  void clearCart() {
    _orderService.clearCart();
    state = const [];
    _saveToLocal([]);
    final buyerId = _resolveBuyerId(_activeBuyerId);
    SupabaseService.clearCart(buyerId);
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<OrderItemModel>>((ref) {
  final notifier = CartNotifier(ref.watch(orderServiceProvider));
  
  // Re-sync cart from Supabase whenever user logs in or auth state changes
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next.isAuthenticated && next.user.id.isNotEmpty && next.user.id != 'guest_user') {
      notifier.loadCartForUser(next.user.id);
    } else if (next.user.email.isNotEmpty) {
      notifier.loadCartForUser(next.user.email);
    }
  });
  
  return notifier;
});
