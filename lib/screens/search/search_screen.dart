import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/theme/app_colors.dart';
import '../../models/gi_product_model.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../widgets/cards/safe_product_image.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  List<String> _recentSearches = [
    'Pashmina Silk',
    'Blue Pottery Jaipur',
    'Patola Saree',
    'Madhubani Folk Art',
  ];

  final List<String> _trendingSearches = [
    'Bandhani',
    'Kanchipuram Silk',
    'Aranmula Mirror',
    'Moradabad Brassware',
    'Chikankari',
    'Warli Art',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      ref.read(marketplaceSearchQueryProvider.notifier).state = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(marketplaceSearchQueryProvider);
    final selectedState = ref.watch(selectedStateFilterProvider);
    final selectedCategory = ref.watch(selectedCategoryFilterProvider);
    final giOnly = ref.watch(giOnlyFilterProvider);
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
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            autofocus: true,
            style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: AppLocalizations.tr(context, 'search_placeholder'),
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.textLight),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textLight),
                      onPressed: () {
                        _searchController.clear();
                      },
                    )
                  : IconButton(
                      icon: const Icon(Icons.mic_rounded, size: 20, color: AppColors.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.tr(context, 'voice_search_placeholder')),
                            duration: const Duration(seconds: 2),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune_rounded,
              color: (selectedState != null || selectedCategory != null || giOnly)
                  ? AppColors.primary
                  : AppColors.textPrimary,
            ),
            onPressed: () => _showFilterSheet(context),
          ),
        ],
      ),
      body: homeDataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (data) {
          final query = searchQuery.trim().toLowerCase();

          // Perform Search Filtering
          List<GiProductModel> results = data.products;

          if (query.isNotEmpty) {
            results = results.where((c) {
              final nameMatch = c.name.toLowerCase().contains(query);
              final stateMatch = c.state.toLowerCase().contains(query) || c.district.toLowerCase().contains(query);
              final categoryMatch = c.category.toLowerCase().contains(query);
              final matMatch = c.description.toLowerCase().contains(query);
              return nameMatch || stateMatch || categoryMatch || matMatch;
            }).toList();
          }

          if (selectedState != null) {
            results = results.where((c) => c.stateId == selectedState).toList();
          }

          if (selectedCategory != null) {
            results = results.where((c) => c.category == selectedCategory).toList();
          }

          if (giOnly) {
            results = results.where((c) => c.giTagged).toList();
          }

          if (query.isEmpty && selectedState == null && selectedCategory == null && !giOnly) {
            // Display Recent & Trending Searches
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_recentSearches.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        TextButton(
                          onPressed: () => setState(() => _recentSearches = []),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(fontSize: 12, color: AppColors.textLight),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches.map((term) {
                        return ActionChip(
                          avatar: const Icon(Icons.history_rounded, size: 16, color: AppColors.primary),
                          label: Text(term, style: const TextStyle(fontSize: 12)),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.border),
                          onPressed: () {
                            _searchController.text = term;
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  const Text(
                    'Trending Craft Searches',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _trendingSearches.map((term) {
                      return ActionChip(
                        avatar: const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.secondary),
                        label: Text(term, style: const TextStyle(fontSize: 12)),
                        backgroundColor: AppColors.surface,
                        side: const BorderSide(color: AppColors.border),
                        onPressed: () {
                          _searchController.text = term;
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),

                  const Text(
                    'Explore Popular Heritage Categories',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.categories.length,
                      itemBuilder: (context, idx) {
                        final cat = data.categories[idx];
                        return GestureDetector(
                          onTap: () {
                            ref.read(selectedCategoryFilterProvider.notifier).state = cat.id;
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 28),
                                const SizedBox(height: 8),
                                Text(
                                  cat.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          // Search Results Grid
          if (results.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off_rounded, size: 64, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  Text(
                    'No craft results found for "$query"',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      _searchController.clear();
                      ref.read(selectedStateFilterProvider.notifier).state = null;
                      ref.read(selectedCategoryFilterProvider.notifier).state = null;
                      ref.read(giOnlyFilterProvider.notifier).state = false;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Reset Search & Filters'),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: results.length,
            itemBuilder: (context, idx) {
              final product = results[idx];
              final isWishlisted = ref.watch(wishlistProvider.notifier).isWishlisted(product.id);

              return GestureDetector(
                onTap: () {
                  context.push('/product-detail', extra: product);
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
                                   imagePath: product.imageUrl.isNotEmpty
                                       ? product.imageUrl
                                       : (product.imageUrls.isNotEmpty ? product.imageUrls.first : product.name),
                                   fit: BoxFit.cover,
                                   placeholderText: product.category,
                                 ),
                               ),
                              if (product.isGiTagged)
                                Positioned(
                                  top: 8,
                                  left: 8,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'GI TAGGED',
                                      style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white),
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
                                    size: 18,
                                  ),
                                  onPressed: () {
                                    ref.read(wishlistProvider.notifier).toggleWishlist(product);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${product.district.isNotEmpty ? product.district : 'Craft Hub'}, ${product.state}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '₹${product.price.round()}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final giOnly = ref.watch(giOnlyFilterProvider);
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Filter Heritage Crafts',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('GI Tagged Crafts Only', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    subtitle: const Text('Geographically Indicated authentic crafts'),
                    value: giOnly,
                    activeThumbColor: AppColors.primary,
                    onChanged: (val) {
                      ref.read(giOnlyFilterProvider.notifier).state = val;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Apply Filters'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
