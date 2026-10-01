import '../models/gi_product_model.dart';
import 'supabase_service.dart';

class ProductService {
  Future<List<GiProductModel>> getFeaturedProducts() async {
    return await SupabaseService.getProducts();
  }

  Future<List<GiProductModel>> getProductsByCategory(String category) async {
    return await SupabaseService.getProducts(category: category);
  }

  Future<GiProductModel> getProductById(String id) async {
    final product = await SupabaseService.getProductById(id);
    if (product != null) return product;
    final all = await SupabaseService.getProducts();
    if (all.isNotEmpty) return all.first;
    throw Exception('Product not found in Supabase');
  }

  Future<List<GiProductModel>> searchProducts(String query) async {
    return await SupabaseService.getProducts(search: query);
  }

  Future<bool> addProduct(GiProductModel product) async {
    final inserted = await SupabaseService.insertProduct(product);
    return inserted != null;
  }

  Future<List<GiProductModel>> getArtisanProducts(String artisanId) async {
    final all = await SupabaseService.getProducts();
    if (artisanId.isEmpty) return all;
    return all.where((p) => p.artisanId == artisanId || p.sellerName == artisanId).toList();
  }
}
