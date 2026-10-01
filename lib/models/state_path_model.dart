class StatePathModel {
  final String id;
  final String name;
  final String region;
  final String capital;
  final double centerX;
  final double centerY;
  final String path;

  const StatePathModel({
    required this.id,
    required this.name,
    required this.region,
    required this.capital,
    required this.centerX,
    required this.centerY,
    required this.path,
  });

  factory StatePathModel.fromJson(Map<String, dynamic> json) {
    return StatePathModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      region: json['region'] as String? ?? 'North',
      capital: json['capital'] as String? ?? '',
      centerX: (json['centerX'] as num?)?.toDouble() ?? 0.0,
      centerY: (json['centerY'] as num?)?.toDouble() ?? 0.0,
      path: json['path'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'capital': capital,
      'centerX': centerX,
      'centerY': centerY,
      'path': path,
    };
  }

  StatePathModel copyWith({
    String? id,
    String? name,
    String? region,
    String? capital,
    double? centerX,
    double? centerY,
    String? path,
  }) {
    return StatePathModel(
      id: id ?? this.id,
      name: name ?? this.name,
      region: region ?? this.region,
      capital: capital ?? this.capital,
      centerX: centerX ?? this.centerX,
      centerY: centerY ?? this.centerY,
      path: path ?? this.path,
    );
  }
}
