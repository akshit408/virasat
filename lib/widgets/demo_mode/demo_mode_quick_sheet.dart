import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';

class DemoModeQuickSheet extends StatelessWidget {
  const DemoModeQuickSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const DemoModeQuickSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final flows = [
      {
        'title': 'AI Craft Scanner',
        'subtitle': 'Photo ➔ Catalog with GI Detection in 30s',
        'route': '/ai-photo-upload',
        'icon': Icons.document_scanner_rounded,
        'color': AppColors.primary,
        'badge': 'Core AI',
      },
      {
        'title': 'B2B Wholesale & RFQs',
        'subtitle': 'Corporate Bulk Sourcing & Custom Quotations',
        'route': '/b2b-marketplace',
        'icon': Icons.business_center_rounded,
        'color': const Color(0xFF1E3A8A),
        'badge': 'B2B Commerce',
      },
      {
        'title': 'Government Procurement (GeM)',
        'subtitle': 'GeM Saras Collection & One-Tap EOI Bids',
        'route': '/gem-procurement',
        'icon': Icons.account_balance_rounded,
        'color': const Color(0xFF166534),
        'badge': 'B2G Govt',
      },
      {
        'title': 'Transparent Pricing Intelligence',
        'subtitle': 'Raw Material + Labor + Regional Multiplier Breakdown',
        'route': '/ai-smart-pricing',
        'icon': Icons.analytics_rounded,
        'color': Colors.amber.shade800,
        'badge': 'Fair Trade',
      },
      {
        'title': 'VIRASAT Connect & Interactive Map',
        'subtitle': 'Workshops, Schemes, NGOs & Interactive India Map',
        'route': '/connect',
        'icon': Icons.map_rounded,
        'color': const Color(0xFF0F766E),
        'badge': 'Ecosystem',
      },
      {
        'title': 'Export Readiness & Catalog',
        'subtitle': 'HSN Codes, Drop-Test Specs & Multilingual Care',
        'route': '/export-catalog',
        'icon': Icons.public_rounded,
        'color': const Color(0xFF4338CA),
        'badge': 'Global Trade',
      },
      {
        'title': 'Voice-First AI Assistant',
        'subtitle': 'Multilingual Voice Listing & Audio Guidance',
        'route': '/ai-voice-listing',
        'icon': Icons.mic_rounded,
        'color': const Color(0xFFBE185D),
        'badge': 'Accessibility',
      },
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 44,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 14, color: Colors.white),
                    SizedBox(width: 4),
                    Text(
                      'OFFLINE DEMO MODE',
                      style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text(
            'Quick Flow Navigator',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Text(
            'Instant 1-tap jump to any demo highlight during the 3-minute video presentation.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 16),

          // Flow Cards
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: flows.length,
              separatorBuilder: (ctx, i) => const SizedBox(height: 8),
              itemBuilder: (context, idx) {
                final flow = flows[idx];
                final color = flow['color'] as Color;

                return InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    context.push(flow['route'] as String);
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(flow['icon'] as IconData, color: color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    flow['title'] as String,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      flow['badge'] as String,
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: color,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                flow['subtitle'] as String,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded, color: AppColors.textLight, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
