import 'dart:math';

class NearbyArtisanModel {
  final String id;
  final String name;
  final String craftSpecialization;
  final String villageOrDistrict;
  final String state;
  final int experienceYears;
  final bool verified;
  final double rating;
  final String profileImage;
  final double latitude;
  final double longitude;
  final String address;
  final String phone;
  final String craftStory;
  final int productsCount;

  const NearbyArtisanModel({
    required this.id,
    required this.name,
    required this.craftSpecialization,
    required this.villageOrDistrict,
    required this.state,
    required this.experienceYears,
    this.verified = true,
    this.rating = 4.8,
    required this.profileImage,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.phone,
    required this.craftStory,
    this.productsCount = 12,
  });

  /// Calculates real-time distance in kilometers using the Haversine formula.
  double distanceKmFrom(double userLat, double userLng) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((latitude - userLat) * p) / 2 +
        cos(userLat * p) * cos(latitude * p) * (1 - cos((longitude - userLng) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * Earth radius (6371 km)
  }

  factory NearbyArtisanModel.fromJson(Map<String, dynamic> json) {
    return NearbyArtisanModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Master Artisan',
      craftSpecialization: json['craftSpecialization'] as String? ?? 'Handicrafts',
      villageOrDistrict: json['villageOrDistrict'] as String? ?? 'Vadodara',
      state: json['state'] as String? ?? 'Gujarat',
      experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 15,
      verified: json['verified'] as bool? ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      profileImage: json['profileImage'] as String? ?? 'assets/images/crafts/bandhani_01.jpg',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 22.3072,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 73.1812,
      address: json['address'] as String? ?? 'Vadodara, Gujarat',
      phone: json['phone'] as String? ?? '+91 98765 43210',
      craftStory: json['craftStory'] as String? ?? '',
      productsCount: (json['productsCount'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'craftSpecialization': craftSpecialization,
      'villageOrDistrict': villageOrDistrict,
      'state': state,
      'experienceYears': experienceYears,
      'verified': verified,
      'rating': rating,
      'profileImage': profileImage,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'craftStory': craftStory,
      'productsCount': productsCount,
    };
  }
}
