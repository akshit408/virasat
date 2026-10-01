import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';

class CraftModel {
  final String id;
  final String name;
  final String state;
  final String stateId;
  final String category;
  final String categoryId;
  final String city;
  final String priceRange;
  final String materials;
  final String rawMaterials;
  final String storyId;
  final int popularityScore;
  final String shortDescription;
  final String history;
  final String technique;
  final String imageUrl;
  final bool isGiTagged;
  final int artisanCount;
  final List<String> popularProducts;

  bool get giTagged => isGiTagged;

  const CraftModel({
    required this.id,
    required this.name,
    required this.state,
    this.stateId = '',
    required this.category,
    this.categoryId = '',
    this.city = '',
    this.priceRange = '₹ 2,500',
    this.materials = '',
    this.storyId = '',
    this.popularityScore = 85,
    required this.shortDescription,
    this.history = '',
    this.rawMaterials = '',
    this.technique = '',
    this.imageUrl = '',
    this.isGiTagged = false,
    this.artisanCount = 0,
    this.popularProducts = const [],
  });

  String getLocalizedName(BuildContext context) {
    final key = 'craft_${id}_name';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : name;
  }

  String getLocalizedCategory(BuildContext context) {
    final key = 'cat_${category.toLowerCase().replaceAll(' ', '_')}';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : category;
  }

  String getLocalizedDescription(BuildContext context) {
    final key = 'craft_${id}_desc';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : shortDescription;
  }

  String getLocalizedMaterials(BuildContext context) {
    final key = 'craft_${id}_mat';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : materials;
  }

  factory CraftModel.fromJson(Map<String, dynamic> json) {
    final isGi = json['isGiTagged'] as bool? ?? json['giTagged'] as bool? ?? false;
    final catId = json['categoryId'] as String? ?? json['category'] as String? ?? '';
    final matList = json['materials'];
    final mat = matList is List ? matList.join(', ') : (json['materials'] as String? ?? json['rawMaterials'] as String? ?? '');

    return CraftModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? json['craftName'] as String? ?? '',
      state: json['state'] as String? ?? '',
      stateId: json['stateId'] as String? ?? json['state'] as String? ?? '',
      category: json['category'] as String? ?? catId,
      categoryId: catId,
      city: json['city'] as String? ?? json['district'] as String? ?? '',
      priceRange: json['priceRange'] as String? ?? '₹ 2,500',
      materials: mat,
      rawMaterials: mat,
      storyId: json['storyId'] as String? ?? '',
      popularityScore: (json['popularityScore'] as num?)?.toInt() ?? 85,
      shortDescription: json['shortDescription'] as String? ?? json['history'] as String? ?? '',
      history: json['history'] as String? ?? '',
      technique: json['technique'] as String? ?? (json['techniques'] is List ? (json['techniques'] as List).join(', ') : ''),
      imageUrl: json['imageUrl'] as String? ?? json['heroImage'] as String? ?? json['imagePath'] as String? ?? '',
      isGiTagged: isGi,
      artisanCount: (json['artisanCount'] as num?)?.toInt() ?? 0,
      popularProducts: (json['popularProducts'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'state': state,
      'stateId': stateId,
      'category': category,
      'categoryId': categoryId,
      'city': city,
      'priceRange': priceRange,
      'materials': materials,
      'storyId': storyId,
      'popularityScore': popularityScore,
      'shortDescription': shortDescription,
      'history': history,
      'rawMaterials': rawMaterials,
      'technique': technique,
      'imageUrl': imageUrl,
      'isGiTagged': isGiTagged,
      'giTagged': isGiTagged,
      'artisanCount': artisanCount,
      'popularProducts': popularProducts,
    };
  }

  CraftModel copyWith({
    String? id,
    String? name,
    String? state,
    String? stateId,
    String? category,
    String? categoryId,
    String? city,
    String? priceRange,
    String? materials,
    String? storyId,
    int? popularityScore,
    String? shortDescription,
    String? history,
    String? rawMaterials,
    String? technique,
    String? imageUrl,
    bool? isGiTagged,
    int? artisanCount,
    List<String>? popularProducts,
  }) {
    return CraftModel(
      id: id ?? this.id,
      name: name ?? this.name,
      state: state ?? this.state,
      stateId: stateId ?? this.stateId,
      category: category ?? this.category,
      categoryId: categoryId ?? this.categoryId,
      city: city ?? this.city,
      priceRange: priceRange ?? this.priceRange,
      materials: materials ?? this.materials,
      storyId: storyId ?? this.storyId,
      popularityScore: popularityScore ?? this.popularityScore,
      shortDescription: shortDescription ?? this.shortDescription,
      history: history ?? this.history,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      technique: technique ?? this.technique,
      imageUrl: imageUrl ?? this.imageUrl,
      isGiTagged: isGiTagged ?? this.isGiTagged,
      artisanCount: artisanCount ?? this.artisanCount,
      popularProducts: popularProducts ?? this.popularProducts,
    );
  }
}

