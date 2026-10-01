class DiscoverSectionModel {
  final String title;
  final String subtitle;
  final String iconName;
  final int order;
  final String backgroundImage;

  const DiscoverSectionModel({
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.order,
    required this.backgroundImage,
  });

  factory DiscoverSectionModel.fromJson(Map<String, dynamic> json) {
    return DiscoverSectionModel(
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      iconName: json['iconName'] as String? ?? 'explore',
      order: json['order'] as int? ?? 0,
      backgroundImage: json['backgroundImage'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'iconName': iconName,
      'order': order,
      'backgroundImage': backgroundImage,
    };
  }

  DiscoverSectionModel copyWith({
    String? title,
    String? subtitle,
    String? iconName,
    int? order,
    String? backgroundImage,
  }) {
    return DiscoverSectionModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      iconName: iconName ?? this.iconName,
      order: order ?? this.order,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }
}
