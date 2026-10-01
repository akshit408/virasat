import '../models/gi_product_model.dart';
import 'product_service.dart';

class MarketplaceFilterOptions {
  final double minPrice;
  final double maxPrice;
  final String? category;
  final String? state;
  final bool? isGiTagged;
  final bool? isWomenArtisan;
  final bool? isEcoFriendly;
  final String sortBy; // 'newest', 'popular', 'price_low', 'price_high'

  const MarketplaceFilterOptions({
    this.minPrice = 0,
    this.maxPrice = 50000,
    this.category,
    this.state,
    this.isGiTagged,
    this.isWomenArtisan,
    this.isEcoFriendly,
    this.sortBy = 'popular',
  });
}

class MarketplaceService {
  final ProductService _productService = ProductService();

  Future<List<GiProductModel>> getFilteredProducts(MarketplaceFilterOptions options) async {
    final all = await _productService.getFeaturedProducts();
    
    var filtered = all.where((p) {
      if (p.price < options.minPrice || p.price > options.maxPrice) return false;
      if (options.category != null && options.category != 'All' && p.category != options.category) return false;
      if (options.state != null && options.state != 'All' && p.state != options.state) return false;
      if (options.isGiTagged == true && !p.isGiTagged) return false;
      return true;
    }).toList();

    if (options.sortBy == 'price_low') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (options.sortBy == 'price_high') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (options.sortBy == 'newest') {
      filtered = filtered.reversed.toList();
    }

    return filtered;
  }
}
