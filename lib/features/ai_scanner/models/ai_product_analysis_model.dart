class AIProductAnalysis {
  final String productTitle;
  final String craftCategory;
  final String state;
  final String cityCluster;
  final List<String> rawMaterials;
  final String craftTechnique;
  final String culturalSignificance;
  final double estimatedPriceMin;
  final double estimatedPriceMax;
  final double confidenceScore;

  // Auxiliary fields for UI compatibility
  final String subcategory;
  final List<String> colors;
  final int estimatedHours;
  final String dimensions;
  final String weight;
  final List<String> suggestedTags;
  final bool isGICandidate;
  final List<String> imagePaths;
  final double materialCost;
  final double laborCost;
  final double marketValue;
  final double profitMargin;
  final String pattern;
  final double regionalMultiplier;
  final String marketReference;
  final double suggestedWholesalePrice;
  final String priceConfidenceBadge;
  final String aiExplanation;
  final String packaging;
  final String countryLabels;
  final String hsnCode;
  final String careInstructions;
  final int moq;

  const AIProductAnalysis({
    required this.productTitle,
    required this.craftCategory,
    required this.state,
    required this.cityCluster,
    required this.rawMaterials,
    required this.craftTechnique,
    required this.culturalSignificance,
    required this.estimatedPriceMin,
    required this.estimatedPriceMax,
    required this.confidenceScore,
    this.subcategory = '',
    this.colors = const [],
    this.estimatedHours = 12,
    this.dimensions = 'Standard Size',
    this.weight = '500g',
    this.suggestedTags = const [],
    this.isGICandidate = true,
    this.imagePaths = const [],
    this.materialCost = 0.0,
    this.laborCost = 0.0,
    this.marketValue = 0.0,
    this.profitMargin = 0.55,
    this.pattern = 'Traditional Handcrafted Motifs',
    this.regionalMultiplier = 1.25,
    this.marketReference = 'Craft Cluster Pricing Benchmark Index',
    this.suggestedWholesalePrice = 0.0,
    this.priceConfidenceBadge = 'Fair Trade Verified',
    this.aiExplanation = 'Fair artisan compensation benchmarked with craft cluster labor hours and material costs.',
    this.packaging = 'Export-Grade Packaging',
    this.countryLabels = 'Made in India • 100% Handcrafted',
    this.hsnCode = '6302.91',
    this.careInstructions = 'Gentle hand wash with natural soap or dry clean.',
    this.moq = 1,
  });

  // Alias getters for legacy component compatibility
  String get productName => productTitle;
  String get category => craftCategory;
  String get technique => craftTechnique;
  String get city => cityCluster;
  List<String> get materials => rawMaterials;
  String get heritageStory => culturalSignificance;
  double get confidence => confidenceScore;
  double get suggestedPrice => (estimatedPriceMin + estimatedPriceMax) / 2.0 > 0
      ? (estimatedPriceMin + estimatedPriceMax) / 2.0
      : estimatedPriceMin;

  String get craftName => productTitle;
  String get suggestedState => state;
  String get suggestedCategory => craftCategory;
  List<String> get detectedMaterials => rawMaterials;
  String get detectedTechnique => craftTechnique;
  double get recommendedPrice => suggestedPrice;
  String get generatedStory => culturalSignificance;
  bool get isGiCandidate => isGICandidate;
  String get imagePath => imagePaths.isNotEmpty ? imagePaths.first : '';

  factory AIProductAnalysis.fromJson(Map<String, dynamic> json, {List<String> imagePaths = const []}) {
    List<String> parseList(dynamic val) {
      if (val is List) return val.map((e) => e.toString()).toList();
      if (val is String && val.isNotEmpty) return val.split(',').map((e) => e.trim()).toList();
      return [];
    }

    double parseNum(dynamic val, [double defaultVal = 0.0]) {
      if (val is num) return val.toDouble();
      if (val is String) {
        final parsed = double.tryParse(val.replaceAll(RegExp(r'[^0-9.]'), ''));
        if (parsed != null) return parsed;
      }
      return defaultVal;
    }

    final pTitle = json['productTitle'] as String? ?? json['title'] as String? ?? json['productName'] as String? ?? 'Handcrafted Art';
    final cCat = json['craftCategory'] as String? ?? json['craft_category'] as String? ?? json['category'] as String? ?? 'Handicraft';
    final st = json['state'] as String? ?? json['stateOfOrigin'] as String? ?? 'India';
    final cCluster = json['cityCluster'] as String? ?? json['district'] as String? ?? json['city'] as String? ?? 'Craft Cluster';
    final rMats = parseList(json['rawMaterials'] ?? json['raw_materials'] ?? json['materials']);
    final cTech = json['craftTechnique'] as String? ?? json['craft_technique'] as String? ?? json['technique'] as String? ?? 'Traditional Hand Technique';
    final cSig = json['culturalSignificance'] as String? ?? json['description'] as String? ?? json['heritageStory'] as String? ?? '';

    double minPrice = parseNum(json['estimatedPriceMin'] ?? json['minPrice']);
    double maxPrice = parseNum(json['estimatedPriceMax'] ?? json['maxPrice']);
    final singlePrice = parseNum(json['suggestedPrice'] ?? json['recommended_price'] ?? json['recommendedPrice']);

    if (minPrice == 0 && maxPrice == 0) {
      if (singlePrice > 0) {
        minPrice = singlePrice * 0.85;
        maxPrice = singlePrice * 1.15;
      } else {
        minPrice = 2500.0;
        maxPrice = 3500.0;
      }
    }

    double conf = parseNum(json['confidenceScore'] ?? json['confidence'] ?? json['authenticityConfidence'], 0.95);
    if (conf > 1.0) conf = conf / 100.0;

    final bool parsedGiCandidate = json['giConfidence'] != null
        ? ((json['giConfidence'] as num).toDouble() > 0.6)
        : (json['giTagStatus'] != null
            ? (json['giTagStatus'].toString().toLowerCase() != 'none' && json['giTagStatus'].toString().toLowerCase() != 'false')
            : (json['isGICandidate'] as bool? ?? json['estimatedGiStatus'] as bool? ?? true));

    return AIProductAnalysis(
      productTitle: pTitle,
      craftCategory: cCat,
      state: st,
      cityCluster: cCluster,
      rawMaterials: rMats,
      craftTechnique: cTech,
      culturalSignificance: cSig,
      estimatedPriceMin: minPrice,
      estimatedPriceMax: maxPrice,
      confidenceScore: conf,
      subcategory: json['subcategory'] as String? ?? '',
      colors: parseList(json['colors']),
      estimatedHours: parseNum(json['estimatedHours'] ?? json['craftingTime'], 12).toInt(),
      dimensions: json['dimensions'] as String? ?? 'Standard Size',
      weight: json['weight'] as String? ?? '500g',
      suggestedTags: parseList(json['suggestedTags'] ?? json['keywords']),
      isGICandidate: parsedGiCandidate,
      imagePaths: imagePaths.isNotEmpty ? imagePaths : parseList(json['imagePaths']),
      materialCost: parseNum(json['materialCost'] ?? (minPrice * 0.3)),
      laborCost: parseNum(json['laborCost'] ?? (minPrice * 0.5)),
      marketValue: parseNum(json['marketValue'] ?? (maxPrice * 1.2)),
      profitMargin: parseNum(json['profitMargin'], 0.55),
      pattern: json['pattern'] as String? ?? 'Traditional Handcrafted Motifs',
      regionalMultiplier: parseNum(json['regionalMultiplier'], 1.25),
      marketReference: json['marketReference'] as String? ?? 'Craft Cluster Benchmark Index',
      suggestedWholesalePrice: parseNum(json['suggestedWholesalePrice'] ?? (minPrice * 0.7)),
      priceConfidenceBadge: '${(conf * 100).toStringAsFixed(0)}% Confidence',
      aiExplanation: json['aiExplanation'] as String? ?? 'Fair artisan compensation benchmarked with craft cluster labor hours and material costs.',
      packaging: json['packaging'] as String? ?? 'Export-Grade Packaging',
      countryLabels: json['countryLabels'] as String? ?? 'Made in India • 100% Handcrafted',
      hsnCode: json['hsnCode'] as String? ?? '6302.91',
      careInstructions: json['careInstructions'] as String? ?? 'Gentle hand wash with natural soap or dry clean.',
      moq: parseNum(json['moq'], 1).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productTitle': productTitle,
      'craftCategory': craftCategory,
      'state': state,
      'cityCluster': cityCluster,
      'rawMaterials': rawMaterials,
      'craftTechnique': craftTechnique,
      'culturalSignificance': culturalSignificance,
      'estimatedPriceMin': estimatedPriceMin,
      'estimatedPriceMax': estimatedPriceMax,
      'confidenceScore': confidenceScore,
      'productName': productTitle,
      'category': craftCategory,
      'materials': rawMaterials,
      'technique': craftTechnique,
      'city': cityCluster,
      'heritageStory': culturalSignificance,
      'suggestedPrice': suggestedPrice,
      'imagePaths': imagePaths,
    };
  }

  AIProductAnalysis copyWith({
    String? productTitle,
    String? craftCategory,
    String? state,
    String? cityCluster,
    List<String>? rawMaterials,
    String? craftTechnique,
    String? culturalSignificance,
    String? heritageStory,
    double? estimatedPriceMin,
    double? estimatedPriceMax,
    double? suggestedPrice,
    double? confidenceScore,
    String? subcategory,
    List<String>? colors,
    int? estimatedHours,
    String? dimensions,
    String? weight,
    List<String>? suggestedTags,
    bool? isGICandidate,
    List<String>? imagePaths,
    double? materialCost,
    double? laborCost,
    double? marketValue,
    double? profitMargin,
    String? pattern,
    double? regionalMultiplier,
    String? marketReference,
    double? suggestedWholesalePrice,
    String? priceConfidenceBadge,
    String? aiExplanation,
    String? packaging,
    String? countryLabels,
    String? hsnCode,
    String? careInstructions,
    int? moq,
  }) {
    return AIProductAnalysis(
      productTitle: productTitle ?? this.productTitle,
      craftCategory: craftCategory ?? this.craftCategory,
      state: state ?? this.state,
      cityCluster: cityCluster ?? this.cityCluster,
      rawMaterials: rawMaterials ?? this.rawMaterials,
      craftTechnique: craftTechnique ?? this.craftTechnique,
      culturalSignificance: heritageStory ?? culturalSignificance ?? this.culturalSignificance,
      estimatedPriceMin: suggestedPrice != null ? (suggestedPrice * 0.85) : (estimatedPriceMin ?? this.estimatedPriceMin),
      estimatedPriceMax: suggestedPrice != null ? (suggestedPrice * 1.15) : (estimatedPriceMax ?? this.estimatedPriceMax),
      confidenceScore: confidenceScore ?? this.confidenceScore,
      subcategory: subcategory ?? this.subcategory,
      colors: colors ?? this.colors,
      estimatedHours: estimatedHours ?? this.estimatedHours,
      dimensions: dimensions ?? this.dimensions,
      weight: weight ?? this.weight,
      suggestedTags: suggestedTags ?? this.suggestedTags,
      isGICandidate: isGICandidate ?? this.isGICandidate,
      imagePaths: imagePaths ?? this.imagePaths,
      materialCost: materialCost ?? this.materialCost,
      laborCost: laborCost ?? this.laborCost,
      marketValue: marketValue ?? this.marketValue,
      profitMargin: profitMargin ?? this.profitMargin,
      pattern: pattern ?? this.pattern,
      regionalMultiplier: regionalMultiplier ?? this.regionalMultiplier,
      marketReference: marketReference ?? this.marketReference,
      suggestedWholesalePrice: suggestedWholesalePrice ?? this.suggestedWholesalePrice,
      priceConfidenceBadge: priceConfidenceBadge ?? this.priceConfidenceBadge,
      aiExplanation: aiExplanation ?? this.aiExplanation,
      packaging: packaging ?? this.packaging,
      countryLabels: countryLabels ?? this.countryLabels,
      hsnCode: hsnCode ?? this.hsnCode,
      careInstructions: careInstructions ?? this.careInstructions,
      moq: moq ?? this.moq,
    );
  }

  bool get isHandicraft {
    final lowerCat = craftCategory.toLowerCase();
    final lowerTitle = productTitle.toLowerCase();
    final lowerTech = craftTechnique.toLowerCase();

    final invalidKeywords = [
      'electronics', 'electronic', 'appliance', 'appliances',
      'plastic product', 'plastic', 'mobile accessory', 'mobile accessories',
      'factory product', 'factory made', 'mass produced', 'gadget', 'charger', 'headphone',
    ];

    for (final kw in invalidKeywords) {
      if (lowerCat.contains(kw) || lowerTitle.contains(kw) || lowerTech.contains(kw)) {
        return false;
      }
    }
    return true;
  }
}
