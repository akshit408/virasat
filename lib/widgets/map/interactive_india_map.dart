import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/theme/app_colors.dart';
import '../../models/state_path_model.dart';
import '../../providers/discover_provider.dart';

class InteractiveIndiaMap extends ConsumerStatefulWidget {
  final ValueChanged<StatePathModel>? onStateSelected;

  const InteractiveIndiaMap({
    super.key,
    this.onStateSelected,
  });

  @override
  ConsumerState<InteractiveIndiaMap> createState() => _InteractiveIndiaMapState();
}

class _InteractiveIndiaMapState extends ConsumerState<InteractiveIndiaMap> {
  final TransformationController _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    ref.read(discoverControllerProvider.notifier).resetZoom();
  }

  @override
  Widget build(BuildContext context) {
    final discoverState = ref.watch(discoverControllerProvider);
    final statePathsAsync = ref.watch(statePathsFutureProvider);

    return Container(
      height: 380,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background SVG Grid motif
            Positioned.fill(
              child: Opacity(
                opacity: 0.03,
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 8),
                  itemBuilder: (_, __) => Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary, width: 0.5),
                    ),
                  ),
                ),
              ),
            ),

            // Interactive Pinch-To-Zoom Viewport
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.8,
              maxScale: 4.0,
              onInteractionUpdate: (details) {
                final scale = _transformationController.value.getMaxScaleOnAxis();
                ref.read(discoverControllerProvider.notifier).setZoomScale(scale);
              },
              child: Center(
                child: LayoutBuilder(
                  builder: (context, mapConstraints) {
                    final mapWidth = (mapConstraints.maxWidth.isFinite && mapConstraints.maxWidth > 0)
                        ? mapConstraints.maxWidth.clamp(260.0, 360.0)
                        : 320.0;
                    final mapHeight = (mapWidth * (360.0 / 340.0)).clamp(260.0, 380.0);
                    return SizedBox(
                      width: mapWidth,
                      height: mapHeight,
                      child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Base SVG Map Asset
                      SvgPicture.asset(
                        'assets/maps/india_map.svg',
                        fit: BoxFit.contain,
                        colorFilter: const ColorFilter.mode(
                          AppColors.chipBackground,
                          BlendMode.srcIn,
                        ),
                      ),

                      // State Tap Regions & Overlay Highlights
                      statePathsAsync.when(
                        data: (statePaths) {
                          final filteredPaths = discoverState.selectedRegion == 'All'
                              ? statePaths
                              : statePaths.where((s) => s.region == discoverState.selectedRegion).toList();

                          return Stack(
                            children: filteredPaths.map((statePath) {
                              final isSelected = discoverState.selectedStateId == statePath.id;
                              final isInSelectedRegion = discoverState.selectedRegion == 'All' || statePath.region == discoverState.selectedRegion;

                              final Color stateColor = isSelected
                                  ? AppColors.primary
                                  : isInSelectedRegion
                                      ? AppColors.secondary
                                      : AppColors.border;

                              return Positioned(
                                left: (statePath.centerX / 800.0) * 340.0 - 18,
                                top: (statePath.centerY / 900.0) * 360.0 - 18,
                                child: GestureDetector(
                                  onTap: () {
                                    ref.read(discoverControllerProvider.notifier).selectState(statePath.id);
                                    if (widget.onStateSelected != null) {
                                      widget.onStateSelected!(statePath);
                                    }
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : isInSelectedRegion
                                              ? AppColors.secondary.withValues(alpha: 0.25)
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: stateColor,
                                        width: isSelected ? 2.5 : 1.2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.primary.withValues(alpha: 0.4),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      Icons.location_on_rounded,
                                      size: isSelected ? 22 : 14,
                                      color: isSelected ? Colors.white : stateColor,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (_, __) => const SizedBox(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),

            // Top Floating Instructions & Region Badge
            Positioned(
              top: 14,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.zoom_in_rounded, size: 14, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Pinch to Zoom • Tap State',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (discoverState.isMapZoomed)
                    GestureDetector(
                      onTap: _resetZoom,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: AppColors.cardShadow, blurRadius: 6),
                          ],
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.restart_alt_rounded, size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Reset Zoom',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
