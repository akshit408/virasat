import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/main/main_shell_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/discover/discover_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/edit_profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/marketplace/category_listing_screen.dart';
import '../screens/bharat/state_detail_screen.dart';
import '../screens/bharat/festival_collections_screen.dart';
import '../screens/cart/cart_screen.dart';
import '../screens/cart/checkout_screen.dart';
import '../screens/connect/connect_screen.dart';
import '../screens/impact/impact_dashboard_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../screens/orders/orders_screen.dart';
import '../screens/orders/order_detail_screen.dart';
import '../providers/artisan_hub_provider.dart';
import '../screens/auth/user_role_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/language/language_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/artisan/artisan_dashboard_screen.dart';
import '../screens/artisan/sell_my_craft_screen.dart';
import '../screens/artisan/manage_products_screen.dart';
import '../screens/artisan/artisan_orders_screen.dart';
import '../screens/artisan/artisan_analytics_screen.dart';
import '../screens/profile/artisan_profile_screen.dart';
import '../screens/artisan/seller_verification_screen.dart';
import '../screens/artisan/collectives_screen.dart';
import '../screens/ai_studio/ai_assistants_screen.dart';
import '../features/ai_scanner/screens/ai_scanner_home_screen.dart';
import '../features/ai_scanner/screens/ai_photo_upload_screen.dart';
import '../features/ai_scanner/screens/ai_scanning_animation_screen.dart';
import '../features/ai_scanner/screens/ai_analysis_result_screen.dart';
import '../features/ai_scanner/screens/ai_smart_pricing_screen.dart';
import '../features/ai_scanner/screens/ai_heritage_story_screen.dart';
import '../features/ai_scanner/screens/ai_multilingual_screen.dart';
import '../features/ai_scanner/screens/ai_image_enhancement_screen.dart';
import '../features/ai_scanner/screens/ai_product_preview_screen.dart';
import '../features/ai_scanner/screens/ai_publish_success_screen.dart';
import '../features/ai_scanner/screens/ai_voice_listing_screen.dart';
import '../features/artisan/screens/nearby_artisans_screen.dart';
import '../features/chat/models/chat_message_model.dart';
import '../features/chat/screens/artisan_chat_screen.dart';
import '../models/gi_product_model.dart';
import '../features/b2b/models/rfq_model.dart';
import '../features/b2b/screens/b2b_marketplace_screen.dart';
import '../features/b2b/screens/b2b_quotation_screen.dart';
import '../features/gem/screens/gem_procurement_screen.dart';
import '../features/export/screens/export_catalog_screen.dart';
import '../screens/certificate/gi_certificate_screen.dart';


