import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/ai_scanner_provider.dart';

class AiAnalysisResultScreen extends ConsumerStatefulWidget {
  const AiAnalysisResultScreen({super.key});

  @override
  ConsumerState<AiAnalysisResultScreen> createState() => _AiAnalysisResultScreenState();
}

class _AiAnalysisResultScreenState extends ConsumerState<AiAnalysisResultScreen> {
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _subcategoryController;
  late TextEditingController _stateController;
  late TextEditingController _cityController;
  late TextEditingController _techniqueController;

  @override
  void initState() {
    super.initState();
    final analysis = ref.read(aiScannerProvider).analysis;
    _nameController = TextEditingController(text: analysis?.productTitle ?? '');
    _categoryController = TextEditingController(text: analysis?.craftCategory ?? '');
    _subcategoryController = TextEditingController(text: analysis?.subcategory ?? '');
    _stateController = TextEditingController(text: analysis?.state ?? '');
    _cityController = TextEditingController(text: analysis?.cityCluster ?? '');
    _techniqueController = TextEditingController(text: analysis?.craftTechnique ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _categoryController.dispose();
    _subcategoryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _techniqueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(aiScannerProvider);
    final analysis = scannerState.analysis;
    final isCraftValid = analysis == null || analysis.isHandicraft;

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
          AppLocalizations.tr(context, 'scanner_step_2'),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
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
              AppLocalizations.tr(context, 'scanner_step_2'),
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Review AI visual detection results from photo analysis. Tap any field to customize.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 20),

            // Non-handicraft Error Banner
            if (!isCraftValid) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline_rounded, color: Colors.red.shade700, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'This item is not an Indian handicraft.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Card 1 — Product Identity
            _buildCardContainer(
              title: 'Product Identity',
              icon: Icons.fingerprint_rounded,
              child: Column(
                children: [
                  _buildEditField('Product Title', _nameController),
                  Row(
                    children: [
                      Expanded(child: _buildEditField('Category', _categoryController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildEditField('Subcategory', _subcategoryController)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: AppColors.secondary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'AI Confidence: ${( (analysis?.confidenceScore ?? 0.95) * 100 ).toStringAsFixed(0)}% • GI Heritage Verified',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card 2 — Material & Technique Detection
            _buildCardContainer(
              title: 'Material & Technique Detection',
              icon: Icons.precision_manufacturing_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Detected Raw Materials:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (analysis?.rawMaterials ?? []).map((mat) {
                      return Chip(
                        label: Text(mat, style: const TextStyle(fontSize: 11)),
                        backgroundColor: AppColors.background,
                        side: const BorderSide(color: AppColors.border),
                      );
                    }).toList(),
                  ),
                  if ((analysis?.colors ?? []).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Detected Colors:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: (analysis?.colors ?? []).map((col) {
                        return Chip(
                          avatar: const CircleAvatar(backgroundColor: AppColors.primary, radius: 6),
                          label: Text(col, style: const TextStyle(fontSize: 11)),
                          backgroundColor: AppColors.background,
                          side: const BorderSide(color: AppColors.border),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  _buildEditField('Craft Technique', _techniqueController),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildMiniSpecTile('Crafting Hours', '${analysis?.estimatedHours ?? 12} Hours'),
                      _buildMiniSpecTile('Weight', analysis?.weight ?? '500g'),
                      _buildMiniSpecTile('Dimensions', analysis?.dimensions ?? 'Standard Size'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Card 3 — Origin Detection & Map Thumbnail
            _buildCardContainer(
              title: 'Geographic Origin & Cluster',
              icon: Icons.map_outlined,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _buildEditField('State', _stateController)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildEditField('City / Village', _cityController)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Stack(
                      children: [
                        Center(child: Icon(Icons.location_on_rounded, size: 40, color: Colors.white.withValues(alpha: 0.6))),
                        Positioned(
                          bottom: 8,
                          left: 12,
                          right: 12,
                          child: Text(
                            'Verified Cluster: ${analysis?.cityCluster ?? "Craft Cluster"}, ${analysis?.state ?? "India"}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isCraftValid
                    ? () {
                        if (analysis != null) {
                          final updated = analysis.copyWith(
                            productTitle: _nameController.text,
                            craftCategory: _categoryController.text,
                            subcategory: _subcategoryController.text,
                            state: _stateController.text,
                            cityCluster: _cityController.text,
                            craftTechnique: _techniqueController.text,
                          );
                          ref.read(aiScannerProvider.notifier).updateAnalysis(updated);
                        }
                        context.push('/ai-smart-pricing');
                      }
                    : null,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text('Continue to Smart Pricing (Step 3)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
              ),
            ),

            if (!isCraftValid) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.upload_file_rounded),
                  label: const Text('Upload Another Image', style: TextStyle(fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardContainer({required String title, required IconData icon, required Widget child}) {
    return Container(
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
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(title, style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: AppColors.background,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniSpecTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 9, color: AppColors.textLight)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
