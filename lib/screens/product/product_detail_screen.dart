import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/localization/app_localizations.dart';
import '../../models/gi_product_model.dart';
import '../../models/artisan_model.dart';
import '../../models/story_model.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/sheets/artisan_profile_sheet.dart';
import '../../features/chat/models/chat_message_model.dart';
import '../../features/b2b/models/rfq_model.dart';
import '../../features/b2b/providers/b2b_rfq_provider.dart';
import '../../core/utils/auth_guard.dart';
import '../../widgets/cards/safe_product_image.dart';
import '../../widgets/carousel/product_gallery_carousel.dart';

class ProductDetailScreen extends ConsumerWidget {
  final GiProductModel craft;

  const ProductDetailScreen({super.key, required this.craft});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeDataAsync = ref.watch(marketplaceHomeDataProvider);
    final isWishlisted = ref.watch(wishlistProvider.notifier).isWishlisted(craft.id);

    // Find story and artisan
    StoryModel? matchedStory;
    ArtisanModel? matchedArtisan;
    List<GiProductModel> relatedCrafts = [];

    homeDataAsync.whenData((data) {
      final storyList = data.stories.where((s) => s.craftId == craft.id).toList();
      if (storyList.isNotEmpty) matchedStory = storyList.first;

      final artisanList = data.artisans.where((a) => a.craftId == craft.id).toList();
      if (artisanList.isNotEmpty) {
        matchedArtisan = artisanList.first;
      } else if (data.artisans.isNotEmpty) {
        matchedArtisan = data.artisans.first;
      }

      relatedCrafts = data.products
          .where((c) => c.id != craft.id && (c.categoryId == craft.categoryId || c.stateId == craft.stateId))
          .take(4)
          .toList();
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Gallery Header
              SliverAppBar(
                expandedHeight: 340,
                pinned: true,
                backgroundColor: AppColors.primary,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                    onPressed: () => context.pop(),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? Colors.redAccent : Colors.white,
                      ),
                      onPressed: () async {
                        final ok = await ensureAuthenticated(context, ref, title: 'Wishlist Required', message: 'Please sign in to save heritage crafts to your wishlist.');
                        if (!ok) return;
                        ref.read(wishlistProvider.notifier).toggleWishlist(craft);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                isWishlisted ? 'Removed from Wishlist' : 'Saved to Heritage Wishlist',
                              ),
                              duration: const Duration(seconds: 1),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      ProductGalleryCarousel(
                        imageUrls: craft.imageUrls,
                        coverImageUrl: craft.imageUrl,
                        productName: craft.name,
                        isGiTagged: craft.giTagged,
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 24,
                          decoration: const BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Product Info & Meta
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  craft.getLocalizedName(context),
                                  style: const TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${craft.city}, ${craft.stateId}',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                craft.formattedPrice,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              if (craft.discountPercent > 0) ...[
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      craft.formattedMrp,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green.shade700,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '${craft.discountPercent}% OFF',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${craft.rating} / 5.0 (${craft.reviewCount})',
                                    style: const TextStyle(
                                      fontSize: 12,
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

                      if (craft.giTagged) ...[
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            context.push('/gi-certificate', extra: craft);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.verified_rounded, color: AppColors.secondary, size: 28),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Geographical Indication (GI) Tagged',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Guaranteed authentic origin protected under GI Registry Act, 1999.',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Text(
                                    'View Certificate',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Transparent Fair Trade Price Breakdown Card
                      Builder(
                        builder: (context) {
                          final double price = craft.price > 0 ? craft.price : 2800.0;
                          final double artisanEarn = craft.artisanPrice > 0 ? craft.artisanPrice : (price * 0.84).roundToDouble();
                          final double fee = craft.platformFee > 0 ? craft.platformFee : (price * 0.09).roundToDouble();
                          final double shipping = craft.shippingCost > 0 ? craft.shippingCost : (price * 0.07).roundToDouble();
                          final int pct = ((artisanEarn / price) * 100).round();

                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Buyer Price',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      '₹ ${price.round()}',
                                      style: const TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFF97316),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Divider(color: Colors.white12, height: 1),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E), size: 18),
                                        SizedBox(width: 8),
                                        Text(
                                          'Artisan Receives',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF22C55E),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '₹ ${artisanEarn.round()}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF22C55E),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Platform Support Fee', style: TextStyle(fontSize: 12, color: Colors.white70)),
                                    Text('₹ ${fee.round()}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Insured Shipping', style: TextStyle(fontSize: 12, color: Colors.white70)),
                                    Text('₹ ${shipping.round()}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Row(
                                        children: [
                                          Icon(Icons.favorite_outline_rounded, color: Color(0xFF166534), size: 18),
                                          SizedBox(width: 6),
                                          Text(
                                            'Fair Trade Purchase',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF166534),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '$pct%',
                                        style: const TextStyle(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF15803D),
                                        ),
                                      ),
                                      const Text(
                                        'of your payment goes directly to the artisan.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF166534),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                      // Specs Grid
                      Row(
                        children: [
                          Expanded(
                            child: _buildSpecTile(
                              icon: Icons.inventory_2_outlined,
                              label: 'Materials',
                              value: craft.materials.isNotEmpty ? craft.materials : 'Natural Dyes & Fibers',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSpecTile(
                              icon: Icons.timer_outlined,
                              label: 'Crafting Time',
                              value: '14 - 30 Days',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildSpecTile(
                              icon: Icons.groups_outlined,
                              label: 'Artisans',
                              value: '${craft.artisanCount}+ Active',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),
                      // About Craft
                      const Text(
                        'About this Craft',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        matchedStory?.origin ??
                            'Originated in ${craft.city}, ${craft.stateId}, nurtured by master artisan lineages across generations.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 28),
                      // Heritage Story
                      if (matchedStory != null) ...[
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.border),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.cardShadow,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.history_edu_rounded, color: AppColors.primary),
                                      const SizedBox(width: 8),
                                      Text(
                                        AppLocalizations.tr(context, 'heritage_story'),
                                        style: const TextStyle(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Row(
                                            children: [
                                              const Icon(Icons.volume_up_rounded, color: Colors.amber),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  AppLocalizations.tr(context, 'playing_audio'),
                                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          backgroundColor: AppColors.primary,
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.secondary),
                                        const SizedBox(width: 4),
                                        Text(
                                          AppLocalizations.tr(context, 'listen_audio'),
                                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                matchedStory!.history,
                                style: const TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                matchedStory!.culturalSignificance,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  color: AppColors.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Verified Artisans & Vendor Options
                      const Text(
                        'Verified Artisans & Vendor Options',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Compare verified rural artisans and Women SHGs crafting this heritage piece.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildVendorCard(
                              name: matchedArtisan?.name ?? 'Savitaben Rabari',
                              location: '${craft.city.isNotEmpty ? craft.city : 'Jamnagar'}, ${craft.state}',
                              badge: "Women's SHG Verified",
                              experience: '${matchedArtisan?.experienceYears ?? 28} Yrs Exp.',
                              price: craft.priceRange,
                              isSelected: true,
                            ),
                            const SizedBox(width: 12),
                            _buildVendorCard(
                              name: 'Kutch Bandhej Mahila Mandal',
                              location: 'Bhuj, ${craft.state}',
                              badge: 'GI Certified Cooperative',
                              experience: '35 Yrs Collective',
                              price: '₹ 420',
                              isSelected: false,
                            ),
                            const SizedBox(width: 12),
                            _buildVendorCard(
                              name: 'Noor Mohammad Khatri',
                              location: 'Kutch, ${craft.state}',
                              badge: 'Master Artisan',
                              experience: '35 Yrs Exp.',
                              price: '₹ 500',
                              isSelected: false,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Meet the Artisan Card
                      if (matchedArtisan != null) ...[
                        const Text(
                          'Master Artisan Behind the Craft',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.surface,
                                AppColors.terracottaLight.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 28,
                                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                                child: Text(
                                  matchedArtisan!.name[0],
                                  style: const TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      matchedArtisan!.name,
                                      style: const TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${matchedArtisan!.village} • ${matchedArtisan!.experienceYears} Years Exp.',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ArtisanProfileSheet.show(context, matchedArtisan!);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: const Text(
                                  'Meet Artisan',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                      ],

                      // Related Crafts
                      if (relatedCrafts.isNotEmpty) ...[
                        const Text(
                          'Related Heritage Creations',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: relatedCrafts.length,
                            itemBuilder: (context, idx) {
                              final item = relatedCrafts[idx];
                              return GestureDetector(
                                onTap: () {
                                  context.push('/product-detail', extra: item);
                                },
                                child: Container(
                                  width: 140,
                                  margin: const EdgeInsets.only(right: 12),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       ClipRRect(
                                         borderRadius: BorderRadius.circular(8),
                                         child: SafeProductImage(
                                           imagePath: item.imageUrl.isNotEmpty
                                               ? item.imageUrl
                                               : (item.imageUrls.isNotEmpty ? item.imageUrls.first : item.name),
                                           width: 36,
                                           height: 36,
                                           fit: BoxFit.cover,
                                           placeholderText: item.category,
                                         ),
                                       ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.priceRange,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Bottom Action Bar (Fixed)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 16,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref.read(wishlistProvider.notifier).toggleWishlist(craft);
                      },
                      icon: Icon(
                        isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                        color: isWishlisted ? Colors.redAccent : AppColors.textPrimary,
                        size: 26,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.push(
                          '/artisan-chat',
                          extra: ArtisanChatArgs(
                            artisanId: craft.artisanId.isNotEmpty ? craft.artisanId : 'artisan_v1',
                            name: matchedArtisan?.name ?? craft.artisanName,
                            avatar: craft.artisanAvatar.isNotEmpty ? craft.artisanAvatar : craft.imageUrl,
                            craft: craft.name,
                            location: craft.city.isNotEmpty ? craft.city : craft.state,
                            initialMessage: 'Hi ${matchedArtisan?.name ?? craft.artisanName}, I am interested in your craft product: ${craft.name}. Could you please share more details about customization and availability?',
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: AppColors.primary,
                        size: 26,
                      ),
                      tooltip: 'Inquire / Customization',
                    ),
                    IconButton(
                      onPressed: () {
                        _showBulkQuoteSheet(context, ref, craft);
                      },
                      icon: const Icon(
                        Icons.business_center_outlined,
                        color: Color(0xFF1E3A8A),
                        size: 24,
                      ),
                      tooltip: 'Request Bulk B2B Quote',
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  ref.read(cartProvider.notifier).addToCart(craft);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        margin: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
                                        content: Row(
                                          children: [
                                            const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                                            const SizedBox(width: 12),
                                            Expanded(child: Text('Added ${craft.name} to Bag', maxLines: 1, overflow: TextOverflow.ellipsis)),
                                          ],
                                        ),
                                        action: SnackBarAction(
                                          label: 'VIEW CART',
                                          textColor: Colors.amber,
                                          onPressed: () => context.push('/cart'),
                                        ),
                                        duration: const Duration(seconds: 2),
                                        backgroundColor: AppColors.primary,
                                      ),
                                    );
                                  }
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: AppColors.primary),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                                child: const Text(
                                  'Add to Bag',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: ElevatedButton(
                                onPressed: () {
                                  ref.read(cartProvider.notifier).addToCart(craft);
                                  if (context.mounted) {
                                    context.push('/cart');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  elevation: 2,
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                ),
                                child: const Text(
                                  'Request to Buy',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpecTile({required IconData icon, required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorCard({
    required String name,
    required String location,
    required String badge,
    required String experience,
    required String price,
    required bool isSelected,
  }) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.terracottaLight.withValues(alpha: 0.15) : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const Spacer(),
              if (isSelected)
                const Icon(Icons.check_circle, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 2),
          Text(
            '📍 $location • $experience',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const Text(
                'Direct Artisan',
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.secondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBulkQuoteSheet(BuildContext context, WidgetRef ref, GiProductModel craft) {
    final businessNameController = TextEditingController(text: 'Taj & Luxury Heritage Retailers');
    final qtyController = TextEditingController(text: '100');
    final notesController = TextEditingController(text: 'Custom GI tag verification & drop-tested packaging required.');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            top: 24,
            left: 24,
            right: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(3)),
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.business_center_outlined, color: AppColors.primary, size: 24),
                    SizedBox(width: 10),
                    Text(
                      'Request B2B Bulk Quotation',
                      style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Submit commercial RFQ for ${craft.name} directly to verified rural artisan cluster.',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: businessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business / Company Name',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity Required (Units)',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: notesController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Customization & Packaging Notes',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final qty = int.tryParse(qtyController.text) ?? 100;
                      final newRfq = B2bRFQ(
                        id: 'rfq-user-${DateTime.now().millisecondsSinceEpoch}',
                        buyerName: businessNameController.text.isNotEmpty ? businessNameController.text : 'Commercial Buyer',
                        buyerType: 'Retail Stores',
                        title: '$qty Units of ${craft.name}',
                        craftType: craft.category,
                        units: qty,
                        budget: (craft.price * qty * 0.75),
                        deadline: '30 Days',
                        status: 'Open',
                        location: '${craft.city.isNotEmpty ? craft.city : "Heritage Hub"}, ${craft.state.isNotEmpty ? craft.state : "India"}',
                        notes: notesController.text.isNotEmpty ? notesController.text : 'Custom bulk inquiry via VIRASAT Marketplace',
                        image: craft.imageUrl.isNotEmpty ? craft.imageUrl : 'assets/images/crafts/bandhani_01.jpg',
                      );
                      ref.read(b2bRfqProvider.notifier).addRFQ(newRfq);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Bulk RFQ for ${craft.name} submitted! Visible in Artisan Mode > B2B Wholesale.'),
                          backgroundColor: const Color(0xFF166534),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Submit Bulk RFQ to Artisan Cluster', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
