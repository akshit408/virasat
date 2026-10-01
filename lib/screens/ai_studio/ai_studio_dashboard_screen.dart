import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AiStudioDashboardScreen extends StatelessWidget {
  const AiStudioDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Virasat AI Studio Suite 🤖', showBack: false),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Smart AI Tools for Indian Artisans',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontFamily: 'Playfair Display',
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Created specifically for craftspeople to automate professional listings, market pricing & storytelling.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            _studioCard(
              title: 'AI Image Enhancer Studio 📸',
              subtitle: 'Remove clutter, generate white studio backgrounds & sharpen details.',
              color: AppColors.primary,
              icon: Icons.photo_filter_rounded,
              onTap: () => context.push('/ai-studio/image-enhancer'),
            ),
            const SizedBox(height: 16),
            _studioCard(
              title: 'Multilingual Voice Catalog 🎙️',
              subtitle: 'Speak in Hindi, Gujarati, Tamil etc. to auto-generate English descriptions & SEO tags.',
              color: AppColors.secondary,
              icon: Icons.mic_rounded,
              onTap: () => context.push('/ai-studio/voice-catalog'),
            ),
            const SizedBox(height: 16),
            _studioCard(
              title: 'AI Pricing Intelligence Assistant 💡',
              subtitle: 'Calculate fair artisan wages, material costs & recommended marketplace price ranges.',
              color: AppColors.success,
              icon: Icons.calculate_outlined,
              onTap: () => context.push('/ai-studio/pricing-assistant'),
            ),
            const SizedBox(height: 16),
            _studioCard(
              title: 'Heritage Craft Story Generator 📜',
              subtitle: 'Generate rich cultural narratives connecting your craft with ancient Indian state traditions.',
              color: AppColors.accent,
              icon: Icons.menu_book_rounded,
              onTap: () => context.push('/ai-studio/story-generator'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studioCard({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: color,
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
