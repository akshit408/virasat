import '../core/utils/state_helper.dart';

class StateModel {
  final String id;
  final String name;
  final String capital;
  final String region;
  final String bannerUrl;
  final String cultureOverview;
  final List<String> famousCrafts;
  final List<String> giProducts;
  final List<String> keyDistricts;
  final int totalArtisans;

  String get code => id;

  String get imagePath {
    if (bannerUrl.isNotEmpty &&
        (bannerUrl.startsWith('assets/images/crafts/') || bannerUrl.startsWith('assets/images/states/')) &&
        !bannerUrl.endsWith('_banner.jpg')) {
      return bannerUrl;
    }
    return getStateImagePath(name.isNotEmpty ? name : id);
  }

  String get featuredCraft {
    if (famousCrafts.isNotEmpty) {
      return famousCrafts.take(2).join(' • ');
    }
    if (giProducts.isNotEmpty) {
      return giProducts.take(2).join(' • ');
    }
    return getStateCraftSubtitle(name.isNotEmpty ? name : id);
  }

  String get featuredDistrict {
    if (keyDistricts.isNotEmpty) {
      return keyDistricts.take(2).join(', ');
    }
    return capital.isNotEmpty ? capital : 'Artisan Hub';
  }

  int get totalCrafts {
    final count = famousCrafts.length + giProducts.length;
    return count > 0 ? count : 12;
  }

  String get craftSubtitle => featuredCraft;


  const StateModel({
    required this.id,
    required this.name,
    required this.capital,
    this.region = 'All',
    this.bannerUrl = '',
    this.cultureOverview = '',
    this.famousCrafts = const [],
    this.giProducts = const [],
    this.keyDistricts = const [],
    this.totalArtisans = 0,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) {
    final famousRaw = json['famousCrafts'] ?? json['famous_crafts'];
    final giRaw = json['giProducts'] ?? json['gi_products'];
    final districtsRaw = json['keyDistricts'] ?? json['key_districts'];
    return StateModel(
      id: json['id'] as String? ?? json['code'] as String? ?? '',
      name: json['name'] as String? ?? '',
      capital: json['capital'] as String? ?? '',
      region: json['region'] as String? ?? 'All',
      bannerUrl: json['bannerUrl'] as String? ?? json['banner_url'] as String? ?? json['heroImage'] as String? ?? json['imagePath'] as String? ?? '',
      cultureOverview: json['cultureOverview'] as String? ?? json['culture_overview'] as String? ?? json['culturalIntro'] as String? ?? json['description'] as String? ?? '',
      famousCrafts: (famousRaw as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      giProducts: (giRaw as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      keyDistricts: (districtsRaw as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      totalArtisans: (json['totalArtisans'] as num?)?.toInt() ?? (json['total_artisans'] as num?)?.toInt() ?? (json['registeredArtisans'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'capital': capital,
      'region': region,
      'bannerUrl': bannerUrl,
      'cultureOverview': cultureOverview,
      'famousCrafts': famousCrafts,
      'giProducts': giProducts,
      'keyDistricts': keyDistricts,
      'totalArtisans': totalArtisans,
    };
  }

  StateModel copyWith({
    String? id,
    String? name,
    String? capital,
    String? region,
    String? bannerUrl,
    String? cultureOverview,
    List<String>? famousCrafts,
    List<String>? giProducts,
    List<String>? keyDistricts,
    int? totalArtisans,
  }) {
    return StateModel(
      id: id ?? this.id,
      name: name ?? this.name,
      capital: capital ?? this.capital,
      region: region ?? this.region,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      cultureOverview: cultureOverview ?? this.cultureOverview,
      famousCrafts: famousCrafts ?? this.famousCrafts,
      giProducts: giProducts ?? this.giProducts,
      keyDistricts: keyDistricts ?? this.keyDistricts,
      totalArtisans: totalArtisans ?? this.totalArtisans,
    );
  }
}
