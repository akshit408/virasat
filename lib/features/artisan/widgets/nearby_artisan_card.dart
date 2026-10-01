import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/nearby_artisan_model.dart';
import '../../../../models/artisan_model.dart';
import '../../../../widgets/sheets/artisan_profile_sheet.dart';

class NearbyArtisanCard extends StatelessWidget {
  final NearbyArtisanModel artisan;
  final double userLat;
  final double userLng;
  final bool isSelected;
  final VoidCallback? onTap;

  const NearbyArtisanCard({
    super.key,
    required this.artisan,
    required this.userLat,
    required this.userLng,
    this.isSelected = false,
    this.onTap,
  });

  Future<void> _launchNavigation(BuildContext context) async {
    final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${artisan.latitude},${artisan.longitude}');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(url);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Opening Google Maps navigation to ${artisan.name}...'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openProfile(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final distance = artisan.distanceKmFrom(userLat, userLng);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.secondary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isSelected
                ? AppColors.secondary.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap ?? () => _openProfile(context),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Artisan Profile Image / Avatar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        artisan.profileImage,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 64,
                          height: 64,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          child: const Icon(Icons.person_rounded, color: AppColors.primary, size: 32),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Artisan Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  artisan.name,
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
                              if (artisan.verified) ...[
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded, size: 16, color: AppColors.secondary),
                              ],
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            artisan.craftSpecialization,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.place_outlined, size: 13, color: AppColors.textSecondary),
                              const SizedBox(width: 2),
                              Expanded(
                                child: Text(
                                  '${artisan.villageOrDistrict} • ${artisan.state} • ${artisan.experienceYears} yrs',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Distance Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${distance.toStringAsFixed(1)} km',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                          const Text(
                            'away',
                            style: TextStyle(fontSize: 9, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.border),
                const SizedBox(height: 12),

                // Action Buttons Row: Profile & Navigate
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _openProfile(context),
                        icon: const Icon(Icons.person_outline_rounded, size: 16),
                        label: const Text('View Profile'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textPrimary,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchNavigation(context),
                        icon: const Icon(Icons.navigation_rounded, size: 16),
                        label: const Text('Navigate'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
