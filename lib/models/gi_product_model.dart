import 'package:flutter/material.dart';
import '../core/localization/app_localizations.dart';
import '../core/utils/craft_image_helper.dart';

class GiProductModel {
  final String id;
  final String name;
  final String stateId;
  final String stateName;
  final String category;
  final int giTagYear;
  final String description;
  final String imageUrl;
  final int certifiedArtisanCount;
  final String district;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final double rating;
  final String artisanId;
  final String artisanName;
  final String artisanAvatar;
  final String craftStory;
  final bool isWomenArtisan;
  final bool isEcoFriendly;
  final int reviewCount;
  final String materials;
  final String dimensions;
  final String weight;
  final int stockCount;
  final int moq;
  final double wholesalePrice;
  final int buyersCount;
  final String hsnCode;
  final bool exportReady;
  final String pattern;
  final String careInstructions;
  final double artisanPrice;
  final double platformFee;
  final double shippingCost;
  final bool giCertificateIncluded;
  final String sellerName;
  final String sellerVillage;
  final String cooperativeName;

  const GiProductModel({
    required this.id,
    required this.name,
    required this.stateId,
    required this.stateName,
    required this.category,
    required this.giTagYear,
    required this.description,
    required this.imageUrl,
    this.certifiedArtisanCount = 0,
    this.district = '',
    this.price = 0,
    this.originalPrice,
    this.imageUrls = const [],
    this.rating = 4.8,
    this.artisanId = '',
    this.artisanName = 'Verified Master Artisan',
    this.artisanAvatar = '',
    this.craftStory = '',
    this.isWomenArtisan = false,
    this.isEcoFriendly = true,
    this.reviewCount = 24,
    this.materials = 'Natural & Handcrafted Materials',
    this.dimensions = 'Standard Size',
    this.weight = '500g',
    this.stockCount = 10,
    this.moq = 10,
    this.wholesalePrice = 0,
    this.buyersCount = 142,
    this.hsnCode = '6302.91',
    this.exportReady = true,
    this.pattern = 'Traditional Geometric / Heritage Motifs',
    this.careInstructions = 'Dry clean or gentle hand wash with mild natural soap; dry in shade.',
    this.artisanPrice = 0,
    this.platformFee = 0,
    this.shippingCost = 0,
    this.giCertificateIncluded = true,
    this.sellerName = 'Artisan Heritage SHG',
    this.sellerVillage = 'Heritage Village',
    this.cooperativeName = 'State Handloom Cooperative Federation',
  });

  String getLocalizedName(BuildContext context) {
    final key = 'prod_${id}_name';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : name;
  }

  String getLocalizedTitle(BuildContext context) => getLocalizedName(context);

  String getLocalizedCategory(BuildContext context) {
    final key = 'cat_${category.toLowerCase().replaceAll(' ', '_')}';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : category;
  }

  String getLocalizedDescription(BuildContext context) {
    final key = 'prod_${id}_desc';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : description;
  }

  String getLocalizedMaterials(BuildContext context) {
    final key = 'prod_${id}_mat';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : materials;
  }

  String getLocalizedCraftStory(BuildContext context) {
    final key = 'prod_${id}_story';
    final localized = AppLocalizations.tr(context, key);
    return localized != key ? localized : craftStory;
  }

  bool get isGiTagged => giTagYear > 0;
  bool get giTagged => isGiTagged;
  String get categoryId => category;
  int get artisanCount => certifiedArtisanCount;
  String get city => district.isNotEmpty ? district : stateName;
  double get directArtisanEarning => artisanPrice > 0 ? artisanPrice : (price * 0.85).roundToDouble();
  double get computedPlatformFee => platformFee > 0 ? platformFee : (price * 0.10).roundToDouble();
  double get computedShipping => shippingCost > 0 ? shippingCost : (price * 0.05).roundToDouble();
  String get formattedArtisanEarning => '₹ ${directArtisanEarning.round()}';
  double get mrp => (originalPrice != null && originalPrice! > price) ? originalPrice! : (price * 1.25).roundToDouble();
  int get discountPercent => (mrp > price && mrp > 0) ? (((mrp - price) / mrp) * 100).round() : 0;
  String get formattedPrice => '₹ ${price.round()}';
  String get formattedMrp => '₹ ${mrp.round()}';
  String get priceRange => formattedPrice;
  int get popularityScore => 95;
  String get state => stateName;
  String get shortDescription => description;
  String get history => description;
  String get rawMaterials => materials;
  String get technique => category;
  List<String> get popularProducts => imageUrls;

