import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';

class HomeCollectionPillsWidget extends StatelessWidget {
  const HomeCollectionPillsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Title
          const Text(
            "Celebrate India's Living Heritage",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontFamily: 'Playfair Display',
            ),
          ),
          const SizedBox(height: 6),
          // Subtitle Bullet Stats
          const Text(
            "500+ Verified Artisans • 300+ GI Crafts • Across India",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          // Description
          const Text(
            "Explore authentic crafts from artisans near you.",
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          // Horizontal Scrollable Collection Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildCollectionPill(
                  context,
                  label: 'Navratri Collection',
                  slug: 'navratri',
                  textColor: const Color(0xFFD97706),
                  bgColor: const Color(0xFFD97706).withValues(alpha: 0.12),
                  borderColor: const Color(0xFFD97706).withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                _buildCollectionPill(
                  context,
                  label: 'Diwali Crafts',
                  slug: 'diwali',
                  textColor: const Color(0xFF059669),
                  bgColor: const Color(0xFF059669).withValues(alpha: 0.12),
                  borderColor: const Color(0xFF059669).withValues(alpha: 0.4),
                ),
                const SizedBox(width: 10),
                _buildCollectionPill(
                  context,
                  label: 'GI Heritage Collection',
                  slug: 'gi-heritage',
                  textColor: const Color(0xFF1D4ED8),
                  bgColor: const Color(0xFF1D4ED8).withValues(alpha: 0.12),
                  borderColor: const Color(0xFF1D4ED8).withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionPill(
    BuildContext context, {
    required String label,
    required String slug,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.push('/collection/$slug'),
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}
