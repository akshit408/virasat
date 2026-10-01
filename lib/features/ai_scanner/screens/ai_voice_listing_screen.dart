import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ai_scanner_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/services/speech_recognition_service.dart';
import '../../../features/ai_scanner/services/ai_product_scanner_service.dart';

class AIVoiceListingScreen extends ConsumerStatefulWidget {
  const AIVoiceListingScreen({super.key});

  @override
  ConsumerState<AIVoiceListingScreen> createState() => _AIVoiceListingScreenState();
}

class _AIVoiceListingScreenState extends ConsumerState<AIVoiceListingScreen>
    with TickerProviderStateMixin {
  bool _isListening = false;
  String _selectedLanguage = 'Hindi';
  String _transcript = '';
  String _aiResponse = 'Speak craft details in your native language...';
  final String _detectedCraft = 'craft';

  late AnimationController _pulseController;
  late AnimationController _waveformController;

  final List<String> _languages = AIProductScannerService.supportedLanguages22;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    SpeechRecognitionService.stopListening();
    _pulseController.dispose();
    _waveformController.dispose();
    super.dispose();
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      await SpeechRecognitionService.stopListening();
      setState(() => _isListening = false);
      return;
    }

    setState(() {
      _isListening = true;
      _transcript = 'Listening in $_selectedLanguage... Speak now!';
    });

    await SpeechRecognitionService.startListening(
      language: _selectedLanguage,
      onResult: (text) {
        if (!mounted) return;
        debugPrint('[AIVoiceListingScreen] Live speech transcript: "$text"');
        setState(() {
          _transcript = text;
          _aiResponse = 'Captured: "$text"';
        });
      },
      onStatusChange: (status) {
        if (!mounted) return;
        if (status == SpeechListenerStatus.completed || status == SpeechListenerStatus.error) {
          setState(() => _isListening = false);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scannerNotifier = ref.read(aiScannerProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice-First AI Assistant',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Multilingual Voice Listing • Zero Typing',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selection
            const Text(
              'Select Spoken Language / भाषा चुनें',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _languages.map((lang) {
                  final isSelected = _selectedLanguage == lang;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(lang, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textPrimary)),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                      onSelected: (val) {
                        if (val) setState(() => _selectedLanguage = lang);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Mic and Animated Waveform Center
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _toggleListening,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        final scale = _isListening ? 1.0 + (_pulseController.value * 0.12) : 1.0;
                        return Transform.scale(
                          scale: scale,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFA63E24), Color(0xFF6B2211)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFA63E24).withValues(alpha: 0.35),
                                  blurRadius: _isListening ? 24 : 12,
                                  spreadRadius: _isListening ? 6 : 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              _isListening ? Icons.mic : Icons.mic_none_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 14),

                  Text(
                    _isListening ? 'Listening in $_selectedLanguage...' : 'Tap Mic to Speak or Select Prompt',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Animated Waveform Visualization
                  SizedBox(
                    height: 28,
                    child: AnimatedBuilder(
                      animation: _waveformController,
                      builder: (context, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(12, (index) {
                            final factor = (index % 3 == 0)
                                ? _waveformController.value
                                : (1.0 - _waveformController.value);
                            final height = (_isListening ? 8 + (factor * 20) : 6.0).clamp(4.0, 26.0);
                            return Container(
                              width: 3.5,
                              height: height,
                              margin: const EdgeInsets.symmetric(horizontal: 2.5),
                              decoration: BoxDecoration(
                                color: _isListening ? const Color(0xFF166534) : AppColors.border,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Live Spoken Speech-to-Text Preview Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.record_voice_over_rounded, color: AppColors.primary, size: 18),
                      const SizedBox(width: 8),
                      const Text(
                        'Live Spoken Speech-to-Text',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      const Spacer(),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.secondary, size: 20),
                        tooltip: 'Read Aloud',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Playing audio in $_selectedLanguage: "$_transcript"'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '"$_transcript"',
                    style: const TextStyle(fontSize: 13, height: 1.4, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // VIRASAT AI Audio Guidance Response
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF166534).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF166534).withValues(alpha: 0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF166534),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.support_agent_rounded, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'VIRASAT Voice AI Assistant:',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _aiResponse,
                          style: const TextStyle(fontSize: 12, height: 1.35, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // AI Detected Attributes
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Extracted Craft Attributes',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildAttrRow('Craft:', _transcript.isNotEmpty ? _transcript : 'Voice Recognized Craft'),
                  _buildAttrRow('Origin:', 'Handicraft Origin Cluster'),
                  _buildAttrRow('Language:', _selectedLanguage),
                  _buildAttrRow('Status:', 'Ready for AI Catalog Generation'),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Continue to Catalog
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (_transcript.isNotEmpty && !_transcript.startsWith('Listening')) {
                    try {
                      final analysis = await AIProductScannerService.analyzeVoiceTranscript(_transcript, spokenLanguage: _selectedLanguage);
                      scannerNotifier.updateAnalysis(analysis);
                    } catch (_) {
                      await scannerNotifier.runAnalysis(craftHint: _transcript);
                    }
                  } else {
                    await scannerNotifier.runAnalysis(craftHint: _detectedCraft);
                  }
                  if (context.mounted) {
                    context.push('/ai-analysis-result');
                  }
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Generate Product Listing from Voice',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttrRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 85,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
