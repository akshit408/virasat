import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/nearby_artisan_model.dart';
import '../../../../widgets/sheets/artisan_profile_sheet.dart';
import '../../../../models/artisan_model.dart';

class ArtisanMapView extends StatelessWidget {
  final double userLat;
  final double userLng;
  final double radiusKm;
  final List<NearbyArtisanModel> artisans;
  final String? selectedArtisanId;
  final ValueChanged<String?> onSelectArtisan;

  const ArtisanMapView({
    super.key,
    required this.userLat,
    required this.userLng,
    required this.radiusKm,
    required this.artisans,
    this.selectedArtisanId,
    required this.onSelectArtisan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEAE5D9), // Warm map terrain canvas
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Styled Map Background Canvas
            CustomPaint(
              size: Size.infinite,
              painter: _MapCanvasPainter(),
            ),

            // Radius Circle Overlay Label
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.radar_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      radiusKm <= 0 ? 'Showing All Artisans' : 'Radius: ${radiusKm.toInt()} km',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),

            // Map Markers Layer
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final height = constraints.maxHeight;
                final center = Offset(width / 2, height / 2);

                return Stack(
                  children: [
                    // User Location Marker (Center - Alkapuri, Vadodara)
                    Positioned(
                      left: center.dx - 18,
                      top: center.dy - 18,
                      child: Tooltip(
                        message: 'Your GPS Location (Vadodara)',
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.blueAccent, width: 2),
                          ),
                          child: Center(
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Colors.blueAccent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(color: Colors.blue, blurRadius: 8, spreadRadius: 2),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Artisan Pin Markers
                    ...artisans.map((artisan) {
                      final isSelected = artisan.id == selectedArtisanId;

                      // Map GPS coordinates to viewport relative to center
                      final latDiff = (artisan.latitude - userLat);
                      final lngDiff = (artisan.longitude - userLng);

                      // Scaling factor for display
                      final dx = center.dx + (lngDiff * 4500);
                      final dy = center.dy - (latDiff * 4500);

                      // Clamp coordinates inside map boundary
                      final clampedX = dx.clamp(28.0, width - 28.0);
                      final clampedY = dy.clamp(28.0, height - 28.0);

                      return Positioned(
                        left: clampedX - (isSelected ? 24 : 18),
                        top: clampedY - (isSelected ? 48 : 36),
                        child: GestureDetect(
                          artisan: artisan,
                          isSelected: isSelected,
                          onTap: () {
                            onSelectArtisan(artisan.id);
                            _showArtisanPreviewSheet(context, artisan);
                          },
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showArtisanPreviewSheet(BuildContext context, NearbyArtisanModel artisan) {
    // Adapt NearbyArtisanModel into ArtisanModel for standard sheet presentation
    final adapted = ArtisanModel(
      id: artisan.id,
      name: artisan.name,
      gender: 'Master Craftsman',
      stateId: artisan.state,
      village: artisan.villageOrDistrict,
      craftId: artisan.craftSpecialization,
      experienceYears: artisan.experienceYears,
      languages: const ['Gujarati', 'Hindi', 'English'],
      bio: artisan.craftStory,
      verified: artisan.verified,
      rating: artisan.rating,
      profileImage: artisan.profileImage,
    );

    ArtisanProfileSheet.show(context, adapted);
  }
}

class GestureDetect extends StatelessWidget {
  final NearbyArtisanModel artisan;
  final bool isSelected;
  final VoidCallback onTap;
  final Color markerColor;
  final IconData markerIcon;

  const GestureDetect({
    super.key,
    required this.artisan,
    required this.isSelected,
    required this.onTap,
    this.markerColor = AppColors.primaryTerracotta,
    this.markerIcon = Icons.palette_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final pinColor = isSelected ? AppColors.saffronGold : markerColor;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? pinColor : AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: pinColor, width: isSelected ? 2 : 1),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  markerIcon,
                  size: 12,
                  color: isSelected ? Colors.white : pinColor,
                ),
                const SizedBox(width: 4),
                Text(
                  artisan.name.split(' ').first,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.location_on_rounded,
            size: isSelected ? 32 : 24,
            color: pinColor,
          ),
        ],
      ),
    );
  }
}

class _MapCanvasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFDCD4C4)
      ..strokeWidth = 1.0;

    final roadPaint = Paint()
      ..color = const Color(0xFFF7F3EB)
      ..strokeWidth = 6.0;

    final riverPaint = Paint()
      ..color = const Color(0xFFA5C9EB).withValues(alpha: 0.6)
      ..strokeWidth = 12.0
      ..style = PaintingStyle.stroke;

    // Draw Map Grid Lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), gridPaint);
    }

    // Draw Simulated Roads
    canvas.drawLine(Offset(0, size.height * 0.5), Offset(size.width, size.height * 0.5), roadPaint);
    canvas.drawLine(Offset(size.width * 0.5, 0), Offset(size.width * 0.5, size.height), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.2), Offset(size.width, size.height * 0.8), roadPaint);

    // Draw River (Vishwamitri River simulation)
    final riverPath = Path()
      ..moveTo(size.width * 0.1, 0)
      ..quadraticBezierTo(size.width * 0.4, size.height * 0.5, size.width * 0.9, size.height);
    canvas.drawPath(riverPath, riverPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
