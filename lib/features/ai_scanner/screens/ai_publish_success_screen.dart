import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ai_scanner_provider.dart';
import '../../../providers/artisan_hub_provider.dart';
import '../../../providers/marketplace_provider.dart';
import '../../../services/supabase_service.dart';
import '../../../models/gi_product_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/craft_image_helper.dart';

class AIPublishSuccessScreen extends ConsumerStatefulWidget {
  const AIPublishSuccessScreen({super.key});

  @override
  ConsumerState<AIPublishSuccessScreen> createState() => _AIPublishSuccessScreenState();
}

class _AIPublishSuccessScreenState extends ConsumerState<AIPublishSuccessScreen> {
  bool _isAddedToStore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _publishProductToState();
    });
  }

  Future<void> _publishProductToState() async {
    if (_isAddedToStore) return;
    final analysis = ref.read(aiScannerProvider).analysis;
    if (analysis == null) return;

    final user = SupabaseService.client.auth.currentUser;
    final sellerName = user?.userMetadata?['full_name'] as String? ?? user?.email?.split('@').first ?? 'Travis Artisan';
    final sellerId = user?.id ?? '00000000-0000-0000-0000-000000000000';

    final double price = analysis.recommendedPrice > 0 ? analysis.recommendedPrice : 2800.0;
    final double artisanPrice = (price * 0.84).roundToDouble();
    final double platformFee = (price * 0.09).roundToDouble();
    final double shippingCost = (price * 0.07).roundToDouble();

    final newCraft = GiProductModel(
      id: 'art_craft_${DateTime.now().millisecondsSinceEpoch}',
      name: analysis.craftName,
      stateName: analysis.suggestedState,
      stateId: analysis.suggestedState.length >= 2 ? 'IN-${analysis.suggestedState.substring(0, 2).toUpperCase()}' : 'IN-GJ',
      district: 'Patan Craft Cluster',
      category: analysis.suggestedCategory,
      price: price,
      artisanPrice: artisanPrice,
      platformFee: platformFee,
      shippingCost: shippingCost,
      description: analysis.generatedStory,
      imageUrl: analysis.imagePath,
      imageUrls: [analysis.imagePath],
      giTagYear: analysis.isGiCandidate ? 2024 : 2004,
      certifiedArtisanCount: 1,
      artisanId: sellerId,
      artisanName: sellerName,
      sellerName: sellerName,
      sellerVillage: 'Patan Heritage Village',
      cooperativeName: 'Patan Master Weavers Federation',
    );

    await SupabaseService.insertProduct(newCraft);
    ref.read(artisanProductsProvider.notifier).addProduct(newCraft);
    ref.invalidate(marketplaceHomeDataProvider);

    if (mounted) {
      setState(() {
        _isAddedToStore = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(aiScannerProvider);
    final analysis = scannerState.analysis;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Celebratory Circle Icon
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green.withValues(alpha: 0.12),
                          border: Border.all(color: Colors.green, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withValues(alpha: 0.2),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 68,
                            color: Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Title Header
                      const Text(
                        'Product Published Live!',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Congratulations! Your craft is now live on VIRASAT Artisan India Marketplace.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Product Info Summary Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    getCraftImagePath(analysis?.imagePath ?? analysis?.craftName),
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Image.asset(
                                      'assets/images/crafts/bandhani_01.jpg',
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        analysis?.craftName ?? 'Handcrafted Craft Item',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontFamily: 'Playfair Display',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${analysis?.suggestedState ?? "Gujarat"} • GI Verified',
                                        style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 14),
                              child: Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Listing Price:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '₹ ${analysis?.recommendedPrice.toStringAsFixed(0) ?? "11,800"}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primaryTerracotta,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Multilingual Story:',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Text(
                                  '8 Languages Active',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryGold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Action Buttons
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.go('/home');
                          },
                          icon: const Icon(Icons.storefront, color: Colors.white),
                          label: const Text(
                            'View in Artisan Marketplace',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTerracotta,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                context.go('/artisan-dashboard');
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppColors.primaryIndigo),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Artisan Dashboard',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryIndigo,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                ref.read(aiScannerProvider.notifier).reset();
                                context.go('/ai-scanner');
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: const BorderSide(color: AppColors.primaryGold),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Scan Another',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryGold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
