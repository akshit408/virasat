class AssetsManifestModel {
  final List<String> states;
  final Map<String, List<String>> crafts;
  final List<String> artisans;
  final List<String> festivals;
  final List<String> homeBanners;
  final Map<String, String> logos;
  final List<String> maps;

  const AssetsManifestModel({
    required this.states,
    required this.crafts,
    required this.artisans,
    required this.festivals,
    required this.homeBanners,
    required this.logos,
    required this.maps,
  });

  factory AssetsManifestModel.fromJson(Map<String, dynamic> json) {
    return AssetsManifestModel(
      states: (json['states'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      crafts: (json['crafts'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as List<dynamic>).map((e) => e.toString()).toList()),
          ) ??
          const {},
      artisans: (json['artisans'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      festivals: (json['festivals'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      homeBanners: (json['homeBanners'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      logos: (json['logos'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? const {},
      maps: (json['maps'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'states': states,
      'crafts': crafts,
      'artisans': artisans,
      'festivals': festivals,
      'homeBanners': homeBanners,
      'logos': logos,
      'maps': maps,
    };
  }
}
