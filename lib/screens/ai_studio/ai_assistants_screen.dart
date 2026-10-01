import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class AiAssistantsScreen extends StatelessWidget {
  const AiAssistantsScreen({super.key});

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
          'AI Assistant Suite',
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
            // Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 40),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Empowering Artisans with AI',
                          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '5 specialized AI tools designed to generate craft listings, fair prices & stories effortlessly.',
                          style: TextStyle(fontSize: 11, color: Colors.white70, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text(
              'Select AI Assistant Tool',
              style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 14),

            _buildToolCard(
              context: context,
              title: 'AI Product Visual Scanner',
              subtitle: 'Scan photo to detect weave pattern, GI status & craft tags',
              icon: Icons.camera_enhance_outlined,
              color: AppColors.primary,
              onTap: () => context.push('/sell-my-craft'),
            ),
            _buildToolCard(
              context: context,
              title: 'Fair Trade Smart Pricing',
              subtitle: 'Calculate labor hours & material valuation for fair payouts',
              icon: Icons.calculate_outlined,
              color: AppColors.secondary,
              onTap: () => context.push('/sell-my-craft'),
            ),
            _buildToolCard(
              context: context,
              title: 'Heritage Story Generator',
              subtitle: 'Evocative origin narrative in 8 Indian regional languages',
              icon: Icons.history_edu_rounded,
              color: AppColors.success,
              onTap: () => context.push('/sell-my-craft'),
            ),
            _buildToolCard(
              context: context,
              title: 'Vernacular Voice Translator',
              subtitle: 'Speak in native dialect to auto-transcribe listing specs',
              icon: Icons.record_voice_over_outlined,
              color: AppColors.accent,
              onTap: () => context.push('/sell-my-craft'),
            ),
            _buildToolCard(
              context: context,
              title: 'Craft Studio Image Enhancer',
              subtitle: 'Background removal & studio lighting enhancement',
              icon: Icons.auto_fix_high_rounded,
              color: Colors.amber.shade800,
              onTap: () => context.push('/sell-my-craft'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.15), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textLight),
        onTap: onTap,
      ),
    );
  }
}
