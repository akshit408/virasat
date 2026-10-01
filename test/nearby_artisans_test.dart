import 'package:flutter_test/flutter_test.dart';
import 'package:virasat/features/artisan/models/nearby_artisan_model.dart';
import 'package:virasat/features/artisan/providers/nearby_artisan_provider.dart';

void main() {
  group('Nearby Artisans Feature Unit Tests', () {
    const userLat = 22.3072; // Vadodara Center
    const userLng = 73.1812;

    test('Haversine distance formula calculates correct distance in km', () {
      const artisanNear = NearbyArtisanModel(
        id: '1',
        name: 'Ramesh Vankar',
        craftSpecialization: 'Bandhani',
        villageOrDistrict: 'Alkapuri',
        state: 'Gujarat',
        experienceYears: 20,
        profileImage: 'assets/images/crafts/bandhani_01.jpg',
        latitude: 22.3120,
        longitude: 73.1750,
        address: 'Alkapuri, Vadodara',
        phone: '+91 9000000000',
        craftStory: 'Bandhani Master',
      );

      final distance = artisanNear.distanceKmFrom(userLat, userLng);
      expect(distance, greaterThan(0.5));
      expect(distance, lessThan(1.5));
    });

    test('Radius filter 5km filters artisans correctly', () {
      final notifier = NearbyArtisanNotifier();
      notifier.setRadiusFilter(5.0);

      final filtered = notifier.state.filteredAndSortedArtisans;
      for (final artisan in filtered) {
        expect(artisan.distanceKmFrom(userLat, userLng), lessThanOrEqualTo(5.0));
      }
      expect(filtered.length, equals(3)); // 0.8km, 1.8km, 3.4km
    });

    test('Radius filter 10km includes artisans up to 10km', () {
      final notifier = NearbyArtisanNotifier();
      notifier.setRadiusFilter(10.0);

      final filtered = notifier.state.filteredAndSortedArtisans;
      for (final artisan in filtered) {
        expect(artisan.distanceKmFrom(userLat, userLng), lessThanOrEqualTo(10.0));
      }
      expect(filtered.length, equals(5));
    });

    test('Artisan list is strictly sorted by distance ascending', () {
      final notifier = NearbyArtisanNotifier();
      notifier.setRadiusFilter(25.0);

      final list = notifier.state.filteredAndSortedArtisans;
      for (int i = 0; i < list.length - 1; i++) {
        final d1 = list[i].distanceKmFrom(userLat, userLng);
        final d2 = list[i + 1].distanceKmFrom(userLat, userLng);
        expect(d1, lessThanOrEqualTo(d2));
      }
    });
  });
}
