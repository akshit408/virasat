import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/ai_scanner_provider.dart';

class AiSmartPricingScreen extends ConsumerStatefulWidget {
  const AiSmartPricingScreen({super.key});

  @override
  ConsumerState<AiSmartPricingScreen> createState() => _AiSmartPricingScreenState();
}

class _AiSmartPricingScreenState extends ConsumerState<AiSmartPricingScreen> {
  double _artisanPrice = 0.0;
  bool _initialized = false;

  void _initPricingIfNeeded() {
    if (_initialized) return;
    final analysis = ref.read(aiScannerProvider).analysis;
    if (analysis != null) {
      final base = analysis.suggestedPrice > 0
          ? analysis.suggestedPrice
          : ((analysis.materialCost + analysis.laborCost) > 0
              ? (analysis.materialCost + analysis.laborCost) * 1.35
              : 1500.0);
      _artisanPrice = base.clamp(100.0, 500000.0);
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    _initPricingIfNeeded();

    final scannerState = ref.watch(aiScannerProvider);
    final analysis = scannerState.analysis;

    if (analysis == null) {
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
            AppLocalizations.tr(context, 'fair_pricing'),
            style: const TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.warning_amber_rounded, size: 56, color: Colors.orange),
                const SizedBox(height: 16),
                const Text(
                  'AI analysis unavailable. Retry Analysis.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => context.pop(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Retry Analysis'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final matCost = analysis.materialCost > 0 ? analysis.materialCost : (_artisanPrice * 0.30);
    final laborCost = analysis.laborCost > 0 ? analysis.laborCost : (_artisanPrice * 0.50);

    final platformFee = _artisanPrice * 0.09;
    final shippingFee = _artisanPrice * 0.07;
    final buyerPrice = _artisanPrice + platformFee + shippingFee;

    final directPercent = buyerPrice > 0 ? ((_artisanPrice / buyerPrice) * 100).round() : 84;

    final confPercent = (analysis.confidence > 1.0 ? analysis.confidence : analysis.confidence * 100).toInt();

    final minPrice = (matCost + laborCost).clamp(100.0, 500000.0);
    final maxPrice = (minPrice * 4.0).clamp(minPrice + 1000.0, 500000.0);

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
          AppLocalizations.tr(context, 'fair_pricing'),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Craft Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 14, color: AppColors.primary),
                            SizedBox(width: 4),
                            Text(
                              'AI Detected Craft',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF166534).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$confPercent% Confidence',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    analysis.productName,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        '${analysis.city}, ${analysis.state}',
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // AI Analysis Section Header & 2x2 Grid
            const Text(
              'AI Analysis',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridInfoTile(
                          'Raw Materials',
                          analysis.materials.isNotEmpty ? analysis.materials.join(', ') : 'Natural Eco Materials',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGridInfoTile(
                          'Technique',
                          analysis.technique,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridInfoTile(
                          'Estimated Artisan Hours',
                          '${analysis.estimatedHours} Hours',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGridInfoTile(
                          'Craft Category',
                          analysis.category,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Fair Trade Pricing Section Header & 2x2 Grid
            const Text(
              'Fair Trade Pricing',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridPriceTile(
                          'Material Cost',
                          '₹ ${matCost.toStringAsFixed(0)}',
                          textColor: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGridPriceTile(
                          'Labor Cost',
                          '₹ ${laborCost.toStringAsFixed(0)}',
                          textColor: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildGridPriceTile(
                          'Artisan Selling Price',
                          '₹ ${_artisanPrice.toStringAsFixed(0)}',
                          textColor: const Color(0xFFEA580C),
                          isHighlight: true,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildGridPriceTile(
                          'Buyer Price',
                          '₹ ${buyerPrice.toStringAsFixed(0)}',
                          textColor: const Color(0xFF166534),
                          isHighlight: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Green Direct Artisan Earnings Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF166534)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle_rounded, color: Color(0xFF166534), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '$directPercent% • ₹${_artisanPrice.toStringAsFixed(0)} goes directly to the artisan. Platform fee (9%) and insured shipping (7%) are calculated separately.',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF166534),
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Price Customizer Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Adjust Artisan Price:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                ),
                Text(
                  '₹ ${_artisanPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFFEA580C)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Slider(
              value: _artisanPrice.clamp(minPrice, maxPrice),
              min: minPrice,
              max: maxPrice,
              divisions: 100,
              activeColor: AppColors.primary,
              onChanged: (val) {
                setState(() {
                  _artisanPrice = val;
                });
              },
            ),

            const SizedBox(height: 24),

            // Action Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final updated = analysis.copyWith(
                    suggestedPrice: _artisanPrice,
                    materialCost: matCost,
                    laborCost: laborCost,
                    suggestedWholesalePrice: (_artisanPrice * 0.70).roundToDouble(),
                  );
                  ref.read(aiScannerProvider.notifier).updateAnalysis(updated);
                  context.push('/ai-heritage-story');
                },
                icon: const Icon(Icons.arrow_forward_rounded),
                label: const Text(
                  'Continue to Heritage Story (Step 4)',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
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

  Widget _buildGridInfoTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildGridPriceTile(String label, String value, {required Color textColor, bool isHighlight = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isHighlight ? textColor.withValues(alpha: 0.08) : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: isHighlight ? Border.all(color: textColor.withValues(alpha: 0.3)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.textLight, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textColor),
          ),
        ],
      ),
    );
  }
}