  factory GiProductModel.fromJson(Map<String, dynamic> json) {
    final rawImageUrls = json['imageUrls'] ?? json['image_urls'];
    List<String> images = [];
    if (rawImageUrls is List) {
      images = rawImageUrls.map((e) => e.toString()).toList();
    }
    String singleImg = json['imageUrl'] as String? ?? json['image_url'] as String? ?? json['heroImage'] as String? ?? json['imagePath'] as String? ?? '';
    final titleName = json['name'] as String? ?? json['title'] as String? ?? json['craftName'] as String? ?? '';
    final craftCat = json['category'] as String? ?? json['categoryId'] as String? ?? json['craftCategory'] as String? ?? json['craft_category'] as String? ?? '';
    final resolvedFallback = getCraftImagePath('$titleName $craftCat');

    if (singleImg.contains('unsplash.com') || singleImg.contains('/craft-gallery/')) {
      singleImg = resolvedFallback;
      images = [resolvedFallback];
    } else if (singleImg.startsWith('assets/images/crafts/')) {
      singleImg = getCraftImagePath(singleImg);
    }

    if (singleImg.isNotEmpty && !images.contains(singleImg)) {
      images.insert(0, singleImg);
    }
    if (images.isEmpty && singleImg.isNotEmpty) {
      images = [singleImg];
    }

    final mainImage = (singleImg.isNotEmpty && !singleImg.contains('unsplash.com') && !singleImg.contains('/craft-gallery/'))
        ? singleImg
        : ((images.isNotEmpty && images.first.isNotEmpty && !images.first.contains('unsplash.com') && !images.first.contains('/craft-gallery/'))
            ? images.first
            : resolvedFallback);

    final isGi = json['isGiTagged'] as bool? ?? json['is_gi_tagged'] as bool? ?? json['giTagged'] as bool? ?? json['gi'] as bool? ?? (json['giTagYear'] != null && (json['giTagYear'] as num) > 0);
    final giYear = json['giTagYear'] as int? ?? json['gi_tag_year'] as int? ?? (isGi ? 2004 : 0);

    final rawState = json['stateName'] as String? ?? json['state_name'] as String? ?? json['state'] as String? ?? json['stateId'] as String? ?? '';
    final rawStateId = json['stateId'] as String? ?? json['state_id'] as String? ?? json['state'] as String? ?? '';
    final rawDistrict = json['district'] as String? ?? json['city_cluster'] as String? ?? json['city'] as String? ?? json['village'] as String? ?? '';
    final rawDesc = json['description'] as String? ?? json['craftStory'] as String? ?? json['shortDescription'] as String? ?? json['history'] as String? ?? '';
    final rawMat = json['materials'] as String? ?? json['rawMaterials'] as String? ?? 'Natural & Handcrafted Materials';

    final rawArtisanPrice = (json['artisanPrice'] as num?)?.toDouble() ?? (json['artisan_price'] as num?)?.toDouble() ?? 0.0;
    final rawPlatformFee = (json['platformFee'] as num?)?.toDouble() ?? (json['platform_fee'] as num?)?.toDouble() ?? 0.0;
    final rawShippingCost = (json['shippingCost'] as num?)?.toDouble() ?? (json['shipping_cost'] as num?)?.toDouble() ?? 0.0;

    final rawArtisanId = json['artisanId'] as String? ?? json['artisan_id'] as String? ?? json['seller_id'] as String? ?? '';
    final rawArtisanName = json['artisanName'] as String? ?? json['artisan_name'] as String? ?? json['seller_name'] as String? ?? 'Verified Master Artisan';
    final rawSellerName = json['sellerName'] as String? ?? json['seller_name'] as String? ?? rawArtisanName;
    final rawSellerVillage = json['sellerVillage'] as String? ?? json['seller_village'] as String? ?? rawDistrict;

    double parsedPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    if (parsedPrice <= 0) {
      parsedPrice = 1250.0;
    }

    final finalArtisanPrice = rawArtisanPrice > 0 ? rawArtisanPrice : (parsedPrice * 0.84).roundToDouble();
    final finalPlatformFee = rawPlatformFee > 0 ? rawPlatformFee : (parsedPrice * 0.09).roundToDouble();
    final finalShippingCost = rawShippingCost > 0 ? rawShippingCost : (parsedPrice * 0.07).roundToDouble();

    return GiProductModel(
      id: json['id']?.toString() ?? json['_id']?.toString() ?? '',
      name: json['name'] as String? ?? json['title'] as String? ?? json['craftName'] as String? ?? '',
      stateId: rawStateId,
      stateName: rawState,
      category: json['category'] as String? ?? json['categoryId'] as String? ?? json['craftCategory'] as String? ?? json['craft_category'] as String? ?? '',
      giTagYear: giYear,
      description: rawDesc,
      imageUrl: mainImage,
      certifiedArtisanCount: json['certifiedArtisanCount'] as int? ?? (json['artisanCount'] as num?)?.toInt() ?? 0,
      district: rawDistrict,
      price: parsedPrice,
      originalPrice: (json['originalPrice'] as num?)?.toDouble() ?? (parsedPrice * 1.25).roundToDouble(),
      imageUrls: images,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      artisanId: rawArtisanId,
      artisanName: rawArtisanName,
      artisanAvatar: json['artisanAvatar'] as String? ?? '',
      craftStory: json['craftStory'] as String? ?? rawDesc,
      isWomenArtisan: json['isWomenArtisan'] as bool? ?? false,
      isEcoFriendly: json['isEcoFriendly'] as bool? ?? true,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 24,
      materials: rawMat,
      dimensions: json['dimensions'] as String? ?? 'Standard Size',
      weight: json['weight'] as String? ?? '500g',
      stockCount: (json['stockCount'] as num?)?.toInt() ?? 10,
      moq: (json['moq'] as num?)?.toInt() ?? 10,
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble() ?? (parsedPrice * 0.68).roundToDouble(),
      buyersCount: (json['buyersCount'] as num?)?.toInt() ?? 142,
      hsnCode: json['hsnCode'] as String? ?? '6302.91',
      exportReady: json['exportReady'] as bool? ?? true,
      pattern: json['pattern'] as String? ?? 'Traditional Geometric Motifs',
      careInstructions: json['careInstructions'] as String? ?? 'Dry clean or gentle hand wash with mild natural soap; dry in shade.',
      artisanPrice: finalArtisanPrice,
      platformFee: finalPlatformFee,
      shippingCost: finalShippingCost,
      sellerName: rawSellerName,
      sellerVillage: rawSellerVillage,
      cooperativeName: json['cooperativeName'] as String? ?? json['cooperative_name'] as String? ?? 'State Handloom Cooperative Federation',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'stateId': stateId,
      'stateName': stateName,
      'category': category,
      'giTagYear': giTagYear,
      'description': description,
      'imageUrl': imageUrl,
      'certifiedArtisanCount': certifiedArtisanCount,
      'district': district,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrls': imageUrls,
      'rating': rating,
      'artisanId': artisanId,
      'artisanName': artisanName,
      'artisanAvatar': artisanAvatar,
      'craftStory': craftStory,
      'isWomenArtisan': isWomenArtisan,
      'isEcoFriendly': isEcoFriendly,
      'reviewCount': reviewCount,
      'materials': materials,
      'dimensions': dimensions,
      'weight': weight,
      'stockCount': stockCount,
      'moq': moq,
      'wholesalePrice': wholesalePrice,
      'buyersCount': buyersCount,
      'hsnCode': hsnCode,
      'exportReady': exportReady,
      'pattern': pattern,
      'careInstructions': careInstructions,
      'artisanPrice': artisanPrice,
      'platformFee': platformFee,
      'shippingCost': shippingCost,
      'sellerName': sellerName,
      'sellerVillage': sellerVillage,
      'cooperativeName': cooperativeName,
    };
  }

