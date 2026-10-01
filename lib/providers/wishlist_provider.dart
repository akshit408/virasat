import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gi_product_model.dart';
import '../services/supabase_service.dart';
import 'auth_provider.dart';

class WishlistNotifier extends StateNotifier<List<GiProductModel>> {
  static const String _storageKey = 'virasat_user_wishlist_json';
  StreamSubscription? _realtimeSub;
  String? _activeBuyerId;

  WishlistNotifier() : super([]) {
    _initWishlist();
  }

  Future<void> _initWishlist() async {
    await _loadFromLocal();
    await loadWishlist();
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
        final products = decoded.map((e) => GiProductModel.fromJson(e as Map<String, dynamic>)).toList();
        if (products.isNotEmpty && state.isEmpty) {
          state = products;
          debugPrint('[WishlistNotifier] Restored ${products.length} products from local SharedPreferences');
        }
      }
    } catch (e) {
      debugPrint('[WishlistNotifier] Error loading local wishlist: $e');
    }
  }

  Future<void> _saveToLocal(List<GiProductModel> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(products.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('[WishlistNotifier] Error saving local wishlist: $e');
    }
  }

  Future<void> loadWishlist([String? customBuyerId]) async {
    final buyerId = _resolveBuyerId(customBuyerId);
    _activeBuyerId = buyerId;
    
    try {
      final products = await SupabaseService.getWishlistProducts(buyerId);
      state = products;
      await _saveToLocal(products);
      debugPrint('[WishlistNotifier] Synced ${products.length} items from Supabase DB for $buyerId');
      _subscribeRealtime(buyerId);
    } catch (e) {
      debugPrint('[WishlistNotifier] Supabase sync warning: $e');
    }
  }

  void _subscribeRealtime(String buyerId) {
    _realtimeSub?.cancel();
    try {
      _realtimeSub = SupabaseService.streamWishlist(buyerId).listen((_) async {
        debugPrint('[WishlistNotifier] Supabase Realtime update detected for $buyerId!');
        final freshProducts = await SupabaseService.getWishlistProducts(buyerId);
        state = freshProducts;
        _saveToLocal(freshProducts);
      }, onError: (err) {
        debugPrint('[WishlistNotifier] Realtime stream notice: $err');
      });
    } catch (_) {}
  }

  void toggleWishlist(GiProductModel product) {
    final buyerId = _resolveBuyerId(_activeBuyerId);
    if (state.any((p) => p.id == product.id)) {
      state = state.where((p) => p.id != product.id).toList();
      _saveToLocal(state);
      SupabaseService.removeFromWishlist(buyerId, product.id);
    } else {
      state = [...state, product];
      _saveToLocal(state);
      SupabaseService.addToWishlist(buyerId, product);
    }
  }

  void removeFromWishlist(String productId) {
    state = state.where((p) => p.id != productId).toList();
    _saveToLocal(state);
    final buyerId = _resolveBuyerId(_activeBuyerId);
    SupabaseService.removeFromWishlist(buyerId, productId);
  }

  void clearWishlist() {
    state = const [];
    _saveToLocal([]);
  }

  bool isWishlisted(String productId) {
    return state.any((p) => p.id == productId);
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}

final wishlistProvider = StateNotifierProvider<WishlistNotifier, List<GiProductModel>>((ref) {
  final notifier = WishlistNotifier();
  
  // Re-sync wishlist from Supabase whenever user logs in or auth state changes
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next.isAuthenticated && next.user.id.isNotEmpty && next.user.id != 'guest_user') {
      notifier.loadWishlist(next.user.id);
    } else if (next.user.email.isNotEmpty) {
      notifier.loadWishlist(next.user.email);
    }
  });
  
  return notifier;
});
