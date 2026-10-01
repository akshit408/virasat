class ProductModel {
  final String id;
  final String name;
  final String category;
  final String state;
  final String district;
  final double price;
  final double? originalPrice;
  final List<String> imageUrls;
  final String artisanName;
  final String artisanAvatar;
  final String craftStory;
  final bool isGiTagged;
  final bool isWomenArtisan;
  final bool isEcoFriendly;
  final double rating;
  final int reviewCount;
  final String materials;
  final String dimensions;
  final String weight;
  final int stockCount;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.state,
    required this.district,
    required this.price,
    this.originalPrice,
    required this.imageUrls,
    required this.artisanName,
    required this.artisanAvatar,
    required this.craftStory,
    this.isGiTagged = false,
    this.isWomenArtisan = false,
    this.isEcoFriendly = false,
    this.rating = 4.9,
    this.reviewCount = 28,
    required this.materials,
    required this.dimensions,
    required this.weight,
    this.stockCount = 10,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      state: json['state'] as String? ?? '',
      district: json['district'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
      imageUrls: (json['imageUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      artisanName: json['artisanName'] as String? ?? 'Master Artisan',
      artisanAvatar: json['artisanAvatar'] as String? ?? '',
      craftStory: json['craftStory'] as String? ?? '',
      isGiTagged: json['isGiTagged'] as bool? ?? false,
      isWomenArtisan: json['isWomenArtisan'] as bool? ?? false,
      isEcoFriendly: json['isEcoFriendly'] as bool? ?? false,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: json['reviewCount'] as int? ?? 28,
      materials: json['materials'] as String? ?? '',
      dimensions: json['dimensions'] as String? ?? '',
      weight: json['weight'] as String? ?? '',
      stockCount: json['stockCount'] as int? ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'state': state,
      'district': district,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrls': imageUrls,
      'artisanName': artisanName,
      'artisanAvatar': artisanAvatar,
      'craftStory': craftStory,
      'isGiTagged': isGiTagged,
      'isWomenArtisan': isWomenArtisan,
      'isEcoFriendly': isEcoFriendly,
      'rating': rating,
      'reviewCount': reviewCount,
      'materials': materials,
      'dimensions': dimensions,
      'weight': weight,
      'stockCount': stockCount,
    };
  }
}
