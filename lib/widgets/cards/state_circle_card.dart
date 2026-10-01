import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/state_helper.dart';


/// Premium Reusable Circular State Card with Craft Image & Terracotta Badge
class StateCircleCard extends StatefulWidget {
  final String number;
  final String stateName;
  final String imagePath;
  final String? subtitle;
  final VoidCallback onTap;

  const StateCircleCard({
    super.key,
    required this.number,
    required this.stateName,
    required this.imagePath,
    this.subtitle,
    required this.onTap,
  });

  @override
  State<StateCircleCard> createState() => _StateCircleCardState();
}

class _StateCircleCardState extends State<StateCircleCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final fullName = getStateFullName(widget.stateName);
    final craftSub = widget.subtitle ?? getStateCraftSubtitle(widget.stateName);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? 0.94 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: Container(
          width: 90,
          margin: const EdgeInsets.only(right: 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Stack with Circular Image, Cream Border, and Terracotta Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  // Circular Image Container with Soft Shadow & Thin Cream Border
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFFDF9), // Ivory/Cream border
                        width: 2.5,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.cover,
                        width: 82,
                        height: 82,
                        errorBuilder: (_, __, ___) => Image.asset(
                          getStateImagePath(widget.stateName),
                          fit: BoxFit.cover,
                          width: 82,
                          height: 82,
                        ),
                      ),
                    ),
                  ),

                  // Terracotta Number Badge Overlapping Top-Left
                  Positioned(
                    top: -2,
                    left: -2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTerracotta, // Terracotta Accent
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.number,
                        style: const TextStyle(
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
              const SizedBox(height: 6),
              // State Name & Subtitle
              SizedBox(
                height: 44,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      fullName,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      craftSub,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTerracotta,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 250.ms, curve: Curves.easeOut);
  }
}
