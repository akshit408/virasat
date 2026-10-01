import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import 'demo_mode_quick_sheet.dart';

class DemoModePill extends StatefulWidget {
  const DemoModePill({super.key});

  @override
  State<DemoModePill> createState() => _DemoModePillState();
}

class _DemoModePillState extends State<DemoModePill> {
  bool _isMinimized = false;

  @override
  Widget build(BuildContext context) {
    if (_isMinimized) {
      return Positioned(
        top: 48,
        right: 12,
        child: Material(
          elevation: 6,
          shape: const CircleBorder(),
          color: AppColors.primary,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => setState(() => _isMinimized = false),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
            ),
          ),
        ),
      );
    }

    return Positioned(
      top: 44,
      left: 16,
      right: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFA63E24), Color(0xFF6B2211)],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.amber.withValues(alpha: 0.6), width: 1.2),
            boxShadow: const [
              BoxShadow(
                color: Color(0x4DA63E24),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt_rounded, size: 14, color: Color(0xFFA63E24)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () => DemoModeQuickSheet.show(context),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'OFFLINE DEMO MODE',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.touch_app_rounded, size: 12, color: Colors.white70),
                        ],
                      ),
                      Text(
                        'Tap for Quick Flows (6 Highlights)',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.close_rounded, size: 16, color: Colors.white70),
                onPressed: () => setState(() => _isMinimized = true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
