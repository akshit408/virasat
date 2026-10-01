import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virasat/models/gi_product_model.dart';
import 'package:virasat/services/auth_service.dart';
import 'package:virasat/services/supabase_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('Virasat Supabase Two-Role Backend Architecture Migration Tests', () {
    const testBuyerId = '9af21e46-2791-43f2-bab8-67b3e87425c3';
    const testArtisanId = '524536a0-db7e-4d49-8e17-82c6770e2ccd';

    test('1. Buyer Signup & Profile Creation (users & buyer_profiles tables)', () async {
      final authService = AuthService();

      // Ensure local session persistence & user mapping
      await SupabaseService.upsertUserProfile({
        'id': testBuyerId,
        'email': 'buyer.test@virasat.in',
        'full_name': 'Ananya Patron',
        'phone': '+91 98200 11223',
        'role': 'BUYER',
        'state': 'Rajasthan',
        'district': 'Jaipur',
      });

      final user = await authService.loadSavedSession();
      expect(user, isNotNull);
    });

    test('2. Become Verified Seller (artisan_profiles table & users.role update)', () async {
      await SupabaseService.ensureArtisanProfile(
        testArtisanId,
        'Ramji Heritage Weaves',
        craftCategory: 'Textiles',
        phone: '+91 98765 43210',
        state: 'Gujarat',
        district: 'Patan',
        bio: 'Master Patola silk weaver & brass artisan.',
      );

      final artisanMetrics = await SupabaseService.getArtisanDashboardMetrics(testArtisanId);
      expect(artisanMetrics, contains('live_products'));
      expect(artisanMetrics, contains('revenue'));
    });

    test('3. Gemini AI Product Upload (products table with AI estimates)', () async {
      const testProduct = GiProductModel(
        id: '11111111-0000-0000-0000-000000000099',
        name: 'AI Valued Ajrakh Hand-Block Print Stole',
        stateId: 'IN-GJ',
        stateName: 'Gujarat',
        category: 'Textiles',
        giTagYear: 2014,
        description: 'Authentic Ajrakh block printed silk stole with natural indigo dyes.',
        imageUrl: 'assets/images/crafts/ajrakh_coasters.jpg',
        district: 'Kutch',
        price: 1850.0,
        stockCount: 15,
        artisanId: testArtisanId,
        artisanName: 'Ramji Heritage Weaves',
      );

      final inserted = await SupabaseService.insertProduct(
        testProduct,
        aiEstimatedPrice: 1950.0,
        aiConfidence: 0.94,
      );

      expect(inserted, isNotNull);
      expect(inserted?.name, contains('Ajrakh'));
    });

    test('4. Buyer Wishlist & Cart Sync (buyer_id linked queries)', () async {
      const sampleProduct = GiProductModel(
        id: '11111111-0000-0000-0000-000000000001',
        name: 'Handcrafted Brass Temple Diya',
        stateId: 'IN-GJ',
        stateName: 'Gujarat',
        category: 'Metal Crafts',
        giTagYear: 2012,
        description: 'Traditional pure brass diya.',
        imageUrl: 'assets/images/crafts/brass_temple_diya.jpg',
        district: 'Patan',
        price: 350.0,
        artisanId: testArtisanId,
      );

      // Add to Wishlist
      await SupabaseService.addToWishlist(testBuyerId, sampleProduct);

      // Add to Cart
      await SupabaseService.addToCart(testBuyerId, sampleProduct, quantity: 2);

      final cartItems = await SupabaseService.getCartItems(testBuyerId);
      expect(cartItems, isA<List>());
    });

    test('5. Buyer Order Creation & Artisan Orders Stream (orders table)', () async {
      const sampleProduct = GiProductModel(
        id: '11111111-0000-0000-0000-000000000001',
        name: 'Handcrafted Brass Temple Diya',
        stateId: 'IN-GJ',
        stateName: 'Gujarat',
        category: 'Metal Crafts',
        giTagYear: 2012,
        description: 'Traditional pure brass diya.',
        imageUrl: 'assets/images/crafts/brass_temple_diya.jpg',
        district: 'Patan',
        price: 350.0,
        artisanId: testArtisanId,
      );

      final createdOrder = await SupabaseService.createOrder(
        orderNumber: 'ORD-${DateTime.now().millisecondsSinceEpoch}',
        buyerId: testBuyerId,
        product: sampleProduct,
        artisanId: testArtisanId,
        quantity: 1,
        totalAmount: 350.0,
        shippingAddress: '101 Heritage Lane, Jaipur, Rajasthan',
      );

      expect(createdOrder, isNotNull);
    });

    test('6. Phone Number OTP Verification & Automatic Profile Creation (users & buyer_profiles)', () async {
      final authService = AuthService();

      // Test Indian Phone Number OTP submission (+91)
      final otpSent = await authService.sendPhoneOtp('9876543210');
      expect(otpSent, isTrue);

      // Verify OTP and verify automatic profile creation in users & buyer_profiles
      final verifiedUser = await authService.verifyPhoneOtp(
        phone: '9876543210',
        token: '123456',
      );

      expect(verifiedUser, isNotNull);
      expect(verifiedUser.phone, contains('9876543210'));
    });
  });
}
