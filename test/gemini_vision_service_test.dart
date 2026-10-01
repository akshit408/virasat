import 'package:flutter_test/flutter_test.dart';
import 'package:virasat/services/gemini_vision_service.dart';
import 'package:virasat/features/ai_scanner/models/ai_product_analysis_model.dart';

void main() {
  group('GeminiVisionService JSON Parsing & Validation Tests', () {
    late GeminiVisionService service;

    setUp(() {
      service = GeminiVisionService();
    });

    test('Parses valid craft JSON successfully (Clay Ganesha Idol)', () {
      const rawText = '''
{
  "productTitle": "Clay Ganesha Idol",
  "craftCategory": "Pottery & Terracotta",
  "state": "Maharashtra",
  "district": "Pune",
  "cityCluster": "Pen Clay Craft Cluster",
  "rawMaterials": ["Clay", "Natural Pigments"],
  "craftTechnique": "Hand Sculpting and Painting",
  "giTagStatus": "Registered",
  "craftingTime": "12 hours",
  "description": "Hand-sculpted eco-friendly terracotta Ganesha idol crafted by traditional Maharashtrian artisans."
}
''';

      final analysis = service.parseGeminiJsonResponse(rawText, 'assets/test.jpg', []);
      expect(analysis.productName, equals('Clay Ganesha Idol'));
      expect(analysis.category, equals('Pottery & Terracotta'));
      expect(analysis.state, equals('Maharashtra'));
      expect(analysis.city, equals('Pen Clay Craft Cluster'));
      expect(analysis.materials, contains('Clay'));
      expect(analysis.isGICandidate, isTrue);
      expect(analysis.isHandicraft, isTrue);
    });

    test('Parses JSON wrapped in markdown fences (Bandhani Saree)', () {
      const rawText = '''
```json
{
  "productTitle": "Bandhani Silk Saree",
  "craftCategory": "Textiles",
  "state": "Gujarat",
  "district": "Kutch",
  "cityCluster": "Bhuj",
  "rawMaterials": ["Silk", "Natural Dyes"],
  "craftTechnique": "Tie and Dye",
  "giTagStatus": "Registered",
  "craftingTime": "48 hours",
  "description": "Authentic Kutchi Bandhani saree with intricate tie-dye dot motifs."
}
```
''';

      final analysis = service.parseGeminiJsonResponse(rawText, 'assets/bandhani.jpg', []);
      expect(analysis.productName, equals('Bandhani Silk Saree'));
      expect(analysis.category, equals('Textiles'));
      expect(analysis.state, equals('Gujarat'));
      expect(analysis.estimatedHours, equals(48));
      expect(analysis.isHandicraft, isTrue);
    });

    test('Parses Brass Statue and Basket test cases', () {
      const brassText = '''
{
  "productTitle": "Dokra Brass Statue",
  "craftCategory": "Metalwork",
  "state": "West Bengal",
  "district": "Bankura",
  "cityCluster": "Bikna",
  "rawMaterials": ["Brass", "Beeswax", "Clay"],
  "craftTechnique": "Lost Wax Casting",
  "giTagStatus": "Registered",
  "craftingTime": "72 hours",
  "description": "Traditional non-ferrous metal casting using ancient lost-wax technique."
}
''';

      final brassAnalysis = service.parseGeminiJsonResponse(brassText, 'assets/brass.jpg', []);
      expect(brassAnalysis.productName, equals('Dokra Brass Statue'));
      expect(brassAnalysis.category, equals('Metalwork'));
      expect(brassAnalysis.isHandicraft, isTrue);

      const basketText = '''
{
  "productTitle": "Bamboo Craft Basket",
  "craftCategory": "Woodwork & Basketry",
  "state": "Assam",
  "district": "Kamrup",
  "cityCluster": "Guwahati",
  "rawMaterials": ["Cane", "Bamboo"],
  "craftTechnique": "Hand Weaving",
  "giTagStatus": "Applicable",
  "craftingTime": "16 hours",
  "description": "Hand-woven durable bamboo utility basket made by Assamese artisans."
}
''';

      final basketAnalysis = service.parseGeminiJsonResponse(basketText, 'assets/basket.jpg', []);
      expect(basketAnalysis.productName, equals('Bamboo Craft Basket'));
      expect(basketAnalysis.isHandicraft, isTrue);
    });

    test('Detects Non-Handicraft Items (Electronics)', () {
      const electronicsText = '''
{
  "productTitle": "Wireless Bluetooth Headphones",
  "craftCategory": "Electronics",
  "state": "Guangdong",
  "district": "Shenzhen",
  "cityCluster": "Tech Industrial Zone",
  "rawMaterials": ["Plastic", "Copper", "Lithium Battery"],
  "craftTechnique": "Factory Automated Assembly",
  "giTagStatus": "None",
  "craftingTime": "0 hours",
  "description": "Mass-produced electronic wireless headphones."
}
''';

      final electronicsAnalysis = service.parseGeminiJsonResponse(electronicsText, 'assets/headphone.jpg', []);
      expect(electronicsAnalysis.productName, equals('Wireless Bluetooth Headphones'));
      expect(electronicsAnalysis.category, equals('Electronics'));
      expect(electronicsAnalysis.isHandicraft, isFalse);
    });

    test('Throws IncompleteGeminiResponseException on truncated JSON string', () {
      const truncatedText = '''
{
  "productTitle": "Clay Ganesha Idol",
  "craftCategory": "Pottery",
  "state": "Maharashtra",
  "district": "Pune",
  "cityCluster": "Pen",
  "rawMaterials": ["Clay"],
  "craftTechnique": "Sculpting
''';

      expect(
        () => service.parseGeminiJsonResponse(truncatedText, 'assets/test.jpg', []),
        throwsA(isA<IncompleteGeminiResponseException>()),
      );
    });

    test('Throws MissingRequiredKeysException when required key is missing', () {
      const missingKeyText = '''
{
  "productTitle": "Clay Idol",
  "craftCategory": "Pottery",
  "state": "Maharashtra",
  "district": "Pune",
  "cityCluster": "Pen",
  "rawMaterials": ["Clay"],
  "craftTechnique": "Sculpting",
  "giTagStatus": "None",
  "craftingTime": "10 hours"
}
'''; // missing 'description' key

      expect(
        () => service.parseGeminiJsonResponse(missingKeyText, 'assets/test.jpg', []),
        throwsA(isA<MissingRequiredKeysException>()),
      );
    });

    test('Safe Defaults: Missing optional fields do not crash AIProductAnalysis', () {
      final jsonMap = {
        'productTitle': 'Minimal Craft',
        'craftCategory': 'Handicraft',
        'state': 'India',
        'district': 'Central',
        'cityCluster': 'Cluster',
        'rawMaterials': ['Wood'],
        'craftTechnique': 'Carving',
        'giTagStatus': 'None',
        'craftingTime': '24',
        'description': 'A simple craft item.'
      };

      final analysis = AIProductAnalysis.fromJson(jsonMap);
      expect(analysis.productName, equals('Minimal Craft'));
      expect(analysis.suggestedPrice, equals(3000.0));
      expect(analysis.confidence, equals(0.95));
      expect(analysis.dimensions, equals('Standard Size'));
      expect(analysis.weight, equals('500g'));
      expect(analysis.isGICandidate, isFalse);
    });

    test('GeminiVisionService clearCache resets in-memory cache', () {
      expect(() => GeminiVisionService.clearCache(), returnsNormally);
    });
  });
}
