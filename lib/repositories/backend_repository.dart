import '../core/config/env_config.dart';
import '../models/gi_product_model.dart';
import '../models/user_model.dart';
import '../models/artisan_model.dart';
import '../models/seller_verification_model.dart';
import '../models/order_model.dart';
import '../services/api_service.dart';

class VirasatBackendRepository {
  final ApiService _apiService;

  VirasatBackendRepository(this._apiService);

  // 1. USERS COLLECTION
  Future<UserModel?> getUserProfile(String userId) async {
    try {
      final res = await _apiService.getDocumentById(EnvConfig.usersCollection, userId);
      if (res.statusCode == 200 && res.data != null) {
        return UserModel.fromJson(res.data as Map<String, dynamic>);
      }
    } catch (_) {}
    return null;
  }

  // 2. PRODUCTS COLLECTION
  Future<List<GiProductModel>> fetchProducts({String? category, String? state}) async {
    try {
      final query = <String, dynamic>{};
      if (category != null) query['category'] = category;
      if (state != null) query['state'] = state;

      final res = await _apiService.getCollection(EnvConfig.productsCollection, queryParams: query);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map((e) => GiProductModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return const [];
  }

  // 3. ARTISANS COLLECTION
  Future<List<ArtisanModel>> fetchArtisans() async {
    try {
      final res = await _apiService.getCollection(EnvConfig.artisansCollection);
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map((e) => ArtisanModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return const [];
  }

  // 4. SELLER VERIFICATIONS COLLECTION
  Future<bool> submitSellerVerification(SellerVerificationModel verification) async {
    try {
      final res = await _apiService.createDocument(
        EnvConfig.sellerVerificationsCollection,
        verification.toJson(),
      );
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // 5. WISHLIST COLLECTION
  Future<List<GiProductModel>> fetchUserWishlist(String userId) async {
    try {
      final res = await _apiService.getCollection('${EnvConfig.wishlistCollection}/$userId');
      if (res.statusCode == 200 && res.data is List) {
        return (res.data as List).map((e) => GiProductModel.fromJson(e as Map<String, dynamic>)).toList();
      }
    } catch (_) {}
    return const [];
  }

  // 6. CART COLLECTION
  Future<bool> syncUserCart(String userId, List<OrderItemModel> items) async {
    try {
      final res = await _apiService.createDocument(
        '${EnvConfig.cartCollection}/$userId',
        {'items': items.map((e) => e.toJson()).toList()},
      );
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // 7. ORDERS COLLECTION
  Future<bool> createOrder(OrderModel order) async {
    try {
      final res = await _apiService.createDocument(EnvConfig.ordersCollection, order.toJson());
      return res.statusCode == 201 || res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
