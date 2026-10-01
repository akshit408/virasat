import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NearbyCraftItem {
  final String id;
  final String name;
  final String district;
  final String state;
  final String artisanName;
  final double distanceKm;
  final double latitude;
  final double longitude;
  final String imageUrl;

  const NearbyCraftItem({
    required this.id,
    required this.name,
    required this.district,
    required this.state,
    required this.artisanName,
    required this.distanceKm,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
  });

  String get formattedLocationText => '${distanceKm.toStringAsFixed(1)} km • $district';
}

class LocationService {
  static const String _keyUserSelectedState = 'virasat_user_selected_state';
  static const double defaultUserLat = 23.0225; // Ahmedabad Center
  static const double defaultUserLng = 72.5714;

  /// Haversine formula to compute distance in km between two lat/lng points
  static double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        cos((lat2 - lat1) * p) / 2 +
        cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
  }

  /// Stores user selected state locally in SharedPreferences as fallback
  static Future<void> setSelectedState(String stateName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserSelectedState, stateName);
      debugPrint('[LocationService] Selected fallback state set to: $stateName');
    } catch (e) {
      debugPrint('[LocationService] Error saving selected state: $e');
    }
  }

  /// Gets stored user selected fallback state
  static Future<String> getSelectedState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyUserSelectedState) ?? 'Gujarat';
    } catch (e) {
      return 'Gujarat';
    }
  }
}
