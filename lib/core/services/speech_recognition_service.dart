import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'permission_service.dart';

enum SpeechListenerStatus {
  idle,
  listening,
  processing,
  completed,
  error,
}

class SpeechRecognitionService {
  static final stt.SpeechToText _speechToText = stt.SpeechToText();
  static bool _isInitialized = false;

  /// Initializes speech recognition engine.
  static Future<bool> initialize() async {
    if (_isInitialized) return true;
    try {
      _isInitialized = await _speechToText.initialize(
        onStatus: (status) {
          debugPrint('[SpeechRecognitionService] Speech status: $status');
        },
        onError: (errorNotification) {
          debugPrint('[SpeechRecognitionService] Speech error: ${errorNotification.errorMsg}');
        },
      );
      debugPrint('[SpeechRecognitionService] Initialized speech engine: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      debugPrint('[SpeechRecognitionService] Failed to initialize speech: $e');
      return false;
    }
  }

  /// Maps language name to speech locale ID (e.g. Gujarati -> 'gu_IN').
  static String getLocaleIdForLanguage(String language) {
    final lower = language.toLowerCase();
    if (lower.contains('gujarati') || lower.contains('ગુજરાતી')) return 'gu_IN';
    if (lower.contains('hindi') || lower.contains('हिन्दी')) return 'hi_IN';
    if (lower.contains('marathi') || lower.contains('मराठी')) return 'mr_IN';
    if (lower.contains('tamil') || lower.contains('தமிழ்')) return 'ta_IN';
    if (lower.contains('telugu') || lower.contains('తెలుగు')) return 'te_IN';
    if (lower.contains('bengali') || lower.contains('বাংলা')) return 'bn_IN';
    if (lower.contains('kannada') || lower.contains('ಕನ್ನಡ')) return 'kn_IN';
    if (lower.contains('malayalam') || lower.contains('മലയാളം')) return 'ml_IN';
    if (lower.contains('punjabi') || lower.contains('ਪੰਜਾਬੀ')) return 'pa_IN';
    return 'en_IN';
  }

  /// Starts live speech listening for target language, emitting real-time recognized text.
  static Future<void> startListening({
    required String language,
    required Function(String text) onResult,
    required Function(SpeechListenerStatus status) onStatusChange,
    Function(String error)? onError,
  }) async {
    final hasPermission = await PermissionService.requestMicrophonePermission(null);
    if (!hasPermission) {
      onStatusChange(SpeechListenerStatus.error);
      if (onError != null) onError('Microphone permission required to record speech.');
      return;
    }

    final initialized = await initialize();
    if (!initialized) {
      onStatusChange(SpeechListenerStatus.error);
      if (onError != null) onError('Speech recognition engine not available on this device.');
      return;
    }

    final localeId = getLocaleIdForLanguage(language);
    debugPrint('[SpeechRecognitionService] Starting listening in locale: $localeId ($language)');
    onStatusChange(SpeechListenerStatus.listening);

    try {
      await _speechToText.listen(
        localeId: localeId,
        onResult: (result) {
          final recognizedText = result.recognizedWords;
          debugPrint('[SpeechRecognitionService] Live transcript recognized: "$recognizedText" (final: ${result.finalResult})');
          onResult(recognizedText);

          if (result.finalResult) {
            onStatusChange(SpeechListenerStatus.completed);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 4),
        cancelOnError: true,
        partialResults: true,
      );
    } catch (e) {
      debugPrint('[SpeechRecognitionService] Listening exception: $e');
      onStatusChange(SpeechListenerStatus.error);
      if (onError != null) onError(e.toString());
    }
  }

  /// Stops speech listening session.
  static Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
      debugPrint('[SpeechRecognitionService] Speech listening stopped by user.');
    }
  }

  /// Returns true if mic is currently listening.
  static bool get isListening => _speechToText.isListening;
}
