import '../models/gi_product_model.dart';
import '../services/supabase_service.dart';

class ProductRepository {
  /// Fetch published products exclusively from Supabase PostgreSQL.
  /// NEVER fall back to local mock endpoints or static arrays.
  Future<List<GiProductModel>> getProducts({
    String? category,
    String? state,
    bool? giTag,
    String? search,
  }) async {
    try {
      return await SupabaseService.getProducts(
        category: category,
        state: state,
        giTag: giTag,
        search: search,
      );
    } catch (_) {
      return [];
    }
  }

  Future<List<GiProductModel>> getFeaturedProducts() async {
    try {
      final supaProducts = await SupabaseService.getProducts();
      return supaProducts.take(10).toList();
    } catch (_) {
      return [];
    }
  }

  Future<GiProductModel?> getProductById(String id) async {
    try {
      return await SupabaseService.getProductById(id);
    } catch (_) {
      return null;
    }
  }
}
