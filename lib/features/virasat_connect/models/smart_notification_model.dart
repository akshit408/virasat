import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

enum NotificationType {
  workshop,
  scheme,
  giCamp,
  exhibition,
}

class SmartNotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final String targetId;
  final DateTime timestamp;
  final bool isRead;
  final String location;
  final String craftCategory;

  const SmartNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.targetId,
    required this.timestamp,
    this.isRead = false,
    required this.location,
    required this.craftCategory,
  });

  String getLocalizedTitle(BuildContext context) {
    final key = '${id}_title';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : title;
  }

  String getLocalizedBody(BuildContext context) {
    final key = '${id}_body';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : body;
  }

  SmartNotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    String? targetId,
    DateTime? timestamp,
    bool? isRead,
    String? location,
    String? craftCategory,
  }) {
    return SmartNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetId: targetId ?? this.targetId,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      location: location ?? this.location,
      craftCategory: craftCategory ?? this.craftCategory,
    );
  }
}
