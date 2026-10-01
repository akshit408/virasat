import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';

class CategoryModel {
  final String id;
  final String name;
  final String iconName;
  final String themeColor;
  final String description;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.themeColor,
    required this.description,
  });

  String getLocalizedName(BuildContext context) {
    final key = 'cat_${name.toLowerCase().replaceAll(' ', '_').replaceAll('&', 'and')}';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : name;
  }

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'grid_view',
      themeColor: json['themeColor'] as String? ?? '#B55239',
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iconName': iconName,
      'themeColor': themeColor,
      'description': description,
    };
  }

  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconName,
    String? themeColor,
    String? description,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      themeColor: themeColor ?? this.themeColor,
      description: description ?? this.description,
    );
  }
}
