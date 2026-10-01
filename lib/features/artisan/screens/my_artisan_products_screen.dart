import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/state_helper.dart';
import '../../../providers/artisan_hub_provider.dart';
import '../../../widgets/cards/safe_product_image.dart';

class MyArtisanProductsScreen extends ConsumerStatefulWidget {
  const MyArtisanProductsScreen({super.key});

  @override
  ConsumerState<MyArtisanProductsScreen> createState() => _MyArtisanProductsScreenState();
}

class _MyArtisanProductsScreenState extends ConsumerState<MyArtisanProductsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _filterCategory = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(artisanProductsProvider);
    final query = _searchController.text.trim().toLowerCase();
    final categories = [
      'All',
      ...products.map((product) => product.category).where((cat) => cat.isNotEmpty).toSet(),
    ];

    var filtered = products;
    if (query.isNotEmpty) {
      filtered = filtered.where((p) => p.name.toLowerCase().contains(query)).toList();
    }
    if (_filterCategory != 'All') {
      filtered = filtered.where((p) => p.category == _filterCategory).toList();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/artisan-dashboard');
            }
          },
        ),
        title: const Text(
          'My Artisan Products',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary, size: 28),
            onPressed: () => context.push('/sell-my-craft'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search my product listings...',
                    prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
                    suffixIcon: query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: categories.contains(_filterCategory) ? _filterCategory : 'All',
                  decoration: InputDecoration(
                    labelText: 'Category',
                    prefixIcon: const Icon(Icons.category_outlined, color: AppColors.primary),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                    fillColor: AppColors.background,
                  ),
                  items: categories
                      .map((category) => DropdownMenuItem(value: category, child: Text(category)))
                      .toList(),
                  onChanged: (category) {
                    if (category != null) {
                      setState(() => _filterCategory = category);
                    }
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Products List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textLight),
                        const SizedBox(height: 16),
                        const Text(
                          'No artisan products found',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () => context.push('/sell-my-craft'),
                          icon: const Icon(Icons.add),
                          label: const Text('Add Product with AI'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, idx) {
                      final item = filtered[idx];
                      final displayImg = item.imageUrl.isNotEmpty
                          ? item.imageUrl
                          : (item.imageUrls.isNotEmpty ? item.imageUrls.first : '');

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(14),
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
                        child: Row(
                          children: [
                            // Priority-based Safe Product Image
                            SafeProductImage(
                              imagePath: displayImg,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              borderRadius: BorderRadius.circular(14),
                              placeholderText: item.category.isNotEmpty ? item.category : 'Artisan Craft',
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Playfair Display',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.success.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          'ACTIVE',
                                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.success),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '📍 ${item.city.isNotEmpty ? item.city : 'Craft Hub'} • ${getStateFullName(item.stateId.isNotEmpty ? item.stateId : item.state)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Text(
                                        item.priceRange,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      const Icon(Icons.visibility_outlined, size: 14, color: AppColors.textLight),
                                      const SizedBox(width: 4),
                                      const Text('480 views', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Action Menu
                            PopupMenuButton<String>(
                              onSelected: (val) {
                                if (val == 'duplicate') {
                                  ref.read(artisanProductsProvider.notifier).duplicateProduct(item);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Product duplicated successfully')),
                                  );
                                } else if (val == 'delete') {
                                  ref.read(artisanProductsProvider.notifier).deleteProduct(item.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Product removed from catalog')),
                                  );
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(value: 'edit', child: Text('Edit Listing')),
                                const PopupMenuItem(value: 'duplicate', child: Text('Duplicate Product')),
                                const PopupMenuItem(value: 'delete', child: Text('Delete Listing', style: TextStyle(color: Colors.redAccent))),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sell-my-craft'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add Product', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

/// Backward compatibility alias for ManageProductsScreen
typedef ManageProductsScreen = MyArtisanProductsScreen;
