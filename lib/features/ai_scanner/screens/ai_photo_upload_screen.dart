import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../providers/ai_scanner_provider.dart';

class AiPhotoUploadScreen extends ConsumerStatefulWidget {
  const AiPhotoUploadScreen({super.key});

  @override
  ConsumerState<AiPhotoUploadScreen> createState() => _AiPhotoUploadScreenState();
}

class _AiPhotoUploadScreenState extends ConsumerState<AiPhotoUploadScreen> {
  @override
  Widget build(BuildContext context) {
    final scannerState = ref.watch(aiScannerProvider);
    final scannerNotifier = ref.read(aiScannerProvider.notifier);
    final imagePaths = scannerState.imagePaths;

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
          AppLocalizations.tr(context, 'ai_sell_my_craft'),
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 7-Stage Horizontal Stepper Header
            _buildSevenStageStepper(currentStage: 1),

            const SizedBox(height: 24),

            // Main Header Title
            Text(
              AppLocalizations.tr(context, 'upload_photos_title'),
              style: const TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppLocalizations.tr(context, 'upload_photos_sub'),
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),

            const SizedBox(height: 16),

            // Demo Pre-fill Crafts Selector
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: AppColors.secondary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Demo Quick Select (6 Verified GI Crafts):',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCraftChip(context, scannerNotifier, 'Blue Pottery', 'blue_pottery', Icons.palette_outlined),
                      _buildCraftChip(context, scannerNotifier, 'Bandhani', 'bandhani', Icons.texture_rounded),
                      _buildCraftChip(context, scannerNotifier, 'Ajrakh', 'ajrakh', Icons.gradient_rounded),
                      _buildCraftChip(context, scannerNotifier, 'Bamboo Basket', 'bamboo', Icons.shopping_basket_outlined),
                      _buildCraftChip(context, scannerNotifier, 'Madhubani', 'madhubani', Icons.brush_outlined),
                      _buildCraftChip(context, scannerNotifier, 'Pashmina', 'pashmina', Icons.dry_cleaning_outlined),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Image Grid with Upload Progress & Checkmarks
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1,
              ),
              itemCount: 6,
              itemBuilder: (context, idx) {
                if (idx < imagePaths.length) {
                  final path = imagePaths[idx];
                  return _buildActualImageTile(
                    context: context,
                    path: path,
                    index: idx,
                    onDelete: () => scannerNotifier.removeImage(idx),
                  );
                } else {
                  return _buildAddPhotoTile(context: context);
                }
              },
            ),

            const SizedBox(height: 24),

            // AI Tips Card
            _buildAiTipsCard(),

            const SizedBox(height: 24),
          ],
        ),
      ),

      // Sticky Bottom Navigation CTA
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: imagePaths.length >= 2
                      ? () {
                          scannerNotifier.setStep(2);
                          context.push('/ai-scanning-animation');
                        }
                      : null,
                  icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                  label: Text(
                    imagePaths.length >= 2 ? 'Run AI Scanner (Step 2 of 7)' : 'Upload At Least 2 Photos',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: Colors.grey[300],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 7-Stage Horizontal Stepper Component
  Widget _buildSevenStageStepper({required int currentStage}) {
    final stages = List.generate(
      7,
      (idx) => AppLocalizations.tr(context, 'scanner_step_${idx + 1}'),
    );

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(stages.length, (idx) {
          final stageNum = idx + 1;
          final isCurrent = stageNum == currentStage;
          final isCompleted = stageNum < currentStage;

          return Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.green
                          : isCurrent
                              ? AppColors.primary
                              : AppColors.surface,
                      border: Border.all(
                        color: isCompleted
                            ? Colors.green
                            : isCurrent
                                ? AppColors.primary
                                : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '$stageNum',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isCurrent ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stages[idx],
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 10,
                      fontWeight: isCurrent ? FontWeight.bold : FontWeight.w500,
                      color: isCurrent ? AppColors.primary : AppColors.textLight,
                    ),
                  ),
                ],
              ),
              if (idx < stages.length - 1)
                Container(
                  width: 24,
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                  color: isCompleted ? Colors.green : AppColors.border,
                ),
            ],
          );
        }),
      ),
    );
  }

  // Tile displaying actual image with upload checkmark
  Widget _buildActualImageTile({
    required BuildContext context,
    required String path,
    required int index,
    required VoidCallback onDelete,
  }) {
    final isAsset = path.startsWith('assets/');

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          children: [
            Positioned.fill(
              child: isAsset
                  ? Image.asset(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/crafts/bandhani_01.jpg',
                        fit: BoxFit.cover,
                      ),
                    )
                  : Image.file(
                      File(path),
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset(
                        'assets/images/crafts/bandhani_01.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
            ),

            // Cover Photo Tag for First Image
            if (index == 0)
              Positioned(
                top: 6,
                left: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'COVER',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

            // Success Upload Checkmark Badge (Bottom Right)
            Positioned(
              bottom: 6,
              right: 6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.white,
                ),
              ),
            ),

            // Delete Image Button (Top Right)
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, size: 12, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Add Photo Tile (Triggers Camera / Gallery Bottom Sheet)
  Widget _buildAddPhotoTile({required BuildContext context}) {
    return GestureDetector(
      onTap: () => _showAddPhotoBottomSheet(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 28),
            SizedBox(height: 4),
            Text(
              'Add Photo',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Bottom Sheet for Camera / Gallery / Demo Selection
  void _showAddPhotoBottomSheet(BuildContext context) {
    final scannerNotifier = ref.read(aiScannerProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Add Craft Photo',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt_rounded, color: AppColors.primary),
                ),
                title: const Text(
                  'Take Photo with Camera',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Capture live photo in natural studio light', style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  scannerNotifier.addImage('assets/images/crafts/bandhani_01.jpg');
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library_rounded, color: AppColors.secondary),
                ),
                title: const Text(
                  'Choose from Photo Gallery',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Select existing photos from device gallery', style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  scannerNotifier.addImage('assets/images/crafts/ajrakh_01.jpg');
                },
              ),
              const Divider(),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bolt_rounded, color: Colors.green),
                ),
                title: const Text(
                  'Load Sample Craft',
                  style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
                ),
                subtitle: const Text('Load pre-configured Bandhani Saree dataset', style: TextStyle(fontSize: 11)),
                onTap: () {
                  Navigator.pop(context);
                  scannerNotifier.loadSampleCraft('bandhani');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // AI Tips Card
  Widget _buildAiTipsCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: AppColors.secondary, size: 20),
              SizedBox(width: 8),
              Text(
                'AI Tips for Maximum Accuracy',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildTipRow(Icons.wb_sunny_outlined, 'Bright Natural Light: Avoid dark rooms or harsh flash shadows.'),
          _buildTipRow(Icons.crop_square_rounded, 'Neutral Background: Place craft on a white sheet or plain wooden surface.'),
          _buildTipRow(Icons.zoom_in_rounded, 'Weave & Pattern Close-Up: Include 1 close-up of intricate threadwork or knots.'),
          _buildTipRow(Icons.flip_rounded, 'Full Product Angle: Capture full layout to let AI estimate measurements.'),
        ],
      ),
    );
  }

  Widget _buildTipRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 11.5,
                color: AppColors.textSecondary,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCraftChip(BuildContext context, AIScannerNotifier notifier, String label, String key, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 14, color: AppColors.primaryTerracotta),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.border),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      onPressed: () {
        notifier.loadSampleCraft(key);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Loaded authentic $label photos!'),
            backgroundColor: AppColors.secondary,
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
