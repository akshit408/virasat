import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/state_details_repository.dart';
import '../../widgets/cards/state_craft_card.dart';
import '../../widgets/cards/safe_product_image.dart';
import '../../features/chat/models/chat_message_model.dart';

class StateDetailScreen extends ConsumerStatefulWidget {
  final String stateId;

  const StateDetailScreen({
    super.key,
    required this.stateId,
  });

  @override
  ConsumerState<StateDetailScreen> createState() => _StateDetailScreenState();
}

class _StateDetailScreenState extends ConsumerState<StateDetailScreen> {
  String? _selectedDistrict;

  @override
  Widget build(BuildContext context) {
    final repo = StateDetailsRepository();
    final stateModel = repo.getStateDetails(widget.stateId);
    final popularCrafts = repo.getPopularCraftsForState(widget.stateId);
    final hiddenGems = repo.getHiddenGemsForState(widget.stateId);
    final districtOrigins = repo.getDistrictCraftOrigins(widget.stateId);
    final featuredArtisans = repo.getFeaturedArtisansForState(widget.stateId);

    // Filter crafts if a specific district is selected
    final filteredPopularCrafts = _selectedDistrict == null
        ? popularCrafts
        : popularCrafts.where((c) => c.district.toLowerCase().contains(_selectedDistrict!.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // 1. State Banner Image & Header (Requirement 4)
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 260,
                          width: double.infinity,
                          child: SafeProductImage(
                            imagePath: stateModel.imagePath,
                            fit: BoxFit.cover,
                            placeholderText: stateModel.name,
                          ),
                        ),
                        Container(
                          height: 260,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(alpha: 0.75),
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.85),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                        // Top Back Button
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 16,
                          child: CircleAvatar(
                            backgroundColor: Colors.black45,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                              onPressed: () => context.pop(),
                            ),
                          ),
                        ),
                        // State Title Overlay
                        Positioned(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryTerracotta,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      stateModel.region.toUpperCase(),
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 0.8),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Capital: ${stateModel.capital}',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                stateModel.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'Playfair Display',
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Handcraft Heritage • ${stateModel.totalArtisans > 0 ? stateModel.totalArtisans : 35000}+ Registered Artisans',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12, color: Colors.white70, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2. Short Description of Handicraft Heritage (Requirement 4)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Heritage Overview',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTerracotta,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            stateModel.cultureOverview,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Stats Highlights Card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                Expanded(child: _buildStatColumn('${stateModel.totalArtisans > 0 ? stateModel.totalArtisans : 35000}', 'Artisans')),
                                _buildDivider(),
                                Expanded(child: _buildStatColumn('${stateModel.giProducts.isNotEmpty ? stateModel.giProducts.length : 18}', 'GI Crafts')),
                                _buildDivider(),
                                Expanded(child: _buildStatColumn('${stateModel.keyDistricts.length}', 'ODOP Hubs')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. District Map & Craft Origins (Requirement 4)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    sliver: SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryTerracotta.withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.map_rounded, color: AppColors.primaryTerracotta, size: 20),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'District Craft Map & Origins',
                                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                                      ),
                                      Text('Tap a district to filter authentic craft clusters', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: districtOrigins.map((d) {
                                final distName = d['district']!;
                                final craftName = d['craft']!;
                                final isSelected = _selectedDistrict == distName;

                                return ChoiceChip(
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      _selectedDistrict = selected ? distName : null;
                                    });
                                  },
                                  avatar: Icon(
                                    Icons.location_on_rounded,
                                    size: 14,
                                    color: isSelected ? Colors.white : AppColors.primaryTerracotta,
                                  ),
                                  label: Text('$distName ($craftName)'),
                                  labelStyle: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                  selectedColor: AppColors.primaryTerracotta,
                                  backgroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: BorderSide(color: isSelected ? AppColors.primaryTerracotta : AppColors.border),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 4. Popular Crafts Section (Requirement 4 & 5)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Popular Crafts of ${stateModel.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 24),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 290,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: filteredPopularCrafts.isNotEmpty ? filteredPopularCrafts.length : popularCrafts.length,
                          itemBuilder: (context, idx) {
                            final craft = filteredPopularCrafts.isNotEmpty ? filteredPopularCrafts[idx] : popularCrafts[idx];
                            return StateCraftCard(
                              craft: craft,
                              onTap: () => context.push('/product-detail', extra: craft),
                              onArtisanTap: () => context.push('/artisan-chat', extra: ArtisanChatArgs(
                                artisanId: 'artisan_${craft.id}',
                                name: craft.artisanName,
                                avatar: craft.imageUrl,
                                craft: craft.name,
                                location: '${craft.district}, ${craft.stateName}',
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // 5. Hidden Gems Section (Underrated Crafts) (Requirement 4 & 5)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hidden Gems — Underrated Crafts',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Text(
                                  'Rare, endangered traditions preserved by local masters',
                                  style: TextStyle(fontSize: 11, color: AppColors.textLight),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 24),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 290,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: hiddenGems.length,
                          itemBuilder: (context, idx) {
                            final craft = hiddenGems[idx];
                            return StateCraftCard(
                              craft: craft,
                              onTap: () => context.push('/product-detail', extra: craft),
                              onArtisanTap: () => context.push('/artisan-chat', extra: ArtisanChatArgs(
                                artisanId: 'artisan_${craft.id}',
                                name: craft.artisanName,
                                avatar: craft.imageUrl,
                                craft: craft.name,
                                location: '${craft.district}, ${craft.stateName}',
                              )),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  // 6. Featured Artisans Section (Requirement 4)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Row(
                        children: [
                          const Icon(Icons.workspace_premium_rounded, color: AppColors.primaryTerracotta, size: 22),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Master Artisans of ${stateModel.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Playfair Display',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: featuredArtisans.map((artisan) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 26,
                                  backgroundColor: AppColors.primaryTerracotta.withValues(alpha: 0.1),
                                  child: Text(
                                    artisan['name']!.substring(0, 1),
                                    style: const TextStyle(
                                      fontFamily: 'Playfair Display',
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryTerracotta,
                                    ),
                                  ),
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
                                              artisan['name']!,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.secondary),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        artisan['specialty']!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 11, color: AppColors.primaryTerracotta, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '📍 ${artisan['district']} • ${artisan['badge']}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () => context.push('/artisan-chat', extra: ArtisanChatArgs(
                                    artisanId: artisan['id']!,
                                    name: artisan['name']!,
                                    avatar: artisan['avatar']!,
                                    craft: artisan['specialty']!,
                                    location: artisan['district']!,
                                  )),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTerracotta,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: const Text('Connect', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 7. Sticky View Marketplace Button (Requirement 4)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, -4)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/category-listing', extra: {
                      'title': '${stateModel.name} Authentic Marketplace',
                      'stateId': stateModel.id,
                    });
                  },
                  icon: const Icon(Icons.storefront_rounded, size: 20),
                  label: Text(
                    'Explore ${stateModel.name} Marketplace',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTerracotta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryTerracotta),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 28,
      width: 1,
      color: AppColors.border,
    );
  }
}
