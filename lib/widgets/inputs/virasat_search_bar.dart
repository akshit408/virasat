import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class VirasatSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onVoiceTap;
  final VoidCallback? onFilterTap;
  final String hintText;

  const VirasatSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onVoiceTap,
    this.onFilterTap,
    this.hintText = 'Search crafts, artisans, state heritage...',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onVoiceTap != null)
                IconButton(
                  icon: const Icon(Icons.mic_rounded, color: AppColors.primary),
                  onPressed: onVoiceTap,
                  tooltip: 'Voice Search',
                ),
              if (onFilterTap != null)
                IconButton(
                  icon: const Icon(Icons.tune_rounded, color: AppColors.textPrimary),
                  onPressed: onFilterTap,
                  tooltip: 'Filter',
                ),
            ],
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
