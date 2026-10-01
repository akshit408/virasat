import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/ai_scanner_provider.dart';
import '../services/ai_product_scanner_service.dart';

class AiHeritageStoryScreen extends ConsumerStatefulWidget {
  const AiHeritageStoryScreen({super.key});

  @override
  ConsumerState<AiHeritageStoryScreen> createState() => _AiHeritageStoryScreenState();
}

class _AiHeritageStoryScreenState extends ConsumerState<AiHeritageStoryScreen> {
  late TextEditingController _storyController;
  bool _isPlayingAudio = false;
  bool _isRegenerating = false;

  @override
  void initState() {
    super.initState();
    final analysis = ref.read(aiScannerProvider).analysis;
    _storyController = TextEditingController(
      text: analysis?.heritageStory.isNotEmpty == true
          ? analysis!.heritageStory
          : 'Handcrafted with ancestral knowledge in ${analysis?.city ?? "the craft cluster"}, ${analysis?.state ?? "India"}. Every motif preserves traditional techniques passed down through generations.',
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  Future<void> _regenerateStory() async {
    setState(() => _isRegenerating = true);
    final analysis = ref.read(aiScannerProvider).analysis;
    final craftName = analysis?.productName ?? 'Indian Heritage Craft';
    final state = analysis?.state ?? 'India';
    final materials = analysis?.materials.join(', ') ?? 'Natural eco-friendly materials';
    final technique = analysis?.technique ?? 'Ancestral handcrafting techniques';

    try {
      final newStory = await AIProductScannerService.generateHeritageStory(
        craftName: craftName,
        stateName: state,
        materials: materials,
        technique: technique,
      );
      if (mounted) {
        setState(() {
          _storyController.text = newStory;
          _isRegenerating = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fresh AI story generated via Gemini 3.8 Flash!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRegenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Story generation failed: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _toggleAudioNarration() {
    setState(() {
      _isPlayingAudio = !_isPlayingAudio;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              _isPlayingAudio ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              color: Colors.amber,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppLocalizations.tr(context, _isPlayingAudio ? 'playing_audio' : 'stop_audio'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(aiScannerProvider);
    final analysis = scannerState.analysis;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          AppLocalizations.tr(context, 'heritage_story'),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.tr(context, 'heritage_story'),
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'AI crafts an evocative cultural narrative to connect buyers directly with your craft legacy.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            // Heritage Story Editor Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.history_edu_rounded, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            AppLocalizations.tr(context, 'heritage_story'),
                            style: const TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: _toggleAudioNarration,
                        icon: Icon(
                          _isPlayingAudio ? Icons.stop_circle_outlined : Icons.volume_up_rounded,
                          size: 18,
                          color: AppColors.secondary,
                        ),
                        label: Text(
                          AppLocalizations.tr(context, _isPlayingAudio ? 'stop_audio' : 'listen_audio'),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _storyController,
                    maxLines: 7,
                    style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      filled: true,
                      fillColor: AppColors.background,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isRegenerating ? null : _regenerateStory,
                          icon: _isRegenerating
                              ? const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                                )
                              : const Icon(Icons.refresh_rounded, size: 16),
                          label: Text(_isRegenerating ? 'Generating...' : 'Regenerate', style: const TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Story copied to clipboard!')),
                            );
                          },
                          icon: const Icon(Icons.copy_rounded, size: 16),
                          label: const Text('Copy Text', style: TextStyle(fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Story Breakdown Highlights
            const Text('Story Highlights Generated:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            _buildStoryHighlightTile(Icons.location_city_outlined, 'Origin', '${analysis?.city ?? "Craft Cluster"}, ${analysis?.state ?? "India"}'),
            _buildStoryHighlightTile(Icons.auto_stories_outlined, 'Craft Category', analysis?.category ?? 'Handicraft'),
            _buildStoryHighlightTile(Icons.volunteer_activism_outlined, 'Crafting', '${analysis?.estimatedHours ?? 12} Hours (${analysis?.technique ?? "Handicraft"})'),
            _buildStoryHighlightTile(Icons.park_outlined, 'Preservation', analysis?.materials.isNotEmpty == true ? 'Uses ${analysis!.materials.join(", ")}' : 'Preserves regional artisan heritage'),

            const SizedBox(height: 32),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (analysis != null) {
                    final updated = analysis.copyWith(heritageStory: _storyController.text);
                    ref.read(aiScannerProvider.notifier).updateAnalysis(updated);
                  }
                  context.push('/ai-multilingual');
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Continue to Multilingual Listing (Step 5)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryHighlightTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
