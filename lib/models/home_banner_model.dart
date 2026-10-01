import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';

class HomeBannerModel {
  final String title;
  final String subtitle;
  final String ctaText;
  final String imagePath;

  const HomeBannerModel({
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.imagePath,
  });

  String getLocalizedTitle(BuildContext context) {
    final key = 'banner_${title.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : title;
  }

  String getLocalizedSubtitle(BuildContext context) {
    final key = 'banner_${title.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}_sub';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : subtitle;
  }

  String getLocalizedCta(BuildContext context) {
    final key = 'banner_${title.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}_cta';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : ctaText;
  }

  factory HomeBannerModel.fromJson(Map<String, dynamic> json) {
    return HomeBannerModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      ctaText: json['ctaText'] as String? ?? 'Explore Now',
      imagePath: json['imagePath'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'ctaText': ctaText,
      'imagePath': imagePath,
    };
  }

  HomeBannerModel copyWith({
    String? title,
    String? subtitle,
    String? ctaText,
    String? imagePath,
  }) {
    return HomeBannerModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      ctaText: ctaText ?? this.ctaText,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}
