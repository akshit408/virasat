class AiPromptModel {
  final String tool;
  final String title;
  final String promptTemplate;
  final List<String> supportedLanguages;

  const AiPromptModel({
    required this.tool,
    required this.title,
    required this.promptTemplate,
    required this.supportedLanguages,
  });

  factory AiPromptModel.fromJson(Map<String, dynamic> json) {
    return AiPromptModel(
      tool: json['tool'] as String? ?? '',
      title: json['title'] as String? ?? '',
      promptTemplate: json['promptTemplate'] as String? ?? '',
      supportedLanguages: (json['supportedLanguages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tool': tool,
      'title': title,
      'promptTemplate': promptTemplate,
      'supportedLanguages': supportedLanguages,
    };
  }

  AiPromptModel copyWith({
    String? tool,
    String? title,
    String? promptTemplate,
    List<String>? supportedLanguages,
  }) {
    return AiPromptModel(
      tool: tool ?? this.tool,
      title: title ?? this.title,
      promptTemplate: promptTemplate ?? this.promptTemplate,
      supportedLanguages: supportedLanguages ?? this.supportedLanguages,
    );
  }
}
