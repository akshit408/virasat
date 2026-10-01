import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/gi_product_model.dart';
import '../services/supabase_service.dart';

enum UserRoleMode { buyer, artisan }

class RoleModeNotifier extends StateNotifier<UserRoleMode> {
  RoleModeNotifier() : super(UserRoleMode.buyer) {
    _loadSavedRole();
  }

  Future<void> _loadSavedRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final roleStr = prefs.getString('user_role_mode');
      if (roleStr == 'artisan') {
        state = UserRoleMode.artisan;
      } else {
        state = UserRoleMode.buyer;
      }
    } catch (_) {}
  }

  Future<void> setRole(UserRoleMode role) async {
    state = role;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_role_mode', role == UserRoleMode.artisan ? 'artisan' : 'buyer');
    } catch (_) {}
  }
}

final roleModeProvider = StateNotifierProvider<RoleModeNotifier, UserRoleMode>((ref) {
  return RoleModeNotifier();
});

// Artisan Published Products State
// Artisan Published Products State
class ArtisanProductsNotifier extends StateNotifier<List<GiProductModel>> {
  static const String _storageKey = 'virasat_user_published_products';

  ArtisanProductsNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    await _loadFromLocal();
    await fetchProducts();
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final List<GiProductModel> items = decoded
            .map((e) => GiProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (items.isNotEmpty) {
          final seenIds = <String>{};
          final merged = <GiProductModel>[];
          for (final item in [...items, ...state]) {
            if (seenIds.add(item.id)) {
              merged.add(item);
            }
          }
          state = merged;
          for (final item in items) {
            SupabaseService.registerUserAddedProduct(item);
          }
        }
      }
    } catch (e) {
      debugPrint('[ArtisanProductsNotifier] Error loading local products: $e');
    }
  }

  Future<void> _saveToLocal(List<GiProductModel> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('[ArtisanProductsNotifier] Error saving local products: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final supaUser = SupabaseService.client.auth.currentUser;
      final currentUserId = supaUser?.id ?? '524536a0-db7e-4d49-8e17-82c6770e2ccd';
      final supaProducts = await SupabaseService.getArtisanProducts(currentUserId);
      final seenIds = <String>{};
      final merged = <GiProductModel>[];
      for (final item in [...state, ...supaProducts]) {
        if (seenIds.add(item.id)) {
          merged.add(item);
        }
      }
      state = merged;
      _saveToLocal(state);
    } catch (e) {
      debugPrint('[ArtisanProductsNotifier] fetchProducts error: $e');
    }
  }

  void addProduct(GiProductModel craft) {
    final seenIds = <String>{craft.id};
    state = [craft, ...state.where((item) => seenIds.add(item.id))];
    _saveToLocal(state);
    SupabaseService.registerUserAddedProduct(craft);
  }

  void updateProduct(GiProductModel craft) {
    state = state.map((c) => c.id == craft.id ? craft : c).toList();
    _saveToLocal(state);
  }

  void deleteProduct(String craftId) {
    state = state.where((c) => c.id != craftId).toList();
    _saveToLocal(state);
  }

  void duplicateProduct(GiProductModel craft) {
    final dup = craft.copyWith(
      id: 'art_craft_${DateTime.now().millisecondsSinceEpoch}',
      name: '${craft.name} (Copy)',
    );
    state = [dup, ...state];
    _saveToLocal(state);
    SupabaseService.registerUserAddedProduct(dup);
  }
}

final artisanProductsProvider = StateNotifierProvider<ArtisanProductsNotifier, List<GiProductModel>>((ref) {
  return ArtisanProductsNotifier();
});

// Artisan Order Model
class ArtisanOrder {
  final String orderId;
  final String buyerName;
  final String craftName;
  final String price;
  final int quantity;
  final String status; // Pending, Accepted, Packed, Shipped, Delivered, Cancelled
  final String date;
  final String buyerLocation;
  final String? buyerId;

  const ArtisanOrder({
    required this.orderId,
    required this.buyerName,
    required this.craftName,
    required this.price,
    required this.quantity,
    required this.status,
    required this.date,
    required this.buyerLocation,
    this.buyerId,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'buyerName': buyerName,
      'craftName': craftName,
      'price': price,
      'quantity': quantity,
      'status': status,
      'date': date,
      'buyerLocation': buyerLocation,
      'buyerId': buyerId,
    };
  }

