import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ai_scanner_provider.dart';
import '../../../core/theme/app_colors.dart';

class AIImageEnhancementScreen extends ConsumerStatefulWidget {
  const AIImageEnhancementScreen({super.key});

  @override
  ConsumerState<AIImageEnhancementScreen> createState() => _AIImageEnhancementScreenState();
}

class _AIImageEnhancementScreenState extends ConsumerState<AIImageEnhancementScreen> {
  double _splitRatio = 0.5;
  String _selectedBgStyle = 'Studio White';
  String _selectedCropRatio = '4:5 (Marketplace)';

  final List<String> _bgOptions = ['Studio White', 'Heritage Silk', 'Original'];
  final List<String> _cropOptions = ['1:1 (Square)', '4:5 (Marketplace)', '9:16 (Story)'];

  Widget _buildCraftImage(String path, {BoxFit fit = BoxFit.contain, Widget Function(BuildContext, Object, StackTrace?)? errorBuilder}) {
    if (path.startsWith('assets/')) {
      return Image.asset(path, fit: fit, errorBuilder: errorBuilder);
    } else {
      return Image.file(File(path), fit: fit, errorBuilder: errorBuilder);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(aiScannerProvider);
    final scannerNotifier = ref.read(aiScannerProvider.notifier);
    final analysis = scannerState.analysis;
    final activePath = scannerState.imagePaths.isNotEmpty
        ? scannerState.imagePaths.first
        : (analysis?.imagePath ?? 'assets/images/crafts/bandhani_01.jpg');

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Photo Studio Enhancement',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Step 8 of 10 — Studio Quality',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryGold.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primaryGold.withValues(alpha: 0.4)),
            ),
            child: const Row(
              children: [
                Icon(Icons.auto_fix_high, size: 14, color: AppColors.primaryGold),
                SizedBox(width: 4),
                Text(
                  'Auto HD',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Before / After Comparison Canvas
            Container(
              height: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    // Enhanced Background / Base Image
                    Positioned.fill(
                      child: Container(
                        color: _selectedBgStyle == 'Studio White'
                            ? Colors.white
                            : _selectedBgStyle == 'Heritage Silk'
                                ? const Color(0xFFFBF6EF)
                                : Colors.grey[200],
                        child: Center(
                          child: _buildCraftImage(
                            activePath,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Image.asset(
                              'assets/images/crafts/bandhani_01.jpg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Before Overlay (Original side)
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      width: MediaQuery.of(context).size.width * _splitRatio,
                      child: ClipRect(
                        child: Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                Colors.black.withValues(alpha: 0.15),
                                BlendMode.darken,
                              ),
                              child: _buildCraftImage(
                                activePath,
                                fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Image.asset(
                                  'assets/images/crafts/bandhani_01.jpg',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Split Divider Line
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: (MediaQuery.of(context).size.width - 32) * _splitRatio - 1.5,
                      child: Container(
                        width: 3,
                        color: AppColors.primaryGold,
                      ),
                    ),

                    // Split Handle Button
                    Positioned(
                      top: 140,
                      left: (MediaQuery.of(context).size.width - 32) * _splitRatio - 18,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            final width = MediaQuery.of(context).size.width - 32;
                            _splitRatio = (_splitRatio + details.delta.dx / width).clamp(0.1, 0.9);
                          });
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryGold,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.unfold_more,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),

                    // Labels
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'BEFORE (RAW)',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGold,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'AFTER (AI STUDIO)',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Controls Section Title
            const Text(
              'AI Studio Enhancement Options',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // Toggle Switches Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    activeThumbColor: AppColors.primaryGold,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'AI Background Removal & White Studio',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Replaces cluttered home background with studio white',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: scannerState.bgRemoved,
                    onChanged: (val) => scannerNotifier.toggleBgRemoved(),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeThumbColor: AppColors.primaryGold,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Smart Studio Lighting & Shadows',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Normalizes indoor lighting & adds realistic craft shadow',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: scannerState.lightingImproved,
                    onChanged: (val) => scannerNotifier.toggleLighting(),
                  ),
                  const Divider(),
                  SwitchListTile(
                    activeThumbColor: AppColors.primaryGold,
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Texture & Craft Sharpening',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: const Text(
                      'Highlights intricate threadwork, paint details & weave lines',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    value: scannerState.isSharp,
                    onChanged: (val) {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Background Style Selector
            const Text(
              'Background Canvas Style',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _bgOptions.map((bg) {
                final isSelected = _selectedBgStyle == bg;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedBgStyle = bg),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryTerracotta.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryTerracotta
                              : AppColors.cardBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          bg,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primaryTerracotta
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Crop Ratios
            const Text(
              'Marketplace Crop Ratio',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: _cropOptions.map((crop) {
                final isSelected = _selectedCropRatio == crop;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedCropRatio = crop),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGold.withValues(alpha: 0.1)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGold : AppColors.cardBorder,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          crop,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 11,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? AppColors.primaryGold : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Navigation CTA
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  scannerNotifier.setStep(9);
                  context.push('/ai-product-preview');
                },
                icon: const Icon(Icons.preview, color: Colors.white),
                label: const Text(
                  'Continue to Final Marketplace Preview',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTerracotta,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
