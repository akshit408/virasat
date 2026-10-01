import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/state_helper.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/cards/safe_product_image.dart';

class CategoryListingScreen extends ConsumerStatefulWidget {
  final String title;
  final String? categoryId;
  final String? stateId;

  const CategoryListingScreen({
    super.key,
    required this.title,
    this.categoryId,
    this.stateId,
  });

  @override
  ConsumerState<CategoryListingScreen> createState() => _CategoryListingScreenState();
}

class _CategoryListingScreenState extends ConsumerState<CategoryListingScreen> {
  String _sortBy = 'Popularity';
  bool _giOnly = false;

  @override
  Widget build(BuildContext context) {
    final homeDataAsync = ref.watch(marketplaceHomeDataProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded, color: AppColors.textPrimary),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: homeDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error loading crafts: $err')),
        data: (data) {
          var filtered = data.products;

          if (widget.categoryId != null && widget.categoryId!.isNotEmpty) {
            filtered = filtered.where((c) => c.categoryId == widget.categoryId).toList();
          }

          if (widget.stateId != null && widget.stateId!.isNotEmpty) {
            final targetId = widget.stateId!.trim().toLowerCase();
            final targetFullName = getStateFullName(widget.stateId).toLowerCase();
            filtered = filtered.where((c) {
              final cid = c.stateId.trim().toLowerCase();
              final cname = c.stateName.trim().toLowerCase();
              return cid == targetId ||
                  cname == targetFullName ||
                  cid.replaceAll('in-', '') == targetId.replaceAll('in-', '');
            }).toList();
          }

          if (_giOnly) {
            filtered = filtered.where((c) => c.giTagged).toList();
          }

          if (_sortBy == 'Popularity') {
            filtered.sort((a, b) => b.popularityScore.compareTo(a.popularityScore));
          } else if (_sortBy == 'GI First') {
            filtered.sort((a, b) => (b.giTagged ? 1 : 0).compareTo(a.giTagged ? 1 : 0));
          }

          return Column(
            children: [
              // Filter & Sort Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.surface,
                child: Row(
                  children: [
                    FilterChip(
                      selected: _giOnly,
                      label: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified_rounded, size: 14, color: AppColors.secondary),
                          SizedBox(width: 4),
                          Text('GI Tagged Only', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                      onSelected: (val) {
                        setState(() => _giOnly = val);
                      },
                      selectedColor: AppColors.secondary.withValues(alpha: 0.2),
                      checkmarkColor: AppColors.secondary,
                    ),
                    const Spacer(),
                    PopupMenuButton<String>(
                      initialValue: _sortBy,
                      onSelected: (val) => setState(() => _sortBy = val),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.border),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.sort_rounded, size: 16, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text(
                              'Sort: $_sortBy',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                      ),
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'Popularity', child: Text('Sort by Popularity')),
                        const PopupMenuItem(value: 'GI First', child: Text('GI Tagged First')),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1, color: AppColors.border),

              // Grid Content
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
                            const SizedBox(height: 16),
                            Text(
                              'No crafts found for "${widget.title}"',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () => setState(() => _giOnly = false),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, idx) {
                          final craft = filtered[idx];
                          final isWishlisted = ref.watch(wishlistProvider.notifier).isWishlisted(craft.id);

                          return GestureDetector(
                            onTap: () {
                              context.push('/product-detail', extra: craft);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppColors.border),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.cardShadow,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                      child: Stack(
                                        children: [
                                           Positioned.fill(
                                             child: SafeProductImage(
                                               imagePath: craft.imageUrl.isNotEmpty
                                                   ? craft.imageUrl
                                                   : (craft.imageUrls.isNotEmpty ? craft.imageUrls.first : craft.name),
                                               fit: BoxFit.cover,
                                               placeholderText: craft.category,
                                             ),
                                           ),
                                          if (craft.giTagged)
                                            Positioned(
                                              top: 8,
                                              left: 8,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  color: AppColors.secondary,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: const Text(
                                                  'GI TAGGED',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: IconButton(
                                              icon: Icon(
                                                isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                                color: isWishlisted ? Colors.redAccent : Colors.white,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                ref.read(wishlistProvider.notifier).toggleWishlist(craft);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          craft.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Playfair Display',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${craft.city}, ${craft.stateId}',
                                          style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              craft.priceRange,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                                const SizedBox(width: 2),
                                                Text(
                                                  (craft.popularityScore / 20).toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.bold,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
