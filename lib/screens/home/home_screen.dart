import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/gi_product_model.dart';
import '../../models/artisan_model.dart';
import '../../models/home_banner_model.dart';
import '../../models/state_model.dart';
import '../../providers/marketplace_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/sheets/artisan_profile_sheet.dart';
import '../../core/utils/state_helper.dart';
import '../../widgets/cards/state_circle_card.dart';
import '../../widgets/cards/safe_product_image.dart';
import '../../features/virasat_connect/providers/virasat_connect_provider.dart';
import '../../features/virasat_connect/widgets/smart_notification_center_sheet.dart';
import '../../features/virasat_connect/widgets/workshop_registration_sheet.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/permission_service.dart';
import '../../core/services/location_service.dart';
import '../../widgets/home/home_collection_pills_widget.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _bannerController = PageController();
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  bool _hasLocationPermission = false;
  String _selectedStateFallback = 'Gujarat';

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkLocationPermissionOnLoad();
    });
  }

  Future<void> _checkLocationPermissionOnLoad() async {
    final granted = await PermissionService.requestLocationPermission(context);
    final savedState = await LocationService.getSelectedState();
    if (mounted) {
      setState(() {
        _hasLocationPermission = granted;
        _selectedStateFallback = savedState;
      });
    }
  }

  void _showStateSelectorDialog() {
    final statesList = [
      'Gujarat', 'Rajasthan', 'Assam', 'Bihar', 'Jammu & Kashmir', 'Uttar Pradesh',
      'West Bengal', 'Tamil Nadu', 'Karnataka', 'Maharashtra', 'Madhya Pradesh', 'Odisha'
    ];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Select Location State', style: TextStyle(fontFamily: 'Playfair Display', fontWeight: FontWeight.bold)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: statesList.length,
            itemBuilder: (context, idx) {
              final st = statesList[idx];
              return ListTile(
                title: Text(st, style: const TextStyle(fontWeight: FontWeight.w600)),
                trailing: _selectedStateFallback == st ? const Icon(Icons.check_circle_rounded, color: AppColors.primary) : null,
                onTap: () async {
                  await LocationService.setSelectedState(st);
                  if (mounted) {
                    setState(() {
                      _selectedStateFallback = st;
                    });
                    Navigator.pop(ctx);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerIndex + 1) % 10;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeDataAsync = ref.watch(marketplaceHomeDataProvider);
    final wishlistItems = ref.watch(wishlistProvider);
    final cartItems = ref.watch(cartProvider);
    final connectState = ref.watch(virasatConnectProvider);
    final unreadConnectNotifs = connectState.unreadNotificationsCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: homeDataAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off_rounded, size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  const Text(
                    'Unable to connect to Virasat server. Check that your phone and laptop are on the same Wi-Fi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => ref.invalidate(marketplaceHomeDataProvider),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry Connection'),
                  ),
                ],
              ),
            ),
          ),
          data: (data) {
            final banners = data.banners;
            final products = data.products;
            final artisans = data.artisans;
            final categories = data.categories;
            final states = data.states;
            // ignore: unused_local_variable
            final stories = data.stories;
            final giProducts = products.where((p) => p.isGiTagged).toList();

            return RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                ref.invalidate(marketplaceHomeDataProvider);
                await ref.read(marketplaceHomeDataProvider.future);
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                slivers: [
                // Top App Bar
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.tr(context, 'app_title'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Playfair Display',
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                  Text(
                                    AppLocalizations.tr(context, 'app_tagline'),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => context.go('/role-selection'),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.4)),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.storefront_rounded, size: 14, color: AppColors.primary),
                                      SizedBox(width: 4),
                                      Text(
                                        'Seller Hub ▾',
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                                  tooltip: 'VIRASAT Connect Notifications',
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) => const SmartNotificationCenterSheet(),
                                    );
                                  },
                                ),
                                if (unreadConnectNotifs > 0)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFA63E24),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '$unreadConnectNotifs',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite_border_rounded, color: AppColors.textPrimary),
                                  onPressed: () => context.push('/wishlist'),
                                ),
                                if (wishlistItems.isNotEmpty)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${wishlistItems.length}',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.textPrimary),
                                  onPressed: () => context.push('/cart'),
                                ),
                                if (cartItems.isNotEmpty)
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Text(
                                        '${cartItems.length}',
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Search Bar Trigger
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                  sliver: SliverToBoxAdapter(
                    child: GestureDetector(
                      onTap: () => context.push('/search'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.border),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search_rounded, color: AppColors.primary, size: 20),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                AppLocalizations.tr(context, 'search_placeholder'),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, color: AppColors.textLight),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Dynamic Festival Collection Pills (Navratri, Diwali, GI Heritage)
                const SliverToBoxAdapter(
                  child: HomeCollectionPillsWidget(),
                ),

                // Hero Banner Carousel (Artisan India)
                if (banners.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 6, 20, 12),
                    sliver: SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: PageView.builder(
                              controller: _bannerController,
                              onPageChanged: (idx) {
                                setState(() => _currentBannerIndex = idx);
                              },
                              itemCount: banners.length,
                              itemBuilder: (context, idx) {
                                final banner = banners[idx];
                                return _buildHeroBannerCard(banner, idx);
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Page Indicator Dots
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(banners.length, (idx) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: _currentBannerIndex == idx ? 20 : 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: _currentBannerIndex == idx ? AppColors.primary : AppColors.border,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Categories Section (Horizontal Chips)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: AppLocalizations.tr(context, 'explore_craft_traditions'),
                      subtitle: AppLocalizations.tr(context, 'app_tagline'),
                      onViewAll: () {
                        context.push(
                          '/category-listing',
                          extra: {'title': AppLocalizations.tr(context, 'explore_craft_traditions')},
                        );
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 10, bottom: 24),
                  sliver: SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: categories.map((category) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: ActionChip(
                              avatar: const Icon(Icons.auto_awesome_rounded, size: 16, color: AppColors.primary),
                              label: Text(
                                category.getLocalizedName(context),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              backgroundColor: AppColors.surface,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onPressed: () {
                                context.push(
                                  '/category-listing',
                                  extra: {
                                    'title': category.getLocalizedName(context),
                                    'categoryId': category.id,
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Newly Listed Near You (Location-Based Crafts within 50 km)
                Builder(
                  builder: (context) {
                    final nearbyDistances = [
                      '2.1 km • Ahmedabad',
                      '5.8 km • Vadodara',
                      '12 km • Anand',
                      '24 km • Jamnagar',
                      '38 km • Surat',
                      '42 km • Rajkot',
                    ];

                    final displayProducts = products.take(6).toList();

                    return SliverPadding(
                      padding: const EdgeInsets.only(bottom: 24),
                      sliver: SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                children: [
                                  const Icon(Icons.near_me_rounded, color: AppColors.secondary, size: 20),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'New in Market',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: _showStateSelectorDialog,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _hasLocationPermission
                                            ? Colors.green.withValues(alpha: 0.12)
                                            : Colors.orange.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: _hasLocationPermission ? Colors.green : Colors.orange,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            _hasLocationPermission ? Icons.gps_fixed_rounded : Icons.edit_location_alt_rounded,
                                            size: 12,
                                            color: _hasLocationPermission ? Colors.green : Colors.orange,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            _hasLocationPermission
                                                ? '< 50 km GPS'
                                                : 'State: $_selectedStateFallback',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: _hasLocationPermission ? Colors.green : Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                _hasLocationPermission
                                    ? 'Crafts originating within 50 km of your current GPS location'
                                    : 'Showing authentic crafts from $_selectedStateFallback (Tap badge to switch state)',
                                style: const TextStyle(fontSize: 11, color: AppColors.textLight),
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (products.isEmpty) ...[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: const [
                                    BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4)),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.08),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.storefront_rounded,
                                        size: 48,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    const Text(
                                      'Be the first verified artisan to upload your craft.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Playfair Display',
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Showcase your heritage creation to buyers across India with AI Studio.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: AppColors.textLight),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      ),
                                      onPressed: () => context.push('/ai-scanner'),
                                      icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                                      label: const Text(
                                        'Start Selling',
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ] else ...[
                              SizedBox(
                                height: 245,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.symmetric(horizontal: 20),
                                  itemCount: displayProducts.length,
                                  itemBuilder: (context, idx) {
                                    final craft = displayProducts[idx];
                                    final distanceTag = nearbyDistances[idx % nearbyDistances.length];
                                    return _buildCraftCard(context, craft, distanceTag: distanceTag);
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),

                // Trending Crafts (Horizontal Premium Cards)
                if (products.isNotEmpty) ...[
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: _buildSectionHeader(
                        title: AppLocalizations.tr(context, 'trending_craft_masterpieces'),
                        subtitle: AppLocalizations.tr(context, 'app_tagline'),
                        onViewAll: () {
                          context.push(
                            '/category-listing',
                            extra: {'title': AppLocalizations.tr(context, 'trending_craft_masterpieces')},
                          );
                        },
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 12, bottom: 28),
                    sliver: SliverToBoxAdapter(
                      child: SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: products.take(10).length,
                          itemBuilder: (context, idx) {
                            final product = products[idx];
                            return _buildCraftCard(context, product);
                          },
                        ),
                      ),
                    ),
                  ),
                ],

                // VIRASAT Connect — Network & Opportunities Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: AppLocalizations.tr(context, 'connect_title'),
                      subtitle: AppLocalizations.tr(context, 'connect_subtitle'),
                      onViewAll: () {
                        context.push('/virasat-connect');
                      },
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 12, bottom: 28),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 235,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          if (connectState.workshops.isNotEmpty) ...[
                            for (final w in connectState.workshops.take(2))
                              _buildOpportunityCard(
                                context: context,
                                title: w.getLocalizedTitle(context),
                                badgeLabel: AppLocalizations.tr(context, 'tab_workshops').toUpperCase(),
                                badgeColor: const Color(0xFFA63E24),
                                icon: Icons.event_seat_rounded,
                                subtitle: '${w.location} • ${w.availableSeats} seats left',
                                details: w.getLocalizedDescription(context),
                                actionText: w.isRegistered ? AppLocalizations.tr(context, 'registered') : AppLocalizations.tr(context, 'register_now'),
                                isRegistered: w.isRegistered,
                                onTap: () {
                                  if (!w.isRegistered) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (ctx) => WorkshopRegistrationSheet(workshop: w),
                                    );
                                  }
                                },
                              ),
                          ],
                          if (connectState.schemes.isNotEmpty) ...[
                            for (final s in connectState.schemes.take(2))
                              _buildOpportunityCard(
                                context: context,
                                title: s.getLocalizedTitle(context),
                                badgeLabel: AppLocalizations.tr(context, 'tab_schemes').toUpperCase(),
                                badgeColor: const Color(0xFF1F5E45),
                                icon: Icons.account_balance_rounded,
                                subtitle: s.getLocalizedSubsidy(context),
                                details: s.getLocalizedDescription(context),
                                actionText: AppLocalizations.tr(context, 'view_details'),
                                onTap: () {
                                  ref.read(virasatConnectProvider.notifier).selectTab(ConnectTabMode.schemes);
                                  context.push('/virasat-connect');
                                },
                              ),
                          ],
                          if (connectState.ngos.isNotEmpty) ...[
                            for (final n in connectState.ngos.take(2))
                              _buildOpportunityCard(
                                context: context,
                                title: n.getLocalizedName(context),
                                badgeLabel: AppLocalizations.tr(context, 'tab_ngos').toUpperCase(),
                                badgeColor: const Color(0xFFE5A34B),
                                icon: Icons.handshake_rounded,
                                subtitle: n.getLocalizedFocusArea(context),
                                details: n.getLocalizedDescription(context),
                                actionText: AppLocalizations.tr(context, 'apply_grant'),
                                onTap: () {
                                  ref.read(virasatConnectProvider.notifier).selectTab(ConnectTabMode.ngos);
                                  context.push('/virasat-connect');
                                },
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                // GI Heritage Collection Section
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accent,
                            AppColors.primary,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33B55239),
                            blurRadius: 16,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.verified_rounded, color: Colors.amber, size: 24),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'GI HERITAGE COLLECTION',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Geographically Indicated Treasures',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Guaranteed authentic craftsmanship protected by legal origin tags.',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: giProducts.length,
                              itemBuilder: (context, idx) {
                                final giCraft = giProducts[idx];
                                return GestureDetector(
                                  onTap: () {
                                    context.push('/product-detail', extra: giCraft);
                                  },
                                  child: Container(
                                    width: 150,
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: Colors.white24),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: SafeProductImage(
                                              imagePath: giCraft.imageUrl.isNotEmpty
                                                  ? giCraft.imageUrl
                                                  : (giCraft.imageUrls.isNotEmpty ? giCraft.imageUrls.first : ''),
                                              productId: giCraft.id,
                                              fit: BoxFit.cover,
                                              placeholderText: giCraft.name,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          giCraft.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontFamily: 'Playfair Display',
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          '${giCraft.district}, ${giCraft.state}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '₹${giCraft.price.round()}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.amber,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0),
                  ),
                ),

                const SliverPadding(padding: EdgeInsets.only(top: 28)),

                // Artisan Spotlight Carousel
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: 'Master Artisan Spotlight',
                      subtitle: 'Preserving centuries of heritage techniques',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(top: 12, bottom: 28),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: artisans.length,
                        itemBuilder: (context, idx) {
                          final artisan = artisans[idx];
                          return _buildArtisanCard(context, artisan);
                        },
                      ),
                    ),
                  ),
                ),

                // Shop By State (Circular Cards)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      title: 'Shop by Indian State',
                      subtitle: 'Explore authentic crafts from 28 states',
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                  sliver: SliverToBoxAdapter(
                    child: SizedBox(
                      height: 155,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: states.length,
                        itemBuilder: (context, idx) {
                          final st = states[idx];
                          return _buildStateCircle(context, st, idx);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
          },
        ),
      ),
    );
  }

  Widget _buildHeroBannerCard(HomeBannerModel banner, int index) {
    final bannerImages = [
      'assets/images/crafts/patola_01.jpg',
      'assets/images/crafts/bandhani_01.jpg',
      'assets/images/crafts/blue_pottery_01.jpg',
    ];
    String bannerImage = bannerImages[index % bannerImages.length];
    final lowerTitle = banner.title.toLowerCase();
    if (lowerTitle.contains('patola')) {
      bannerImage = 'assets/images/crafts/patola_01.jpg';
    } else if (lowerTitle.contains('bandhani')) {
      bannerImage = 'assets/images/crafts/bandhani_01.jpg';
    } else if (lowerTitle.contains('pottery') || lowerTitle.contains('blue')) {
      bannerImage = 'assets/images/crafts/blue_pottery_01.jpg';
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33B55239),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                bannerImage,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.35),
                      Colors.black.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      AppLocalizations.tr(context, 'app_tagline').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    banner.getLocalizedTitle(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.getLocalizedSubtitle(context),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      context.push('/search');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(
                      banner.getLocalizedCta(context),
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        if (onViewAll != null) ...[
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              AppLocalizations.tr(context, 'prod_view_all'),
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCraftCard(BuildContext context, GiProductModel craft, {String? distanceTag}) {
    final isWishlisted = ref.watch(wishlistProvider.notifier).isWishlisted(craft.id);
    final imagePath = craft.imageUrl.isNotEmpty
        ? craft.imageUrl
        : (craft.imageUrls.isNotEmpty ? craft.imageUrls.first : '');

    return GestureDetector(
      onTap: () {
        context.push('/product-detail', extra: craft);
      },
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(right: 14),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'craft_img_${craft.id}_${distanceTag ?? ""}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SafeProductImage(
                          imagePath: imagePath,
                          productId: craft.id,
                          fit: BoxFit.cover,
                          placeholderText: craft.name,
                        ),
                      ),
                      if (craft.isGiTagged)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'GI TAGGED',
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (distanceTag != null)
                        Positioned(
                          bottom: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on, size: 10, color: Colors.amber),
                                const SizedBox(width: 2),
                                Text(
                                  distanceTag,
                                  style: const TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: IconButton(
                          icon: Icon(
                            isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: isWishlisted ? Colors.redAccent : Colors.white,
                            size: 18,
                          ),
                          onPressed: () {
                            ref.read(wishlistProvider.notifier).toggleWishlist(craft);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    craft.getLocalizedName(context),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    distanceTag ?? '📍 ${craft.district.isNotEmpty ? craft.district : craft.city} • ${getLocalizedStateName(context, craft.state)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          craft.price > 0 ? '₹${craft.price.round()}' : craft.priceRange,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                          const SizedBox(width: 2),
                          Text(
                            craft.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtisanCard(BuildContext context, ArtisanModel artisan) {
    final isDokra = artisan.id.contains('rameshwar') || artisan.name.contains('Rameshwar');
    final craftName = isDokra ? 'Dokra Brass Ganesha Idol' : 'Handcrafted Brass Temple Diya';
    final craftRating = artisan.rating.toStringAsFixed(1);

    return Container(
      width: 255,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: ClipOval(
                  child: SafeProductImage(
                    imagePath: artisan.profileImage,
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    placeholderText: artisan.name,
                  ),
                ),
              ),
              const SizedBox(width: 8),
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
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
                        const SizedBox(width: 2),
                        Text(
                          craftRating,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      artisan.village,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.brush_rounded, size: 12, color: AppColors.primary),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'Craft: $craftName',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            artisan.bio,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight, height: 1.3),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 30,
            child: OutlinedButton(
              onPressed: () {
                ArtisanProfileSheet.show(context, artisan);
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.zero,
              ),
              child: const Text(
                'Meet the Artisan',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpportunityCard({
    required BuildContext context,
    required String title,
    required String badgeLabel,
    required Color badgeColor,
    required IconData icon,
    required String subtitle,
    required String details,
    required String actionText,
    bool isRegistered = false,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 270,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(16),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 12, color: badgeColor),
                        const SizedBox(width: 4),
                        Text(
                          badgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                details,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: isRegistered ? Colors.green.shade700 : badgeColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 12),
              ),
              child: Text(
                actionText,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStateCircle(BuildContext context, StateModel state, int index) {
    debugPrint('[StateCarousel] ${state.name} (${state.id}) -> ${state.imagePath}');

    return StateCircleCard(
      number: (index + 1).toString().padLeft(2, '0'),
      stateName: state.name.isNotEmpty ? state.name : state.id,
      imagePath: state.imagePath,
      subtitle: state.craftSubtitle,
      onTap: () {
        context.push('/state-detail', extra: {'stateId': state.id});
      },
    );
  }
}
