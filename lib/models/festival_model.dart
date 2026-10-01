class FestivalModel {
  final String id;
  final String title;
  final String stateId;
  final String month;
  final String description;
  final List<String> associatedCrafts;
  final String imageUrl;

  const FestivalModel({
    required this.id,
    required this.title,
    required this.stateId,
    required this.month,
    required this.description,
    this.associatedCrafts = const [],
    this.imageUrl = '',
  });

  factory FestivalModel.fromJson(Map<String, dynamic> json) {
    return FestivalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      stateId: json['stateId'] as String? ?? '',
      month: json['month'] as String? ?? '',
      description: json['description'] as String? ?? '',
      associatedCrafts: (json['associatedCrafts'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'stateId': stateId,
      'month': month,
      'description': description,
      'associatedCrafts': associatedCrafts,
      'imageUrl': imageUrl,
    };
  }

  FestivalModel copyWith({
    String? id,
    String? title,
    String? stateId,
    String? month,
    String? description,
    List<String>? associatedCrafts,
    String? imageUrl,
  }) {
    return FestivalModel(
      id: id ?? this.id,
      title: title ?? this.title,
      stateId: stateId ?? this.stateId,
      month: month ?? this.month,
      description: description ?? this.description,
      associatedCrafts: associatedCrafts ?? this.associatedCrafts,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
