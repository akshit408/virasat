class AiPricingResult {
  final double minPrice;
  final double maxPrice;
  final double recommendedPrice;
  final double estimatedProfit;
  final String reasoning;

  const AiPricingResult({
    required this.minPrice,
    required this.maxPrice,
    required this.recommendedPrice,
    required this.estimatedProfit,
    required this.reasoning,
  });
}

class AiStoryResult {
  final String englishStory;
  final String hindiStory;
  final List<String> seoTags;
  final String heritageContext;

  const AiStoryResult({
    required this.englishStory,
    required this.hindiStory,
    required this.seoTags,
    required this.heritageContext,
  });
}

class AiTranscriptResult {
  final String rawText;
  final String englishDescription;
  final String hindiDescription;
  final List<String> extractedTags;

  const AiTranscriptResult({
    required this.rawText,
    required this.englishDescription,
    required this.hindiDescription,
    required this.extractedTags,
  });
}
