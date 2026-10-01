import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/state_path_model.dart';
import '../../providers/discover_provider.dart';
import '../../widgets/chips/category_chip.dart';
import '../../widgets/map/interactive_india_map.dart';
import '../../widgets/typography/section_title.dart';
import '../../core/utils/craft_image_helper.dart';
import '../../core/utils/state_helper.dart';
import '../../providers/marketplace_provider.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final TextEditingController _searchController = TextEditingController();

  final List<String> _regions = [
    'All',
    'North',
    'South',
    'East',
    'West',
    'Central',
    'North-East',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final discoverState = ref.watch(discoverControllerProvider);
    final controller = ref.read(discoverControllerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Discover Virasat'),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => context.push('/nearby-artisans'),
            icon: const Icon(Icons.location_on_outlined, color: AppColors.primary),
            tooltip: 'Nearby Artisans Map',
          ),
        ],
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => controller.setSearchQuery(val),
              decoration: const InputDecoration(
                hintText: 'Search states, GI tags, traditional crafts...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.primary),
              ),
            ),
          ),

          if (discoverState.selectedStateId != null) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                avatar: const Icon(Icons.location_on_rounded, size: 16, color: Colors.white),
                label: Text(
                  'State Filter: ${getStateFullName(discoverState.selectedStateId)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12),
                ),
                backgroundColor: AppColors.primary,
                deleteIcon: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
                onDeleted: () {
                  controller.selectState(null);
                  ref.read(selectedStateFilterProvider.notifier).state = null;
                },
              ),
            ),
          ],

          const SizedBox(height: 20),

          // Interactive India SVG Map Component
          InteractiveIndiaMap(
            onStateSelected: (statePath) {
              controller.selectState(statePath.id);
              context.push('/state-detail', extra: {'stateId': statePath.id});
            },
          ),

          const SizedBox(height: 24),

          // Regions Selection Section
          const SectionTitle(title: 'Discover Regions'),
          const SizedBox(height: 12),

          SizedBox(
            height: 42,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _regions.length,
              itemBuilder: (context, index) {
                final region = _regions[index];
                final isSelected = discoverState.selectedRegion == region;
                return CategoryChip(
                  label: region,
                  icon: _getRegionIcon(region),
                  isSelected: isSelected,
                  onTap: () => controller.selectRegion(region),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // State Craft Showcase Section
          SectionTitle(
            title: 'Cultural Heritage States',
            actionText: 'Reset Filter',
            onActionPressed: () {
              controller.selectRegion('All');
              controller.selectState(null);
              ref.read(selectedStateFilterProvider.notifier).state = null;
            },
          ),
          const SizedBox(height: 12),

          if (discoverState.isLoading)
            const Center(child: CircularProgressIndicator())
          else ...[
            ...discoverState.statePaths
                .where((s) {
                  final matchesRegion = discoverState.selectedRegion == 'All' || s.region == discoverState.selectedRegion;
                  final matchesQuery = discoverState.searchQuery.isEmpty ||
                      s.name.toLowerCase().contains(discoverState.searchQuery.toLowerCase()) ||
                      s.capital.toLowerCase().contains(discoverState.searchQuery.toLowerCase());
                  final selectedState = discoverState.selectedStateId;
                  final matchesState = selectedState == null ||
                      s.id.toLowerCase() == selectedState.toLowerCase() ||
                      getStateFullName(s.id).toLowerCase() == getStateFullName(selectedState).toLowerCase() ||
                      getStateFullName(s.name).toLowerCase() == getStateFullName(selectedState).toLowerCase();
                  return matchesRegion && matchesQuery && matchesState;
                })
                .map((statePath) {
                  final selectedState = discoverState.selectedStateId;
                  final isCardSelected = selectedState != null &&
                      (selectedState.toLowerCase() == statePath.id.toLowerCase() ||
                          getStateFullName(selectedState).toLowerCase() == getStateFullName(statePath.name).toLowerCase());
                  return _buildStateCard(context, statePath, isCardSelected);
                }),
          ],
        ],
      ),
    );
  }

  IconData _getRegionIcon(String region) {
    switch (region) {
      case 'North':
        return Icons.landscape_rounded;
      case 'South':
        return Icons.temple_hindu_rounded;
      case 'East':
        return Icons.waves_rounded;
      case 'West':
        return Icons.wb_sunny_rounded;
      case 'Central':
        return Icons.hub_rounded;
      case 'North-East':
        return Icons.forest_rounded;
      default:
        return Icons.explore_rounded;
    }
  }

  Widget _buildStateCard(BuildContext context, StatePathModel statePath, bool isSelected) {
    return GestureDetector(
      onTap: () {
        ref.read(discoverControllerProvider.notifier).selectState(statePath.id);
        context.push('/state-detail', extra: {'stateId': statePath.id});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                getCraftImagePath(statePath.name),
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          statePath.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          statePath.region,
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Capital: ${statePath.capital}',
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textLight,
            ),
          ],
        ),
      ),
    );
  }
}

