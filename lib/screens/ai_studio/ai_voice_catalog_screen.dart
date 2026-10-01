import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/ai_result_model.dart';
import '../../providers/ai_studio_provider.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AiVoiceCatalogScreen extends ConsumerStatefulWidget {
  const AiVoiceCatalogScreen({super.key});

  @override
  ConsumerState<AiVoiceCatalogScreen> createState() => _AiVoiceCatalogScreenState();
}

class _AiVoiceCatalogScreenState extends ConsumerState<AiVoiceCatalogScreen> {
  bool _isRecording = false;
  bool _isAnalyzing = false;
  AiTranscriptResult? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Voice Catalog Generator 🎙️'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Speak Your Craft Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display'),
            ),
            const SizedBox(height: 6),
            const Text('Artisans can describe their product in regional languages. Virasat AI generates bilingual descriptions & SEO keywords automatically.', textAlign: TextAlign.center),

            const SizedBox(height: 32),

            // Mic Button Container
            GestureDetector(
              onTap: () async {
                setState(() => _isRecording = !_isRecording);
                if (!_isRecording) {
                  setState(() => _isAnalyzing = true);
                  final res = await ref.read(aiServiceProvider).processVoiceDescription('mock.mp3', 'Hindi');
                  setState(() {
                    _result = res;
                    _isAnalyzing = false;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _isRecording ? AppColors.accent : AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording ? AppColors.accent : AppColors.primary).withValues(alpha: 0.4),
                      blurRadius: 20,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(_isRecording ? Icons.stop : Icons.mic, size: 64, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _isRecording ? 'Listening... Speak now 🎙️' : (_isAnalyzing ? 'Analyzing Voice Transcript...' : 'Tap Mic to Start Recording'),
              style: TextStyle(fontWeight: FontWeight.bold, color: _isRecording ? AppColors.accent : AppColors.textPrimary),
            ),

            const SizedBox(height: 32),

            if (_result != null) ...[
              // Generated English Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Generated English Description 🇬🇧', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    const SizedBox(height: 8),
                    Text(_result!.englishDescription, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Generated Hindi Description
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Generated Hindi Description 🇮🇳', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.secondary)),
                    const SizedBox(height: 8),
                    Text(_result!.hindiDescription, style: const TextStyle(fontSize: 13, height: 1.4)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Generated SEO Tags
              Wrap(
                spacing: 8,
                children: _result!.extractedTags.map((tag) => Chip(label: Text(tag), backgroundColor: AppColors.chipBackground)).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
