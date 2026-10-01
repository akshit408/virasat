import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/nearby_artisan_model.dart';

enum MapViewMode { split, map, list }

class NearbyArtisanState {
  final double userLat;
  final double userLng;
  final String userLocationName;
  final double selectedRadiusKm; // 0.0 means all, 5.0, 10.0, 25.0
  final bool permissionGranted;
  final bool isDetectingLocation;
  final String? selectedArtisanId;
  final MapViewMode viewMode;
  final String searchQuery;
  final List<NearbyArtisanModel> allArtisans;

  const NearbyArtisanState({
    this.userLat = 22.3072, // Vadodara, Gujarat
    this.userLng = 73.1812,
    this.userLocationName = 'Alkapuri, Vadodara, Gujarat',
    this.selectedRadiusKm = 25.0, // Default 25km radius
    this.permissionGranted = false,
    this.isDetectingLocation = false,
    this.selectedArtisanId,
    this.viewMode = MapViewMode.split,
    this.searchQuery = '',
    this.allArtisans = mockVadodaraArtisans,
  });

  NearbyArtisanState copyWith({
    double? userLat,
    double? userLng,
    String? userLocationName,
    double? selectedRadiusKm,
    bool? permissionGranted,
    bool? isDetectingLocation,
    String? selectedArtisanId,
    MapViewMode? viewMode,
    String? searchQuery,
    List<NearbyArtisanModel>? allArtisans,
  }) {
    return NearbyArtisanState(
      userLat: userLat ?? this.userLat,
      userLng: userLng ?? this.userLng,
      userLocationName: userLocationName ?? this.userLocationName,
      selectedRadiusKm: selectedRadiusKm ?? this.selectedRadiusKm,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      isDetectingLocation: isDetectingLocation ?? this.isDetectingLocation,
      selectedArtisanId: selectedArtisanId ?? this.selectedArtisanId,
      viewMode: viewMode ?? this.viewMode,
      searchQuery: searchQuery ?? this.searchQuery,
      allArtisans: allArtisans ?? this.allArtisans,
    );
  }

  /// Filtered artisans within radius, sorted by distance ascending (nearest first)
  List<NearbyArtisanModel> get filteredAndSortedArtisans {
    return allArtisans.where((artisan) {
      final distance = artisan.distanceKmFrom(userLat, userLng);
      final matchesRadius = selectedRadiusKm <= 0 || distance <= selectedRadiusKm;
      final matchesSearch = searchQuery.isEmpty ||
          artisan.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          artisan.craftSpecialization.toLowerCase().contains(searchQuery.toLowerCase()) ||
          artisan.villageOrDistrict.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesRadius && matchesSearch;
    }).toList()
      ..sort((a, b) => a
          .distanceKmFrom(userLat, userLng)
          .compareTo(b.distanceKmFrom(userLat, userLng)));
  }
}

class NearbyArtisanNotifier extends StateNotifier<NearbyArtisanState> {
  NearbyArtisanNotifier() : super(const NearbyArtisanState());

