class SpotlightModel {
  final String id;
  final String title;
  final String artisanName;
  final String craftName;
  final String stateId;
  final String story;
  final String imageUrl;
  final String videoUrl;

  const SpotlightModel({
    required this.id,
    required this.title,
    required this.artisanName,
    required this.craftName,
    required this.stateId,
    required this.story,
    this.imageUrl = '',
    this.videoUrl = '',
  });

  factory SpotlightModel.fromJson(Map<String, dynamic> json) {
    return SpotlightModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      artisanName: json['artisanName'] as String? ?? '',
      craftName: json['craftName'] as String? ?? '',
      stateId: json['stateId'] as String? ?? '',
      story: json['story'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      videoUrl: json['videoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artisanName': artisanName,
      'craftName': craftName,
      'stateId': stateId,
      'story': story,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }

  SpotlightModel copyWith({
    String? id,
    String? title,
    String? artisanName,
    String? craftName,
    String? stateId,
    String? story,
    String? imageUrl,
    String? videoUrl,
  }) {
    return SpotlightModel(
      id: id ?? this.id,
      title: title ?? this.title,
      artisanName: artisanName ?? this.artisanName,
      craftName: craftName ?? this.craftName,
      stateId: stateId ?? this.stateId,
      story: story ?? this.story,
      imageUrl: imageUrl ?? this.imageUrl,
      videoUrl: videoUrl ?? this.videoUrl,
    );
  }
}
