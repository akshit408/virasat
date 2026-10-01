import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/config/env_config.dart';
import '../../../services/supabase_service.dart';
import '../../../services/gemini_vision_service.dart';
import '../models/ai_product_analysis_model.dart';

class AIProductScannerService {
  static final GeminiVisionService _geminiVisionService = GeminiVisionService();

  /// Executes complete AI Sell My Craft pipeline:
  /// 1. Uploads image to Supabase Storage if local file
  /// 2. Analyzes image with Gemini Vision API
  /// 3. Returns live AIProductAnalysis model
  static Future<AIProductAnalysis> analyzeUploadedImages(
    List<String> imagePaths, {
    String craftHint = '',
    String targetLanguage = 'English',
  }) async {
    if (imagePaths.isEmpty) {
      throw Exception('No image file selected for analysis. Please upload at least 1 photo.');
    }

    final localPath = imagePaths.first;

    // Step 1: Upload Image to Supabase Storage (or keep path if asset / http)
    String publicImageUrl = localPath;
    if (!localPath.startsWith('assets/') && !localPath.startsWith('http')) {
      try {
        List<int>? bytes;
        if (kIsWeb || localPath.startsWith('blob:')) {
          bytes = await XFile(localPath).readAsBytes();
        } else {
          final file = File(localPath.startsWith('file://') ? Uri.parse(localPath).toFilePath() : localPath);
          if (await file.exists()) {
            bytes = await file.readAsBytes();
          }
        }

        if (bytes != null && bytes.isNotEmpty) {
          final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
          final uploadedUrl = await SupabaseService.uploadProductImage(bytes, fileName);
          if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
            publicImageUrl = uploadedUrl;
          }
        }
      } catch (e) {
        debugPrint('[AIProductScannerService] Supabase Storage upload note: $e');
      }
    }

    // Step 2: Send Image to Gemini Vision API (logs [VERIFY] request & response)
    final geminiResult = await _geminiVisionService.analyzeCraftImage(
      localPath,
      additionalImages: imagePaths.skip(1).toList(),
      targetLanguage: targetLanguage,
    );

    // Step 3: Return live parsed AIProductAnalysis model with updated image paths
    final finalAnalysis = AIProductAnalysis.fromJson(
      geminiResult.toJson(),
      imagePaths: [publicImageUrl, ...imagePaths.skip(1)],
    );

    return finalAnalysis;
  }

  /// Generates a fresh heritage story directly via Gemini API.
  static Future<String> generateHeritageStory({
    required String craftName,
    required String stateName,
    required String materials,
    required String technique,
  }) async {
    return await _geminiVisionService.generateHeritageStory(
      craftName: craftName,
      stateName: stateName,
      materials: materials,
      technique: technique,
    );
  }

  static const List<String> supportedLanguages22 = [
    'English', 'हिन्दी', 'ગુજરાતી', 'தமிழ்', 'తెలుగు', 'मराठी', 'বাংলা', 'ಕನ್ನಡ',
    'മലയാളം', 'ਪੰਜਾਬᱤ', 'ଓଡ଼ᱤଆ', 'অসমীয়া', 'اردو', 'मैथिली', 'ᱥᱟᱱᱛᱟᱲᱤ', 'کأشُر',
    'नेपाली', 'डोगरी', 'कोंकणी', 'ꯃꯤꯇꯩꯂꯣꯟ', "बर'", 'संस्कृतम्'
  ];

  /// Translates text into target Indian language strictly using Gemini API.
  static Future<String> translateText(String text, String targetLanguage, {String contextInfo = ''}) async {
    return await _geminiVisionService.translateText(
      text: text,
      targetLanguage: targetLanguage,
      contextInfo: contextInfo,
    );
  }

  /// Converts spoken voice transcript into a complete AIProductAnalysis catalog.
  static Future<AIProductAnalysis> analyzeVoiceTranscript(String transcript, {String spokenLanguage = 'Hindi'}) async {
    const apiKey = EnvConfig.geminiApiKey;
    if (apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY is not configured via --dart-define=GEMINI_API_KEY=...');
    }

    final prompt = '''
You are an expert Indian Handicrafts and Cataloging Specialist for VIRASAT.
An artisan spoke the following product description in $spokenLanguage:
"$transcript"

Extract and generate a complete, structured catalog listing.
Return ONLY valid JSON:
{
  "productTitle": "descriptive craft title",
  "craftCategory": "Textiles / Pottery / Woodwork / Paintings / Metalwork / etc.",
  "state": "Indian state of origin",
  "cityCluster": "city or craft cluster",
  "rawMaterials": ["material 1", "material 2"],
  "craftTechnique": "specific crafting technique",
  "culturalSignificance": "heritage story",
  "estimatedPriceMin": 2500,
  "estimatedPriceMax": 3500,
  "confidenceScore": 0.95
}
''';

    final dio = Dio();
    final response = await dio.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
      data: {
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ],
        "generationConfig": {
          "temperature": 0.2,
          "responseMimeType": "application/json",
        }
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final text = response.data['candidates']?[0]?['content']?['parts']?[0]?['text'] as String?;
      if (text != null && text.trim().isNotEmpty) {
        final Map<String, dynamic> jsonMap = jsonDecode(text.trim());
        return AIProductAnalysis.fromJson(jsonMap);
      }
    }
    throw Exception('Failed to generate product catalog from voice transcript via Gemini AI.');
  }
}
