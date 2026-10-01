import 'gi_product_model.dart';

class FestivalCollectionModel {
  final String id;
  final String slug;
  final String title;
  final String subtitle;
  final String bannerImage;
  final String themeColor;
  final double minPrice;
  final double maxPrice;
  final bool active;
  final String createdAt;
  final List<GiProductModel> products;

  FestivalCollectionModel({
    required this.id,
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.bannerImage,
    required this.themeColor,
    required this.minPrice,
    required this.maxPrice,
    required this.active,
    required this.createdAt,
    required this.products,
  });

  factory FestivalCollectionModel.fromJson(Map<String, dynamic> json) {
    return FestivalCollectionModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      bannerImage: json['banner_image'] as String? ?? json['bannerImage'] as String? ?? '',
      themeColor: json['theme_color'] as String? ?? json['themeColor'] as String? ?? '#D97706',
      minPrice: (json['min_price'] as num?)?.toDouble() ?? (json['minPrice'] as num?)?.toDouble() ?? 500.0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? (json['maxPrice'] as num?)?.toDouble() ?? 2000.0,
      active: json['active'] as bool? ?? true,
      createdAt: json['created_at'] as String? ?? json['createdAt'] as String? ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => GiProductModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
