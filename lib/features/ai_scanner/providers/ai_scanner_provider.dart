import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ai_product_analysis_model.dart';
import '../services/ai_product_scanner_service.dart';

class AIScannerState {
  final int step;
  final List<String> imagePaths;
  final AIProductAnalysis? analysis;
  final bool isScanning;
  final String? errorMessage;
  final String selectedLanguage;
  final bool bgRemoved;
  final bool lightingImproved;
  final bool isSharp;

  const AIScannerState({
    this.step = 1,
    this.imagePaths = const [
      'assets/images/crafts/bankura_terracotta_01.jpg',
    ],
    this.analysis,
    this.isScanning = false,
    this.errorMessage,
    this.selectedLanguage = 'English',
    this.bgRemoved = true,
    this.lightingImproved = true,
    this.isSharp = true,
  });

  AIScannerState copyWith({
    int? step,
    List<String>? imagePaths,
    AIProductAnalysis? analysis,
    bool? isScanning,
    String? errorMessage,
    bool clearError = false,
    String? selectedLanguage,
    bool? bgRemoved,
    bool? lightingImproved,
    bool? isSharp,
  }) {
    return AIScannerState(
      step: step ?? this.step,
      imagePaths: imagePaths ?? this.imagePaths,
      analysis: analysis ?? this.analysis,
      isScanning: isScanning ?? this.isScanning,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      bgRemoved: bgRemoved ?? this.bgRemoved,
      lightingImproved: lightingImproved ?? this.lightingImproved,
      isSharp: isSharp ?? this.isSharp,
    );
  }
}

class AIScannerNotifier extends StateNotifier<AIScannerState> {
  AIScannerNotifier() : super(const AIScannerState());

  void setStep(int step) {
    state = state.copyWith(step: step);
  }

  void addImage(String path) {
    state = state.copyWith(imagePaths: [...state.imagePaths, path]);
  }

  void removeImage(int index) {
    if (index >= 0 && index < state.imagePaths.length) {
      final updated = List<String>.from(state.imagePaths)..removeAt(index);
      state = state.copyWith(imagePaths: updated);
    }
  }

  Future<void> runAnalysis({String craftHint = ''}) async {
    state = state.copyWith(isScanning: true, clearError: true);
    try {
      final result = await AIProductScannerService.analyzeUploadedImages(
        state.imagePaths,
        craftHint: craftHint,
        targetLanguage: state.selectedLanguage,
      );
      state = state.copyWith(isScanning: false, analysis: result, clearError: true);
    } catch (e) {
      final msg = e.toString().replaceAll('Exception: ', '').replaceAll('GeminiApiException: ', '');
      state = state.copyWith(isScanning: false, errorMessage: msg);
      rethrow;
    }
  }

  void updateAnalysis(AIProductAnalysis updated) {
    state = state.copyWith(analysis: updated);
  }

  void setLanguage(String lang) {
    state = state.copyWith(selectedLanguage: lang);
  }

  void toggleBgRemoved() {
    state = state.copyWith(bgRemoved: !state.bgRemoved);
  }

  void toggleLighting() {
    state = state.copyWith(lightingImproved: !state.lightingImproved);
  }

  void setImages(List<String> paths) {
    state = state.copyWith(imagePaths: paths);
  }

  void resetError() {
    state = state.copyWith(clearError: true);
  }

  void reset() {
    state = const AIScannerState();
  }

  void loadSampleCraft([String craftKey = 'bandhani']) {
    final Map<String, List<String>> sampleImages = {
      'bandhani': ['assets/images/crafts/bandhani_01.jpg', 'assets/images/crafts/bandhani_02.jpg'],
      'patola': ['assets/images/crafts/patola_01.jpg'],
      'blue_pottery': ['assets/images/crafts/blue_pottery_01.jpg'],
      'pashmina': ['assets/images/crafts/pashmina_01.jpg'],
      'ajrakh': ['assets/images/crafts/ajrakh_01.jpg'],
      'chikankari': ['assets/images/crafts/chikankari_01.jpg'],
      'madhubani': ['assets/images/crafts/pattachitra_01.jpg'],
      'bamboo': ['assets/images/crafts/bamboo_basket_01.jpg'],
      'dokra': ['assets/images/crafts/silver_filigree_01.jpg'],
      'brass': ['assets/images/crafts/bankura_terracotta_02.jpg'],
    };

    final paths = sampleImages[craftKey] ?? sampleImages['bandhani']!;
    state = state.copyWith(imagePaths: paths);
  }
}

final aiScannerProvider = StateNotifierProvider<AIScannerNotifier, AIScannerState>((ref) {
  return AIScannerNotifier();
});