final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    // Splash Route
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),

    // Onboarding Route
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),

    // Role Selection / Journey Choice Route
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const UserRoleScreen(),
    ),

    // Authentication Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/language',
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) => const EditProfileScreen(),
    ),

    // Artisan Hub & Seller Routes
    GoRoute(
      path: '/artisan-dashboard',
      builder: (context, state) => const ArtisanDashboardScreen(),
    ),
    GoRoute(
      path: '/sell-my-craft',
      builder: (context, state) => const SellMyCraftScreen(),
    ),
    GoRoute(
      path: '/artisan-products',
      builder: (context, state) => const ManageProductsScreen(),
    ),
    GoRoute(
      path: '/artisan-orders',
      builder: (context, state) => const ArtisanOrdersScreen(),
    ),
    GoRoute(
      path: '/artisan-earnings',
      builder: (context, state) => const ArtisanAnalyticsScreen(),
    ),
    GoRoute(
      path: '/artisan-profile',
      builder: (context, state) => const ArtisanProfileScreen(),
    ),
    GoRoute(
      path: '/nearby-artisans',
      builder: (context, state) => const NearbyArtisansScreen(),
    ),
    GoRoute(
      path: '/virasat-connect',
      builder: (context, state) => const NearbyArtisansScreen(),
    ),
    GoRoute(
      path: '/artisan-chat',
      builder: (context, state) {
        final extraMap = state.extra;
        ArtisanChatArgs args;
        if (extraMap is ArtisanChatArgs) {
          args = extraMap;
        } else if (extraMap is Map<String, dynamic>) {
          args = ArtisanChatArgs.fromMap(extraMap);
        } else {
          args = const ArtisanChatArgs(
            artisanId: 'artisan_v1',
            name: 'Verified Master Artisan',
            avatar: '',
            craft: 'Bandhani Tie-Dye & Patola Weaving',
            location: 'Jamnagar, Gujarat',
          );
        }
        return ArtisanChatScreen(args: args);
      },
    ),
    GoRoute(
      path: '/collectives',
      builder: (context, state) => const CollectivesScreen(),
    ),
    GoRoute(
      path: '/seller-verification',
      builder: (context, state) => const SellerVerificationScreen(),
    ),
    GoRoute(
      path: '/ai-assistants',
      builder: (context, state) => const AiAssistantsScreen(),
    ),

    // AI Product Scanner & Seller AI Routes
    GoRoute(
      path: '/ai-scanner',
      builder: (context, state) => const AiScannerHomeScreen(),
    ),
    GoRoute(
      path: '/ai-photo-upload',
      builder: (context, state) => const AiPhotoUploadScreen(),
    ),
    GoRoute(
      path: '/ai-scanning-animation',
      builder: (context, state) => const AiScanningAnimationScreen(),
    ),
    GoRoute(
      path: '/ai-analysis-result',
      builder: (context, state) => const AiAnalysisResultScreen(),
    ),
    GoRoute(
      path: '/ai-smart-pricing',
      builder: (context, state) => const AiSmartPricingScreen(),
    ),
    GoRoute(
      path: '/ai-heritage-story',
      builder: (context, state) => const AiHeritageStoryScreen(),
    ),
    GoRoute(
      path: '/ai-multilingual',
      builder: (context, state) => const AiMultilingualScreen(),
    ),
    GoRoute(
      path: '/ai-image-enhancement',
      builder: (context, state) => const AIImageEnhancementScreen(),
    ),
    GoRoute(
      path: '/ai-product-preview',
      builder: (context, state) => const AIProductPreviewScreen(),
    ),
    GoRoute(
      path: '/ai-publish-success',
      builder: (context, state) => const AIPublishSuccessScreen(),
    ),
    GoRoute(
      path: '/ai-voice-listing',
      builder: (context, state) => const AIVoiceListingScreen(),
    ),

    // B2B, Government Procurement & Export Routes
    GoRoute(
      path: '/b2b-marketplace',
      builder: (context, state) => const B2bMarketplaceScreen(),
    ),
    GoRoute(
      path: '/b2b-quotation',
      builder: (context, state) {
        final rfq = state.extra as B2bRFQ?;
        return B2bQuotationScreen(rfq: rfq);
      },
    ),
    GoRoute(
      path: '/gem-procurement',
      builder: (context, state) => const GemProcurementScreen(),
    ),
    GoRoute(
      path: '/export-catalog',
      builder: (context, state) => const ExportCatalogScreen(),
    ),

    // Marketplace Top-Level Routes
    GoRoute(
      path: '/search',
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/wishlist',
      builder: (context, state) => const WishlistScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => const OrdersScreen(),
    ),
    GoRoute(
      path: '/order-detail',
      builder: (context, state) {
        final order = state.extra as ArtisanOrder?;
        return OrderDetailScreen(order: order);
      },
    ),
    GoRoute(
      path: '/product-detail',
      builder: (context, state) {
        final product = state.extra as GiProductModel?;
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Craft product not found')),
          );
        }
        return ProductDetailScreen(craft: product);
      },
    ),
    GoRoute(
      path: '/gi-certificate',
      builder: (context, state) {
        final product = state.extra as GiProductModel?;
        if (product == null) {
          return const Scaffold(
            body: Center(child: Text('Product not found')),
          );
        }
        return GiCertificateScreen(craft: product);
      },
    ),
    GoRoute(
      path: '/impact',
      builder: (context, state) => const ImpactDashboardScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/category-listing',
      builder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>? ?? {};
        final title = extraMap['title'] as String? ?? 'Heritage Crafts';
        final categoryId = extraMap['categoryId'] as String?;
        final stateId = extraMap['stateId'] as String?;

        return CategoryListingScreen(
          title: title,
          categoryId: categoryId,
          stateId: stateId,
        );
      },
    ),
    GoRoute(
      path: '/state-detail',
      builder: (context, state) {
        final extraMap = state.extra as Map<String, dynamic>?;
        final stateId = extraMap?['stateId'] as String? ?? 'IN-GJ';
        return StateDetailScreen(stateId: stateId);
      },
    ),
    GoRoute(
      path: '/bharat/festivals',
      builder: (context, state) {
        final slug = state.uri.queryParameters['slug'] ?? 'diwali';
        return FestivalCollectionsScreen(slug: slug);
      },
    ),
    GoRoute(
      path: '/collection/:slug',
      builder: (context, state) {
        final slug = state.pathParameters['slug'] ?? 'diwali';
        return FestivalCollectionsScreen(slug: slug);
      },
    ),

    // Legacy / Alias Route Redirects
    GoRoute(
      path: '/bharat',
      redirect: (context, state) => '/discover',
    ),
    GoRoute(
      path: '/ai-studio',
      redirect: (context, state) => '/connect',
    ),
    GoRoute(
      path: '/studio',
      redirect: (context, state) => '/connect',
    ),

    // Persistent Bottom Navigation Shell Route (4 Tabs)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),

        // Tab 1: Discover
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (context, state) => const DiscoverScreen(),
            ),
          ],
        ),

        // Tab 2: Connect
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/connect',
              builder: (context, state) => const ConnectScreen(),
            ),
          ],
        ),

        // Tab 3: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

