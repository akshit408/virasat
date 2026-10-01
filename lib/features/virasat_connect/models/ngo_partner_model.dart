import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class NGOPartner {
  final String id;
  final String name;
  final String focusArea;
  final String location;
  final double latitude;
  final double longitude;
  final String contactPhone;
  final String email;
  final int activeProjectsCount;
  final int supportedArtisansCount;
  final String description;
  final String logoImage;

  const NGOPartner({
    required this.id,
    required this.name,
    required this.focusArea,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.contactPhone,
    required this.email,
    required this.activeProjectsCount,
    required this.supportedArtisansCount,
    required this.description,
    required this.logoImage,
  });

  String getLocalizedName(BuildContext context) {
    final key = '${id}_name';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : name;
  }

  String getLocalizedDescription(BuildContext context) {
    final key = '${id}_desc';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : description;
  }

  String getLocalizedFocusArea(BuildContext context) {
    final key = '${id}_focus';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : focusArea;
  }

  factory NGOPartner.fromJson(Map<String, dynamic> json) {
    return NGOPartner(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      focusArea: json['focusArea'] as String? ?? 'Artisan Welfare & Women SHGs',
      location: json['location'] as String? ?? 'Kutch, Gujarat',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 23.242,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 69.666,
      contactPhone: json['contactPhone'] as String? ?? '+91 98765 43210',
      email: json['email'] as String? ?? 'contact@ngo.org',
      activeProjectsCount: (json['activeProjectsCount'] as num?)?.toInt() ?? 5,
      supportedArtisansCount: (json['supportedArtisansCount'] as num?)?.toInt() ?? 450,
      description: json['description'] as String? ?? '',
      logoImage: json['logoImage'] as String? ?? 'assets/images/crafts/bandhani_01.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'focusArea': focusArea,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'contactPhone': contactPhone,
      'email': email,
      'activeProjectsCount': activeProjectsCount,
      'supportedArtisansCount': supportedArtisansCount,
      'description': description,
      'logoImage': logoImage,
    };
  }
}