  GiProductModel copyWith({
    String? id,
    String? name,
    String? stateId,
    String? stateName,
    String? category,
    int? giTagYear,
    String? description,
    String? imageUrl,
    int? certifiedArtisanCount,
    String? district,
    double? price,
    double? originalPrice,
    List<String>? imageUrls,
    double? rating,
    String? artisanId,
    String? artisanName,
    String? artisanAvatar,
    String? craftStory,
    bool? isWomenArtisan,
    bool? isEcoFriendly,
    int? reviewCount,
    String? materials,
    String? dimensions,
    String? weight,
    int? stockCount,
    int? moq,
    double? wholesalePrice,
    int? buyersCount,
    String? hsnCode,
    bool? exportReady,
    String? pattern,
    String? careInstructions,
  }) {
    return GiProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      stateId: stateId ?? this.stateId,
      stateName: stateName ?? this.stateName,
      category: category ?? this.category,
      giTagYear: giTagYear ?? this.giTagYear,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      certifiedArtisanCount: certifiedArtisanCount ?? this.certifiedArtisanCount,
      district: district ?? this.district,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrls: imageUrls ?? this.imageUrls,
      rating: rating ?? this.rating,
      artisanId: artisanId ?? this.artisanId,
      artisanName: artisanName ?? this.artisanName,
      artisanAvatar: artisanAvatar ?? this.artisanAvatar,
      craftStory: craftStory ?? this.craftStory,
      isWomenArtisan: isWomenArtisan ?? this.isWomenArtisan,
      isEcoFriendly: isEcoFriendly ?? this.isEcoFriendly,
      reviewCount: reviewCount ?? this.reviewCount,
      materials: materials ?? this.materials,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      stockCount: stockCount ?? this.stockCount,
      moq: moq ?? this.moq,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      buyersCount: buyersCount ?? this.buyersCount,
      hsnCode: hsnCode ?? this.hsnCode,
      exportReady: exportReady ?? this.exportReady,
      pattern: pattern ?? this.pattern,
      careInstructions: careInstructions ?? this.careInstructions,
    );
  }
}
