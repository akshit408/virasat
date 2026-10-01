import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../virasat_connect/models/government_scheme_model.dart';
import '../../virasat_connect/models/ngo_partner_model.dart';
import '../../virasat_connect/models/training_centre_model.dart';
import '../../virasat_connect/models/workshop_event_model.dart';
import '../../virasat_connect/providers/virasat_connect_provider.dart';
import '../../virasat_connect/widgets/smart_notification_center_sheet.dart';
import '../../virasat_connect/widgets/workshop_registration_sheet.dart';
import '../providers/nearby_artisan_provider.dart';
import '../widgets/artisan_map_view.dart';
import '../widgets/nearby_artisan_card.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../widgets/cards/safe_product_image.dart';

class NearbyArtisansScreen extends ConsumerStatefulWidget {
  const NearbyArtisansScreen({super.key});

  @override
  ConsumerState<NearbyArtisansScreen> createState() => _NearbyArtisansScreenState();
}

class _NearbyArtisansScreenState extends ConsumerState<NearbyArtisansScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(nearbyArtisanProvider.notifier).detectCurrentLocation();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrlStr(String urlStr) async {
    final url = Uri.parse(urlStr);
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    } catch (_) {}
  }

  Widget _buildTabButton({
    required String label,
    required ConnectTabMode tab,
    required ConnectTabMode activeTab,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = tab == activeTab;
    return GestureDetector(
      onTap: () {
        ref.read(virasatConnectProvider.notifier).selectTab(tab);
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? color : AppColors.border),
          boxShadow: isSelected
              ? [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2))]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final artisanState = ref.watch(nearbyArtisanProvider);
    final artisanNotifier = ref.read(nearbyArtisanProvider.notifier);

    final connectState = ref.watch(virasatConnectProvider);
    final connectNotifier = ref.read(virasatConnectProvider.notifier);

    final filteredArtisans = artisanState.filteredAndSortedArtisans;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.tr(context, 'connect_title'),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          // Smart Notification Bell Button
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined, color: AppColors.primaryTerracotta),
                tooltip: 'Smart Notifications',
                onPressed: () => SmartNotificationCenterSheet.show(context),
              ),
              if (connectState.unreadNotificationsCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryTerracotta,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${connectState.unreadNotificationsCount}',
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: Icon(
              artisanState.isDetectingLocation ? Icons.gps_fixed : Icons.my_location_rounded,
              color: AppColors.primaryTerracotta,
            ),
            tooltip: 'Detect GPS Location',
            onPressed: () => artisanNotifier.detectCurrentLocation(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Tab Navigation Bar (Artisans | Workshops | NGOs | Schemes | Training)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: AppColors.surface,
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildTabButton(
                          label: '${AppLocalizations.tr(context, 'tab_artisans')} (${filteredArtisans.length})',
                          tab: ConnectTabMode.artisans,
                          activeTab: connectState.selectedTab,
                          icon: Icons.people_outline_rounded,
                          color: AppColors.forestGreen,
                        ),
                        _buildTabButton(
                          label: '${AppLocalizations.tr(context, 'tab_workshops')} (${connectState.filteredWorkshops.length})',
                          tab: ConnectTabMode.workshops,
                          activeTab: connectState.selectedTab,
                          icon: Icons.event_available_rounded,
                          color: AppColors.primaryTerracotta,
                        ),
                        _buildTabButton(
                          label: '${AppLocalizations.tr(context, 'tab_ngos')} (${connectState.filteredNGOs.length})',
                          tab: ConnectTabMode.ngos,
                          activeTab: connectState.selectedTab,
                          icon: Icons.volunteer_activism_rounded,
                          color: AppColors.saffronGold,
                        ),
                        _buildTabButton(
                          label: '${AppLocalizations.tr(context, 'tab_schemes')} (${connectState.filteredSchemes.length})',
                          tab: ConnectTabMode.schemes,
                          activeTab: connectState.selectedTab,
                          icon: Icons.account_balance_rounded,
                          color: AppColors.forestGreen,
                        ),
                        _buildTabButton(
                          label: '${AppLocalizations.tr(context, 'tab_training')} (${connectState.filteredTrainingCentres.length})',
                          tab: ConnectTabMode.trainingCentres,
                          activeTab: connectState.selectedTab,
                          icon: Icons.school_outlined,
                          color: AppColors.darkBrown,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Search Bar
                  TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      artisanNotifier.setSearchQuery(val);
                      connectNotifier.setSearchQuery(val);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search craft, workshop, scheme, or NGO...',
                      prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                artisanNotifier.setSearchQuery('');
                                connectNotifier.setSearchQuery('');
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      filled: true,
                      fillColor: AppColors.background,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: AppColors.border),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab Content Display Area
            Expanded(
              child: () {
                switch (connectState.selectedTab) {
                  case ConnectTabMode.artisans:
                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: ArtisanMapView(
                              userLat: artisanState.userLat,
                              userLng: artisanState.userLng,
                              radiusKm: artisanState.selectedRadiusKm,
                              artisans: filteredArtisans,
                              selectedArtisanId: artisanState.selectedArtisanId,
                              onSelectArtisan: (id) => artisanNotifier.selectArtisan(id),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            physics: const BouncingScrollPhysics(),
                            itemCount: filteredArtisans.length,
                            itemBuilder: (context, index) {
                              return NearbyArtisanCard(
                                artisan: filteredArtisans[index],
                                userLat: artisanState.userLat,
                                userLng: artisanState.userLng,
                                isSelected: filteredArtisans[index].id == artisanState.selectedArtisanId,
                                onTap: () => artisanNotifier.selectArtisan(filteredArtisans[index].id),
                              );
                            },
                          ),
                        ),
                      ],
                    );

                  case ConnectTabMode.workshops:
                    final workshops = connectState.filteredWorkshops;
                    if (workshops.isEmpty) {
                      return const Center(child: Text('No upcoming workshops found.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: workshops.length,
                      itemBuilder: (context, index) {
                        return _buildWorkshopCard(context, workshops[index]);
                      },
                    );

                  case ConnectTabMode.schemes:
                    final schemes = connectState.filteredSchemes;
                    if (schemes.isEmpty) {
                      return const Center(child: Text('No government schemes found.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: schemes.length,
                      itemBuilder: (context, index) {
                        return _buildSchemeCard(context, schemes[index]);
                      },
                    );

                  case ConnectTabMode.ngos:
                    final ngos = connectState.filteredNGOs;
                    if (ngos.isEmpty) {
                      return const Center(child: Text('No NGO partners found.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: ngos.length,
                      itemBuilder: (context, index) {
                        return _buildNGOCard(context, ngos[index]);
                      },
                    );

                  case ConnectTabMode.trainingCentres:
                    final centres = connectState.filteredTrainingCentres;
                    if (centres.isEmpty) {
                      return const Center(child: Text('No training centres found.'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      physics: const BouncingScrollPhysics(),
                      itemCount: centres.length,
                      itemBuilder: (context, index) {
                        return _buildTrainingCard(context, centres[index]);
                      },
                    );
                }
              }(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkshopCard(BuildContext context, WorkshopEvent item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SafeProductImage(
                imagePath: item.bannerImage,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.circular(12),
                placeholderIcon: Icons.palette_outlined,
                placeholderText: 'Workshop Image',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.craftCategory,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryTerracotta),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.getLocalizedTitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20, color: AppColors.primaryTerracotta),
                tooltip: AppLocalizations.tr(context, 'listen_audio'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.tr(context, 'playing_audio')),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(item.getLocalizedDescription(context), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textLight),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  item.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                ),
              ),
              const SizedBox(width: 8),
              Text('${item.availableSeats} seats left', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: item.isRegistered ? null : () => WorkshopRegistrationSheet.show(context, item),
              icon: Icon(item.isRegistered ? Icons.check_circle_rounded : Icons.event_available_rounded, size: 16),
              label: Text(
                item.isRegistered ? AppLocalizations.tr(context, 'registered') : AppLocalizations.tr(context, 'register_now'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                backgroundColor: item.isRegistered ? AppColors.forestGreen : AppColors.primaryTerracotta,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSchemeCard(BuildContext context, GovernmentScheme item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.forestGreen.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.account_balance_rounded, color: AppColors.forestGreen, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.ministry, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                    Text(
                      item.getLocalizedTitle(context),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.volume_up_rounded, size: 20, color: AppColors.forestGreen),
                tooltip: AppLocalizations.tr(context, 'listen_audio'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(AppLocalizations.tr(context, 'playing_audio')),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.forestGreen.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard_rounded, color: AppColors.forestGreen, size: 18),
                const SizedBox(width: 8),
                Expanded(child: Text(item.getLocalizedSubsidy(context), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.forestGreen))),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(item.getLocalizedDescription(context), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _launchUrlStr(item.officialLink),
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: Text(
                AppLocalizations.tr(context, 'apply_grant'),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                foregroundColor: AppColors.forestGreen,
                side: const BorderSide(color: AppColors.forestGreen),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNGOCard(BuildContext context, NGOPartner item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.volunteer_activism_rounded, color: AppColors.saffronGold, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.getLocalizedName(context), style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text(item.getLocalizedFocusArea(context), style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(item.getLocalizedDescription(context), style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text('📍 ${item.location}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textLight))),
              const SizedBox(width: 8),
              Text('${item.supportedArtisansCount}+ Artisans Supported', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkBrown)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrainingCard(BuildContext context, TrainingCentre item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.school_outlined, color: AppColors.darkBrown, size: 28),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.getLocalizedName(context), style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text(item.getLocalizedCertification(context), style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text('📍 ${item.address}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
