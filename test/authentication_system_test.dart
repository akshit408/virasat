import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virasat/models/user_model.dart';
import 'package:virasat/services/auth_service.dart';
import 'package:virasat/providers/auth_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('VIRASAT Authentication System Tests', () {
    test('UserModel getters, isGuest, and isAuthenticated work correctly', () {
      const guest = UserModel(
        id: 'guest_1',
        name: 'Guest User',
        phone: '',
        email: '',
        role: UserRole.buyer,
        isGuest: true,
      );

      expect(guest.isGuest, isTrue);
      expect(guest.isAuthenticated, isFalse);

      const buyer = UserModel(
        id: 'usr_101',
        name: 'Ananya Sharma',
        phone: '+91 9820011223',
        email: 'ananya@virasat.in',
        role: UserRole.buyer,
        isGuest: false,
      );

      expect(buyer.isGuest, isFalse);
      expect(buyer.isAuthenticated, isTrue);
      expect(buyer.isBuyer, isTrue);

      const artisan = UserModel(
        id: 'usr_102',
        name: 'Ramesh Vankar',
        phone: '+91 9825012345',
        email: 'ramesh@virasat.in',
        role: UserRole.artisan,
        isVerifiedArtisan: true,
      );

      expect(artisan.isSeller, isTrue);
    });

    test('AuthService login persists session to SharedPreferences', () async {
      final service = AuthService();
      final user = await service.login(
        emailOrPhone: 'patron@virasat.in',
        password: 'password123',
      );

      expect(user.isAuthenticated, isTrue);
      expect(user.email, equals('patron@virasat.in'));

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('virasat_user_json'), isTrue);
      expect(prefs.getBool('virasat_is_guest'), isFalse);
    });

    test('AuthService Google Sign-In authenticates user successfully', () async {
      final service = AuthService();
      final user = await service.signInWithGoogle();

      expect(user.isAuthenticated, isTrue);
      expect(user.email, contains('@gmail.com'));
    });

    test('AuthService registerUser creates and persists new account', () async {
      final service = AuthService();
      final user = await service.registerUser(
        name: 'Savitri Devi',
        email: 'savitri@virasat.in',
        password: 'password123',
        role: UserRole.artisan,
        phone: '+91 9876543210',
        state: 'Rajasthan',
        district: 'Jaipur',
        craftCategory: 'Textiles',
      );

      expect(user.name, equals('Savitri Devi'));
      expect(user.role, equals(UserRole.artisan));
      expect(user.isVerifiedArtisan, isTrue);
    });

    test('AuthService continueAsGuest enables guest mode', () async {
      final service = AuthService();
      final user = await service.continueAsGuest();

      expect(user.isGuest, isTrue);
      expect(user.isAuthenticated, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('virasat_is_guest'), isTrue);
    });

    test('AuthService logout clears session storage', () async {
      final service = AuthService();
      await service.login(emailOrPhone: 'test@virasat.in', password: 'password123');
      expect(service.isAuthenticated, isTrue);

      await service.logout();
      expect(service.isAuthenticated, isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey('virasat_user_json'), isFalse);
    });

    test('AuthNotifier manages AuthState seamlessly', () async {
      final service = AuthService();
      final notifier = AuthNotifier(service);

      await notifier.login('artisan.master@virasat.in', 'password123');
      expect(notifier.state.isAuthenticated, isTrue);
      expect(notifier.state.user.role, equals(UserRole.artisan));

      await notifier.logout();
      expect(notifier.state.isAuthenticated, isFalse);
    });
  });
}
