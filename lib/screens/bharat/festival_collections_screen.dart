import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/festival_collection_model.dart';
import '../../providers/wishlist_provider.dart';
import '../../services/festival_collection_service.dart';
import '../../widgets/cards/product_card.dart';

final collectionBySlugProvider = FutureProvider.family<FestivalCollectionModel, String>((ref, slug) async {
  return FestivalCollectionService.getCollectionBySlug(slug);
});

class FestivalCollectionsScreen extends ConsumerWidget {
  final String slug;

  const FestivalCollectionsScreen({
    super.key,
    this.slug = 'diwali',
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionBySlugProvider(slug));
    final wishlistNotifier = ref.read(wishlistProvider.notifier);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _getAppBarTitle(slug),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Playfair Display',
            fontSize: 18,
          ),
        ),
      ),
      body: collectionAsync.when(
        data: (collection) {
          final Color themeColor = _parseColor(collection.themeColor);
          final products = collection.products;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Collection Hero Banner
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: Offset(0, 6)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Banner Background Image overlay if available
                      if (collection.bannerImage.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: ShaderMask(
                            shaderCallback: (rect) {
                              return LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.black.withValues(alpha: 0.3), Colors.black.withValues(alpha: 0.75)],
                              ).createShader(rect);
                            },
                            blendMode: BlendMode.darken,
                            child: Image.network(
                              collection.bannerImage,
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(),
                            ),
                          ),
                        ),

                      Padding(
                        padding: const EdgeInsets.all(22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                              ),
                              child: const Text(
                                'FESTIVAL COLLECTION',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              collection.title,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontFamily: 'Playfair Display',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              collection.subtitle,
                              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.3),
                            ),
                            const SizedBox(height: 14),
                            // Price Range Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.sell_outlined, size: 14, color: themeColor),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Price Range: ₹${collection.minPrice.round()} – ₹${collection.maxPrice.round()}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: themeColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Collection Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Products (${products.length})',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: themeColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '100% Authentic',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: themeColor),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Product Grid (2-column Grid using Virasat ProductCard UI)
                if (products.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Center(child: Text('No products available in this collection.')),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.62,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return ProductCard(
                        product: product,
                        isWishlisted: wishlist.any((p) => p.id == product.id),
                        onWishlistTap: () => wishlistNotifier.toggleWishlist(product),
                        onTap: () => context.push('/product-detail', extra: product),
                      );
                    },
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Error loading collection: $err'),
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle(String slug) {
    if (slug.contains('navratri')) return 'Navratri Collection 🪔';
    if (slug.contains('diwali')) return 'Diwali Collection 🪔';
    if (slug.contains('gi')) return 'GI Heritage Collection 🏅';
    return 'Festival Collection 🪔';
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return AppColors.primary;
    }
  }
}
