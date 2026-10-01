import 'package:flutter/material.dart';
import '../../../core/localization/app_localizations.dart';

class GovernmentScheme {
  final String id;
  final String title;
  final String ministry;
  final String category;
  final String subsidyAmount;
  final String eligibility;
  final String applicationDeadline;
  final String officialLink;
  final String description;
  final String state;

  const GovernmentScheme({
    required this.id,
    required this.title,
    required this.ministry,
    required this.category,
    required this.subsidyAmount,
    required this.eligibility,
    required this.applicationDeadline,
    required this.officialLink,
    required this.description,
    required this.state,
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

  String getLocalizedSubsidy(BuildContext context) {
    final key = '${id}_subsidy';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : subsidyAmount;
  }

  String getLocalizedEligibility(BuildContext context) {
    final key = '${id}_eligibility';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : eligibility;
  }

  factory GovernmentScheme.fromJson(Map<String, dynamic> json) {
    return GovernmentScheme(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      ministry: json['ministry'] as String? ?? 'Ministry of Textiles',
      category: json['category'] as String? ?? 'Financial Assistance',
      subsidyAmount: json['subsidyAmount'] as String? ?? '₹ 3,00,000 Loan + 50% Subsidy',
      eligibility: json['eligibility'] as String? ?? 'Registered GI Artisan Pehchan Card Holders',
      applicationDeadline: json['applicationDeadline'] as String? ?? 'Nov 30, 2026',
      officialLink: json['officialLink'] as String? ?? 'https://handicrafts.nic.in',
      description: json['description'] as String? ?? '',
      state: json['state'] as String? ?? 'All India',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'ministry': ministry,
      'category': category,
      'subsidyAmount': subsidyAmount,
      'eligibility': eligibility,
      'applicationDeadline': applicationDeadline,
      'officialLink': officialLink,
      'description': description,
      'state': state,
    };
  }
}
