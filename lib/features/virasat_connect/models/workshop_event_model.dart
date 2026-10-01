import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class WorkshopEvent {
  final String id;
  final String title;
  final String craftCategory;
  final String organizerName;
  final String location;
  final double latitude;
  final double longitude;
  final String startDate;
  final String endDate;
  final String registrationDeadline;
  final double fee;
  final int availableSeats;
  final int totalSeats;
  final bool isRegistered;
  final String description;
  final String bannerImage;
  final String trainer;
  final String duration;

  const WorkshopEvent({
    required this.id,
    required this.title,
    required this.craftCategory,
    required this.organizerName,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    required this.fee,
    required this.availableSeats,
    required this.totalSeats,
    this.isRegistered = false,
    required this.description,
    required this.bannerImage,
    this.trainer = 'Master Artisan Trainer',
    this.duration = '4 Days (Hands-on)',
  });

  String getLocalizedTitle(BuildContext context) {
    final key = '${id}_title';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : title;
  }

  String getLocalizedDescription(BuildContext context) {
    final key = '${id}_desc';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : description;
  }

  factory WorkshopEvent.fromJson(Map<String, dynamic> json) {
    return WorkshopEvent(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      craftCategory: json['craftCategory'] as String? ?? 'Handicrafts',
      organizerName: json['organizerName'] as String? ?? 'Ministry of Textiles',
      location: json['location'] as String? ?? 'Kutch, Gujarat',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 23.242,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 69.666,
      startDate: json['startDate'] as String? ?? 'Oct 15, 2026',
      endDate: json['endDate'] as String? ?? 'Oct 18, 2026',
      registrationDeadline: json['registrationDeadline'] as String? ?? 'Oct 10, 2026',
      fee: (json['fee'] as num?)?.toDouble() ?? 0.0,
      availableSeats: (json['availableSeats'] as num?)?.toInt() ?? 20,
      totalSeats: (json['totalSeats'] as num?)?.toInt() ?? 30,
      isRegistered: json['isRegistered'] as bool? ?? false,
      description: json['description'] as String? ?? '',
      bannerImage: json['bannerImage'] as String? ?? 'assets/images/crafts/bandhani_01.jpg',
      trainer: json['trainer'] as String? ?? json['organizerName'] as String? ?? 'Master Craftsman',
      duration: json['duration'] as String? ?? '4 Days (Hands-on)',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'craftCategory': craftCategory,
      'organizerName': organizerName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'startDate': startDate,
      'endDate': endDate,
      'registrationDeadline': registrationDeadline,
      'fee': fee,
      'availableSeats': availableSeats,
      'totalSeats': totalSeats,
      'isRegistered': isRegistered,
      'description': description,
      'bannerImage': bannerImage,
      'trainer': trainer,
      'duration': duration,
    };
  }

  WorkshopEvent copyWith({
    String? id,
    String? title,
    String? craftCategory,
    String? organizerName,
    String? location,
    double? latitude,
    double? longitude,
    String? startDate,
    String? endDate,
    String? registrationDeadline,
    double? fee,
    int? availableSeats,
    int? totalSeats,
    bool? isRegistered,
    String? description,
    String? bannerImage,
    String? trainer,
    String? duration,
  }) {
    return WorkshopEvent(
      id: id ?? this.id,
      title: title ?? this.title,
      craftCategory: craftCategory ?? this.craftCategory,
      organizerName: organizerName ?? this.organizerName,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      registrationDeadline: registrationDeadline ?? this.registrationDeadline,
      fee: fee ?? this.fee,
      availableSeats: availableSeats ?? this.availableSeats,
      totalSeats: totalSeats ?? this.totalSeats,
      isRegistered: isRegistered ?? this.isRegistered,
      description: description ?? this.description,
      bannerImage: bannerImage ?? this.bannerImage,
      trainer: trainer ?? this.trainer,
      duration: duration ?? this.duration,
    );
  }
}