  /// Request user location permission using permission_handler
  Future<void> requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted || status.isLimited) {
      state = state.copyWith(permissionGranted: true);
      await detectCurrentLocation();
    } else {
      state = state.copyWith(permissionGranted: false);
    }
  }

  /// Detect or refresh current GPS location (Vadodara Heritage Center)
  Future<void> detectCurrentLocation() async {
    state = state.copyWith(isDetectingLocation: true);
    await Future.delayed(const Duration(milliseconds: 600));

    // Simulated GPS coordinate around Vadodara Heritage Zone
    state = state.copyWith(
      userLat: 22.3072,
      userLng: 73.1812,
      userLocationName: 'Alkapuri, Vadodara, Gujarat',
      permissionGranted: true,
      isDetectingLocation: false,
    );
  }

  void setRadiusFilter(double radiusKm) {
    state = state.copyWith(selectedRadiusKm: radiusKm);
  }

  void selectArtisan(String? artisanId) {
    state = state.copyWith(selectedArtisanId: artisanId);
  }

  void setViewMode(MapViewMode mode) {
    state = state.copyWith(viewMode: mode);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final nearbyArtisanProvider =
    StateNotifierProvider<NearbyArtisanNotifier, NearbyArtisanState>((ref) {
  return NearbyArtisanNotifier();
});

/// Mock Artisans positioned around Vadodara, Gujarat
const List<NearbyArtisanModel> mockVadodaraArtisans = [
  NearbyArtisanModel(
    id: 'artisan_v1',
    name: 'Ramesh Vankar',
    craftSpecialization: 'Bandhani & Patola Weaving',
    villageOrDistrict: 'Alkapuri Cluster',
    state: 'Gujarat',
    experienceYears: 22,
    verified: true,
    rating: 4.9,
    profileImage: 'assets/images/crafts/bandhani_01.jpg',
    latitude: 22.3120,
    longitude: 73.1750,
    address: 'Plot 14, Alkapuri Artisan Enclave, Vadodara - 390007',
    phone: '+91 98250 12345',
    craftStory: 'Inherited the 200-year-old Kutchi & Bandhani tie-dye weave craft from master weavers.',
    productsCount: 24,
  ),
  NearbyArtisanModel(
    id: 'artisan_v2',
    name: 'Savitri Devi Prajapati',
    craftSpecialization: 'Terracotta & Clay Idol Sculpting',
    villageOrDistrict: 'Fatehgunj Colony',
    state: 'Gujarat',
    experienceYears: 18,
    verified: true,
    rating: 4.8,
    profileImage: 'assets/images/crafts/bankura_terracotta_01.jpg',
    latitude: 22.3210,
    longitude: 73.1900,
    address: 'Studio 4, Clay Artisans Hub, Fatehgunj, Vadodara - 390002',
    phone: '+91 97123 45678',
    craftStory: 'Specializes in eco-friendly Ganesha idols and heritage terracotta utility pottery.',
    productsCount: 18,
  ),
  NearbyArtisanModel(
    id: 'artisan_v3',
    name: 'Harishchandra Khatri',
    craftSpecialization: 'Ajrakh Natural Dye Block Printing',
    villageOrDistrict: 'Makarpura Estate',
    state: 'Gujarat',
    experienceYears: 30,
    verified: true,
    rating: 4.95,
    profileImage: 'assets/images/crafts/ajrakh_01.jpg',
    latitude: 22.2850,
    longitude: 73.2050,
    address: 'Block 8, GIDC Makarpura Textile Zone, Vadodara - 390010',
    phone: '+91 94260 98765',
    craftStory: '16-step natural indigo & madder root block printing master artisan.',
    productsCount: 32,
  ),
  NearbyArtisanModel(
    id: 'artisan_v4',
    name: 'Dineshbhai Chitara',
    craftSpecialization: 'Mata ni Pachedi Textile Painting',
    villageOrDistrict: 'Waghodia Road',
    state: 'Gujarat',
    experienceYears: 25,
    verified: true,
    rating: 4.85,
    profileImage: 'assets/images/crafts/pattachitra_01.jpg',
    latitude: 22.3020,
    longitude: 73.2350,
    address: 'Virasat Studio, Waghodia Road, Vadodara - 390019',
    phone: '+91 99090 11223',
    craftStory: 'Sacred temple cloth painter using natural bamboo pens and iron-oxide pigments.',
    productsCount: 15,
  ),
  NearbyArtisanModel(
    id: 'artisan_v5',
    name: 'Meena Kumari Soni',
    craftSpecialization: 'Silver Filigree & Brass Metalwork',
    villageOrDistrict: 'Akota Craft Hub',
    state: 'Gujarat',
    experienceYears: 16,
    verified: true,
    rating: 4.75,
    profileImage: 'assets/images/crafts/silver_filigree_01.jpg',
    latitude: 22.2500,
    longitude: 73.1600,
    address: 'Opp. Akota Stadium, Vadodara - 390020',
    phone: '+91 98980 55443',
    craftStory: 'Intricate 925 sterling silver wire filigree jewelry and brass heritage artefacts.',
    productsCount: 20,
  ),
  NearbyArtisanModel(
    id: 'artisan_v6',
    name: 'Kavita Ben Sankheda',
    craftSpecialization: 'Sankheda Lacquered Wooden Furniture',
    villageOrDistrict: 'Sankheda GI Cluster',
    state: 'Gujarat',
    experienceYears: 28,
    verified: true,
    rating: 4.9,
    profileImage: 'assets/images/crafts/bamboo_basket_01.jpg',
    latitude: 22.1550,
    longitude: 73.5850,
    address: 'Main Bazaar, Sankheda GI Craft Village, Vadodara District - 391145',
    phone: '+91 94270 33445',
    craftStory: 'Hand-turned teakwood lacquered chairs and swings with authentic GI Tag verification.',
    productsCount: 29,
  ),
];
