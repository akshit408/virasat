import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../providers/bharat_virasat_provider.dart';
import '../../widgets/inputs/virasat_search_bar.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/cards/craft_card.dart';
import '../../widgets/cards/category_card.dart';
import '../../widgets/loaders/virasat_loaders.dart';
import '../../widgets/home/home_collection_pills_widget.dart';

class BuyerHomeScreen extends ConsumerWidget {
  const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredProductsAsync = ref.watch(featuredProductsProvider);
    final craftsAsync = ref.watch(craftsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Header with Location & Notification
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Namaste, Namrata 🙏', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 12, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text('Jaipur, Rajasthan', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
                      onPressed: () => context.push('/notifications'),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: VirasatSearchBar(
                  onVoiceTap: () => context.push('/ai-studio/voice-catalog'),
                  onFilterTap: () => context.push('/buyer/marketplace'),
                ),
              ),

              const SizedBox(height: 10),

              // Dynamic Collection Pills
              const HomeCollectionPillsWidget(),

              const SizedBox(height: 20),

              // Editorial Hero Banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(color: AppColors.cardShadow, blurRadius: 12, offset: Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text('FESTIVAL EDITION', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Diwali Virasat Handloom Fair 🪔',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Playfair Display',
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Explore 100% authentic silk sarees and brass diyas from GI-tagged clusters.',
                        style: TextStyle(color: AppColors.background, fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => context.push('/bharat/festivals'),
                        child: const Text('Explore Collection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Explore Categories Horizontal List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Explore Craft Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () => context.push('/buyer/explore'),
                      child: const Text('View All', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    CategoryCard(title: 'Textiles', icon: Icons.checkroom_outlined, isSelected: true, onTap: () => context.push('/buyer/marketplace')),
                    const SizedBox(width: 8),
                    CategoryCard(title: 'Pottery', icon: Icons.local_cafe_outlined, onTap: () => context.push('/buyer/marketplace')),
                    const SizedBox(width: 8),
                    CategoryCard(title: 'Jewellery', icon: Icons.diamond_outlined, onTap: () => context.push('/buyer/marketplace')),
                    const SizedBox(width: 8),
                    CategoryCard(title: 'Paintings', icon: Icons.palette_outlined, onTap: () => context.push('/buyer/marketplace')),
                    const SizedBox(width: 8),
                    CategoryCard(title: 'Wood Craft', icon: Icons.park_outlined, onTap: () => context.push('/buyer/marketplace')),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // Bharat Virasat Banner Entry Point
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: GestureDetector(
                  onTap: () => context.push('/bharat'),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.secondary, width: 1.5),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.secondary,
                          radius: 22,
                          child: Icon(Icons.explore, color: Colors.white),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('BHARAT VIRASAT MAP 🗺️', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                              Text('Interactive Indian Heritage Explorer', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text('Discover state-by-state crafts & GI tags', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Trending Crafts Carousel
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text('Trending Heritage Crafts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
              const SizedBox(height: 12),
              craftsAsync.when(
                data: (crafts) => SizedBox(
                  height: 210,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: crafts.length,
                    itemBuilder: (context, index) => CraftCard(
                      craft: crafts[index],
                      onTap: () => context.push('/product-detail', extra: crafts[index]),
                    ),
                  ),
                ),
                loading: () => const VirasatLoader(),
                error: (err, stack) => const SizedBox(),
              ),

              const SizedBox(height: 28),

              // Featured Marketplace Products Grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Featured Artisan Creations', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () => context.push('/buyer/marketplace'),
                      child: const Text('Marketplace >', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              featuredProductsAsync.when(
                data: (products) => GridView.builder(
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
                  itemBuilder: (context, index) => ProductCard(
                    product: products[index],
                    onTap: () => context.push('/product-detail', extra: products[index]),
                  ),
                ),
                loading: () => const VirasatLoader(),
                error: (err, stack) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
