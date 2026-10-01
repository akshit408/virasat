import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ai_service.dart';
import '../models/ai_result_model.dart';

final aiServiceProvider = Provider<AIService>((ref) => AIService());

final aiPricingResultProvider = StateProvider<AiPricingResult?>((ref) => null);
final aiStoryResultProvider = StateProvider<AiStoryResult?>((ref) => null);
final aiTranscriptResultProvider = StateProvider<AiTranscriptResult?>((ref) => null);
final enhancedImageProvider = StateProvider<String?>((ref) => null);
