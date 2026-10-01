import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/inputs/virasat_search_bar.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/sheets/filter_bottom_sheet.dart';
import '../../widgets/loaders/virasat_loaders.dart';

class MarketplaceScreen extends ConsumerWidget {
  const MarketplaceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketplaceProductsAsync = ref.watch(marketplaceProductsProvider);
    final filterOptions = ref.watch(marketplaceFilterProvider);
    final wishlistNotifier = ref.read(wishlistProvider.notifier);
    final wishlist = ref.watch(wishlistProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar & Search
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        'Artisan Marketplace',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => FilterBottomSheet(
                              currentOptions: filterOptions,
                              onApply: (newOptions) {
                                ref.read(marketplaceFilterProvider.notifier).state = newOptions;
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  VirasatSearchBar(
                    onVoiceTap: () => context.push('/ai-studio/voice-catalog'),
                    onFilterTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => FilterBottomSheet(
                          currentOptions: filterOptions,
                          onApply: (newOptions) {
                            ref.read(marketplaceFilterProvider.notifier).state = newOptions;
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Active Filters Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (filterOptions.category != null && filterOptions.category != 'All')
                      Chip(label: Text('Category: ${filterOptions.category}'), backgroundColor: AppColors.chipBackground),
                    if (filterOptions.state != null && filterOptions.state != 'All')
                      Chip(label: Text('State: ${filterOptions.state}'), backgroundColor: AppColors.chipBackground),
                    if (filterOptions.isGiTagged == true)
                      const Chip(label: Text('GI Tagged'), backgroundColor: AppColors.secondary, labelStyle: TextStyle(color: Colors.white)),
                    if (filterOptions.isWomenArtisan == true)
                      const Chip(label: Text('Women Artisan'), backgroundColor: AppColors.primary, labelStyle: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),

            // Masonry Feed
            Expanded(
              child: marketplaceProductsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text('No craft listings match your filters.'));
                  }
                  return MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    padding: const EdgeInsets.all(16),
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
                  );
                },
                loading: () => const VirasatLoader(message: 'Loading heritage marketplace...'),
                error: (err, stack) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
