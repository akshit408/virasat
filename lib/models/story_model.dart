class StoryModel {
  final String craftId;
  final String origin;
  final String history;
  final String culturalSignificance;
  final String makingProcess;
  final String preservationImportance;

  const StoryModel({
    required this.craftId,
    required this.origin,
    required this.history,
    required this.culturalSignificance,
    required this.makingProcess,
    required this.preservationImportance,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      craftId: json['craftId'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      history: json['history'] as String? ?? '',
      culturalSignificance: json['culturalSignificance'] as String? ?? '',
      makingProcess: json['makingProcess'] as String? ?? '',
      preservationImportance: json['preservationImportance'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'craftId': craftId,
      'origin': origin,
      'history': history,
      'culturalSignificance': culturalSignificance,
      'makingProcess': makingProcess,
      'preservationImportance': preservationImportance,
    };
  }

  StoryModel copyWith({
    String? craftId,
    String? origin,
    String? history,
    String? culturalSignificance,
    String? makingProcess,
    String? preservationImportance,
  }) {
    return StoryModel(
      craftId: craftId ?? this.craftId,
      origin: origin ?? this.origin,
      history: history ?? this.history,
      culturalSignificance: culturalSignificance ?? this.culturalSignificance,
      makingProcess: makingProcess ?? this.makingProcess,
      preservationImportance: preservationImportance ?? this.preservationImportance,
    );
  }
}
