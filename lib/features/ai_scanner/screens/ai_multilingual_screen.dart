import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/ai_scanner_provider.dart';
import '../services/ai_product_scanner_service.dart';

class AiMultilingualScreen extends ConsumerStatefulWidget {
  const AiMultilingualScreen({super.key});

  @override
  ConsumerState<AiMultilingualScreen> createState() => _AiMultilingualScreenState();
}

class _AiMultilingualScreenState extends ConsumerState<AiMultilingualScreen> {
  String _selectedLanguage = 'English';
  String _translatedText = '';
  bool _isTranslating = false;

  final List<String> _languages = AIProductScannerService.supportedLanguages22;

  @override
  void initState() {
    super.initState();
    final analysis = ref.read(aiScannerProvider).analysis;
    _translatedText = analysis != null
        ? '${analysis.productName} — ${analysis.heritageStory}'
        : 'Handcrafted GI-tagged heritage piece produced by verified master artisans in India.';
  }

  Future<void> _translateContent(String targetLanguage) async {
    setState(() {
      _selectedLanguage = targetLanguage;
      _isTranslating = true;
    });

    final analysis = ref.read(aiScannerProvider).analysis;
    final baseText = analysis != null
        ? '${analysis.productName}. Craft category: ${analysis.category}. State: ${analysis.state}. Story: ${analysis.heritageStory}'
        : 'Handcrafted GI-tagged heritage piece produced by verified master artisans in India.';

    try {
      final result = await AIProductScannerService.translateText(
        baseText,
        targetLanguage,
        contextInfo: 'Marketplace catalog listing for Indian craft',
      );
      if (mounted) {
        setState(() {
          _translatedText = result;
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isTranslating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Step 5: Multilingual Listing',
          style: TextStyle(
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
            const Text(
              '22 Scheduled Indian Languages Vernacular Support',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'VIRASAT AI translates craft listings into regional Indian languages via Gemini 3.8 Flash for nationwide buyers.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            // Language Selector Chips
            const Text('Select Target Language:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _languages.map((lang) {
                  final isSelected = lang == _selectedLanguage;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(lang, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: isSelected ? Colors.white : AppColors.textPrimary)),
                      selected: isSelected,
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      onSelected: (val) {
                        if (val) _translateContent(lang);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // Translation Preview Container
            Container(
              padding: const EdgeInsets.all(20),
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
                      Expanded(
                        child: Row(
                          children: [
                            const Icon(Icons.translate_rounded, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '$_selectedLanguage Listing Preview',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppColors.secondary.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                        child: const Text('GEMINI 3.8 FLASH', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondary)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (_isTranslating)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                      ),
                    )
                  else
                    Text(
                      _translatedText,
                      style: const TextStyle(fontSize: 14, height: 1.5, color: AppColors.textPrimary),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.push('/ai-image-enhancement');
                },
                icon: const Icon(Icons.auto_fix_high_rounded),
                label: const Text('Continue to Image Enhancement (Step 6)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
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
}