  factory ArtisanOrder.fromJson(Map<String, dynamic> json) {
    return ArtisanOrder(
      orderId: json['orderId'] as String? ?? '',
      buyerName: json['buyerName'] as String? ?? 'Verified Buyer',
      craftName: json['craftName'] as String? ?? 'Handcrafted Heritage Art',
      price: json['price'] as String? ?? '₹ 0',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      status: json['status'] as String? ?? 'Pending',
      date: json['date'] as String? ?? 'Today',
      buyerLocation: json['buyerLocation'] as String? ?? 'India',
      buyerId: json['buyerId'] as String?,
    );
  }

  ArtisanOrder copyWith({
    String? orderId,
    String? buyerName,
    String? craftName,
    String? price,
    int? quantity,
    String? status,
    String? date,
    String? buyerLocation,
    String? buyerId,
  }) {
    return ArtisanOrder(
      orderId: orderId ?? this.orderId,
      buyerName: buyerName ?? this.buyerName,
      craftName: craftName ?? this.craftName,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      status: status ?? this.status,
      date: date ?? this.date,
      buyerLocation: buyerLocation ?? this.buyerLocation,
      buyerId: buyerId ?? this.buyerId,
    );
  }
}

// Artisan Orders State
class ArtisanOrdersNotifier extends StateNotifier<List<ArtisanOrder>> {
  static const String _storageKey = 'virasat_user_orders';

  ArtisanOrdersNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    await _loadFromLocal();
    await fetchOrders();
    _listenRealtimeOrders();
  }

  Future<void> _loadFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_storageKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(jsonStr);
        final List<ArtisanOrder> items = decoded
            .map((e) => ArtisanOrder.fromJson(e as Map<String, dynamic>))
            .toList();
        if (items.isNotEmpty) {
          final seenIds = <String>{};
          final merged = <ArtisanOrder>[];
          for (final item in [...items, ...state]) {
            if (seenIds.add(item.orderId)) {
              merged.add(item);
            }
          }
          state = merged;
        }
      }
    } catch (e) {
      debugPrint('[ArtisanOrdersNotifier] Error loading local orders: $e');
    }
  }

  Future<void> _saveToLocal(List<ArtisanOrder> items) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(items.map((i) => i.toJson()).toList());
      await prefs.setString(_storageKey, jsonStr);
    } catch (e) {
      debugPrint('[ArtisanOrdersNotifier] Error saving local orders: $e');
    }
  }

  void _listenRealtimeOrders() {
    try {
      final currentUserId = SupabaseService.client.auth.currentUser?.id;
      if (currentUserId != null && currentUserId.isNotEmpty) {
        SupabaseService.client
            .from('orders')
            .stream(primaryKey: ['id'])
            .eq('artisan_id', currentUserId)
            .listen((_) => fetchOrders());
      } else {
        SupabaseService.client
            .from('orders')
            .stream(primaryKey: ['id'])
            .listen((_) => fetchOrders());
      }
    } catch (_) {}
  }

  Future<void> fetchOrders() async {
    try {
      final currentUserId = SupabaseService.client.auth.currentUser?.id;
      String? resolvedId;
      if (currentUserId != null && currentUserId.isNotEmpty) {
        resolvedId = await SupabaseService.resolveArtisanDbId(currentUserId);
      }

      dynamic res;
      if (currentUserId != null && currentUserId.isNotEmpty) {
        res = await SupabaseService.client
            .from('orders')
            .select('*, products(*), users(*)')
            .or('artisan_id.eq.$currentUserId,artisan_id.eq.$resolvedId,buyer_id.eq.$currentUserId')
            .order('created_at', ascending: false);

        if (res == null || (res as List).isEmpty) {
          res = await SupabaseService.client
              .from('orders')
              .select('*, products(*), users(*)')
              .order('created_at', ascending: false);
        }
      } else {
        res = await SupabaseService.client
            .from('orders')
            .select('*, products(*), users(*)')
            .order('created_at', ascending: false);
      }

      final List<ArtisanOrder> orders = [];
      if (res != null && (res as List).isNotEmpty) {
        for (var row in res) {
          final prod = row['products'];
          final buyer = row['users'];
          orders.add(ArtisanOrder(
            orderId: row['order_number'] ?? row['id'],
            buyerName: buyer?['full_name'] ?? buyer?['display_name'] ?? 'Verified Buyer',
            craftName: prod?['title'] ?? 'Handcrafted Heritage Art',
            price: '₹ ${(row['total_amount'] as num?)?.toStringAsFixed(0) ?? '0'}',
            quantity: row['quantity'] ?? 1,
            status: row['status'] ?? 'Pending',
            date: row['created_at']?.toString().split('T').first ?? 'Today',
            buyerLocation: (row['shipping_address'] as String?)?.trim().isNotEmpty == true
                ? row['shipping_address']
                : ((buyer?['state'] as String?)?.trim().isNotEmpty == true ? buyer!['state'] : 'India'),
            buyerId: row['buyer_id'],
          ));
        }
      }
      final seenIds = <String>{};
      final merged = <ArtisanOrder>[];
      for (final item in [...state, ...orders]) {
        if (seenIds.add(item.orderId)) {
          merged.add(item);
        }
      }
      state = merged;
      _saveToLocal(state);
    } catch (e) {
      debugPrint('[ArtisanOrdersNotifier] fetchOrders error: $e');
    }
  }

  double get totalEarnings {
    double earnings = 48500.0;
    for (final o in state) {
      final s = o.status.toLowerCase();
      if (s == 'accepted' || s == 'packed' || s == 'shipped' || s == 'delivered' || s == 'processing' || s == 'paid') {
        final clean = o.price.replaceAll(RegExp(r'[^0-9.]'), '');
        final val = double.tryParse(clean) ?? 0.0;
        earnings += val * 0.84;
      }
    }
    return earnings;
  }

  void addOrder(ArtisanOrder order) {
    final seenIds = <String>{};
    final merged = <ArtisanOrder>[];
    for (final item in [order, ...state]) {
      if (seenIds.add(item.orderId)) {
        merged.add(item);
      }
    }
    state = merged;
    _saveToLocal(state);
  }

  void acceptOrder(String orderId) {
    SupabaseService.acceptOrder(orderId);
    updateOrderStatus(orderId, 'Accepted');
  }

  void rejectOrder(String orderId) {
    SupabaseService.rejectOrder(orderId);
    updateOrderStatus(orderId, 'Rejected');
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    ArtisanOrder? targetOrder;
    state = state.map((o) {
      if (o.orderId == orderId) {
        targetOrder = o.copyWith(status: newStatus);
        return targetOrder!;
      }
      return o;
    }).toList();

    try {
      await SupabaseService.updateOrderStatus(
        orderId,
        newStatus,
        buyerId: targetOrder?.buyerId,
        orderNumber: targetOrder?.orderId ?? orderId,
      );
    } catch (_) {}
  }
}

