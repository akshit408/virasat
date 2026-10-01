import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/home_banner_model.dart';
import '../models/gi_product_model.dart';
import '../models/artisan_model.dart';
import '../models/category_model.dart';
import '../models/state_model.dart';
import '../models/story_model.dart';
import '../services/data_repository.dart';
import '../services/supabase_service.dart';

/// -------------------------------------------------------------------------
/// Repository Provider
/// -------------------------------------------------------------------------
final dataRepositoryProvider =
    Provider<DataRepository>((ref) => DataRepository());

/// -------------------------------------------------------------------------
/// Home Screen Data Model
/// -------------------------------------------------------------------------
class MarketplaceHomeData {
  final List<HomeBannerModel> banners;
  final List<GiProductModel> products;
  final List<ArtisanModel> artisans;
  final List<CategoryModel> categories;
  final List<StateModel> states;
  final List<StoryModel> stories;

  const MarketplaceHomeData({
    required this.banners,
    required this.products,
    required this.artisans,
    required this.categories,
    required this.states,
    required this.stories,
  });
}

/// Live Realtime stream of marketplace products from Supabase
final supabaseProductsStreamProvider = StreamProvider<List<GiProductModel>>((ref) {
  return SupabaseService.streamProducts();
});

/// -------------------------------------------------------------------------
/// Home Provider (Spring Boot Backend GET /marketplace/home)
/// -------------------------------------------------------------------------
final marketplaceHomeDataProvider =
    FutureProvider<MarketplaceHomeData>((ref) async {
  final repo = ref.watch(dataRepositoryProvider);

  List<GiProductModel> products = [];
  List<HomeBannerModel> banners = [];
  List<ArtisanModel> artisans = [];
  List<CategoryModel> categories = [];
  List<StateModel> states = [];
  List<StoryModel> stories = [];

  // Fetch live database records from Supabase exclusively
  try {
    final supaResults = await Future.wait([
      SupabaseService.getDiscoverStates(),
      SupabaseService.getArtisans(),
      SupabaseService.getProducts(),
    ]);

    states = supaResults[0] as List<StateModel>;
    artisans = supaResults[1] as List<ArtisanModel>;
    products = supaResults[2] as List<GiProductModel>;
  } catch (e) {
    debugPrint('[MarketplaceProvider] Live database fetch exception: $e');
  }

  categories = await repo.loadCategories();
  banners = await repo.loadHomeBanners();

  return MarketplaceHomeData(
    banners: banners,
    products: products,
    artisans: artisans,
    categories: categories,
    states: states,
    stories: stories,
  );
});

/// -------------------------------------------------------------------------
/// Search & Filter Providers
/// -------------------------------------------------------------------------
final marketplaceSearchQueryProvider =
    StateProvider<String>((ref) => '');

final selectedStateFilterProvider =
    StateProvider<String?>((ref) => null);

final selectedCategoryFilterProvider =
    StateProvider<String?>((ref) => null);

final giOnlyFilterProvider =
    StateProvider<bool>((ref) => false);