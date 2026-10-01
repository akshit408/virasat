import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/auth_guard.dart';
import '../providers/ai_scanner_provider.dart';

class AiScannerHomeScreen extends ConsumerWidget {
  const AiScannerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'AI Product Scanner',
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
            // Hero Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33B55239),
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'SIGNATURE AI FEATURE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.1,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 24),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Create AI Listing in 60 Seconds',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Upload photos of your handmade craft and VIRASAT AI will detect materials, state origin, fair price, and heritage story.',
                    style: TextStyle(fontSize: 13, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final ok = await ensureAuthenticated(
                              context,
                              ref,
                              title: 'Authentication Required',
                              message: 'Please log in to use AI Sell My Craft and create product listings.',
                            );
                            if (!ok || !context.mounted) return;
                            ref.read(aiScannerProvider.notifier).reset();
                            context.push('/ai-photo-upload');
                          },
                          icon: const Icon(Icons.camera_alt_outlined, size: 18),
                          label: const Text('Take Photos', style: TextStyle(fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.secondary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final ok = await ensureAuthenticated(
                              context,
                              ref,
                              title: 'Authentication Required',
                              message: 'Please log in to use AI Sell My Craft and create product listings.',
                            );
                            if (!ok || !context.mounted) return;
                            ref.read(aiScannerProvider.notifier).reset();
                            context.push('/ai-photo-upload');
                          },
                          icon: const Icon(Icons.photo_library_outlined, size: 18, color: Colors.white),
                          label: const Text('Gallery', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            side: const BorderSide(color: Colors.white54),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0),

            const SizedBox(height: 32),

            // How AI Works 3-Step Infographic
            const Text(
              'How AI Product Scanner Works',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 14),

            _buildInfographicStep(
              stepNum: '1',
              title: 'Upload Craft Photos',
              subtitle: 'Select 2 to 5 photos from camera or gallery. No text typing required.',
              icon: Icons.add_a_photo_outlined,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            _buildInfographicStep(
              stepNum: '2',
              title: 'Cinematic AI Vision Scan',
              subtitle: 'AI detects weave structure, GI certification status, materials, state origin, and price valuation.',
              icon: Icons.auto_awesome_rounded,
              color: AppColors.secondary,
            ),
            const SizedBox(height: 12),
            _buildInfographicStep(
              stepNum: '3',
              title: 'Review & Publish Live',
              subtitle: 'Review AI-generated heritage story, multilingual preview, and publish live to Artisan India.',
              icon: Icons.rocket_launch_outlined,
              color: AppColors.success,
            ),

            const SizedBox(height: 32),

            // Instant Launch Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final ok = await ensureAuthenticated(
                    context,
                    ref,
                    title: 'Authentication Required',
                    message: 'Please log in to use AI Sell My Craft and create product listings.',
                  );
                  if (!ok || !context.mounted) return;
                  ref.read(aiScannerProvider.notifier).reset();
                  context.push('/ai-photo-upload');
                },
                icon: const Icon(Icons.bolt_rounded),
                label: const Text('Start 60-Second AI Scanner', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildInfographicStep({
    required String stepNum,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                stepNum,
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold, color: color),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