final artisanOrdersProvider = StateNotifierProvider<ArtisanOrdersNotifier, List<ArtisanOrder>>((ref) {
  return ArtisanOrdersNotifier();
});

// Women's & Community Collectives State
class CollectiveModel {
  final String id;
  final String name;
  final String region;
  final int memberCount;
  final String craftType;
  final String bannerImage;
  final bool isVerified;
  final String description;

  const CollectiveModel({
    required this.id,
    required this.name,
    required this.region,
    required this.memberCount,
    required this.craftType,
    required this.bannerImage,
    this.isVerified = true,
    required this.description,
  });
}

class CollectivesNotifier extends StateNotifier<List<CollectiveModel>> {
  CollectivesNotifier() : super(_initialCollectives);

  static final List<CollectiveModel> _initialCollectives = [
    const CollectiveModel(
      id: 'coll_1',
      name: 'Kutch Mahila Vikas Sangathan (KMVS)',
      region: 'Kutch, Gujarat',
      memberCount: 1250,
      craftType: 'Bandhani & Mirrorwork Embroidery',
      bannerImage: 'assets/images/discover/women_collectives.jpg',
      description: 'Empowering over 1,200 rural women artisans through fair trade wage guarantees and craft preservation.',
    ),
    const CollectiveModel(
      id: 'coll_2',
      name: 'Mithila Mahila Kala Samiti',
      region: 'Madhubani, Bihar',
      memberCount: 840,
      craftType: 'Madhubani Folk Paintings & Papier-Mâché',
      bannerImage: 'assets/images/banners/banner_madhubani.jpg',
      description: 'Preserving ancient sacred Mithila art forms created by women artisans across 14 Bihar villages.',
    ),
    const CollectiveModel(
      id: 'coll_3',
      name: 'Self-Employed Women Artisans Society',
      region: 'Lucknow, Uttar Pradesh',
      memberCount: 2100,
      craftType: 'Chikankari Delicate Hand Embroidery',
      bannerImage: 'assets/images/crafts/chikankari_01.jpg',
      description: 'Supporting 2,100 women embroiderers with direct digital commerce and health security.',
    ),
  ];

  void addCollective(CollectiveModel collective) {
    state = [collective, ...state];
  }
}

final collectivesProvider = StateNotifierProvider<CollectivesNotifier, List<CollectiveModel>>((ref) {
  return CollectivesNotifier();
});
