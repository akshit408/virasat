import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class TrainingCentre {
  final String id;
  final String name;
  final String craftSpecialization;
  final String address;
  final double latitude;
  final double longitude;
  final int coursesCount;
  final String phone;
  final double rating;
  final String certificationOffered;
  final String image;

  const TrainingCentre({
    required this.id,
    required this.name,
    required this.craftSpecialization,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.coursesCount,
    required this.phone,
    required this.rating,
    required this.certificationOffered,
    required this.image,
  });

  String getLocalizedName(BuildContext context) {
    final key = '${id}_name';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : name;
  }

  String getLocalizedSpecialization(BuildContext context) {
    final key = '${id}_spec';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : craftSpecialization;
  }

  String getLocalizedAddress(BuildContext context) {
    final key = '${id}_address';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : address;
  }

  String getLocalizedCertification(BuildContext context) {
    final key = '${id}_cert';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : certificationOffered;
  }

  factory TrainingCentre.fromJson(Map<String, dynamic> json) {
    return TrainingCentre(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      craftSpecialization: json['craftSpecialization'] as String? ?? 'Handicrafts & Textile Weaving',
      address: json['address'] as String? ?? 'Craft Village Hub',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 23.242,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 69.666,
      coursesCount: (json['coursesCount'] as num?)?.toInt() ?? 6,
      phone: json['phone'] as String? ?? '+91 98765 00000',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      certificationOffered: json['certificationOffered'] as String? ?? 'National Craft Certification',
      image: json['image'] as String? ?? 'assets/images/crafts/bandhani_01.jpg',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'craftSpecialization': craftSpecialization,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'coursesCount': coursesCount,
      'phone': phone,
      'rating': rating,
      'certificationOffered': certificationOffered,
      'image': image,
    };
  }
}
