import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gi_product_model.dart';
import '../services/product_service.dart';
import '../services/marketplace_service.dart';

final productServiceProvider = Provider<ProductService>((ref) => ProductService());
final marketplaceServiceProvider = Provider<MarketplaceService>((ref) => MarketplaceService());

final featuredProductsProvider = FutureProvider<List<GiProductModel>>((ref) async {
  return ref.watch(productServiceProvider).getFeaturedProducts();
});

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

final filteredProductsProvider = FutureProvider<List<GiProductModel>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  return ref.watch(productServiceProvider).getProductsByCategory(category);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<GiProductModel>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return ref.watch(productServiceProvider).searchProducts(query);
});

final productDetailProvider = FutureProvider.family<GiProductModel, String>((ref, productId) async {
  return ref.watch(productServiceProvider).getProductById(productId);
});

final marketplaceFilterProvider = StateProvider<MarketplaceFilterOptions>((ref) {
  return const MarketplaceFilterOptions();
});

final marketplaceProductsProvider = FutureProvider<List<GiProductModel>>((ref) async {
  final options = ref.watch(marketplaceFilterProvider);
  return ref.watch(marketplaceServiceProvider).getFilteredProducts(options);
});
