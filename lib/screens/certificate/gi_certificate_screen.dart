import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/gi_product_model.dart';

class GiCertificateScreen extends StatelessWidget {
  final GiProductModel craft;

  const GiCertificateScreen({
    super.key,
    required this.craft,
  });

  @override
  Widget build(BuildContext context) {
    final giRegistryNumber = 'GI-IND-2026-${craft.id.toUpperCase().replaceAll('-', '')}';

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7),
      appBar: AppBar(
        title: const Text(
          'GI Authenticity Certificate',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Downloading official GI Authenticity Certificate PDF...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Download PDF',
          ),
          IconButton(
            icon: const Icon(Icons.share_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Certificate verification link copied to clipboard!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            tooltip: 'Share Certificate',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFD4AF37), width: 3), // Gold Border
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F6D3B28),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Header Seal & Emblem
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF6F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xFFD4AF37),
                        size: 36,
                      ),
                    ),
                    Column(
                      children: [
                        const Text(
                          'GOVERNMENT OF INDIA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            color: Color(0xFF6D3B28),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'GI REGISTRY • INTELLECTUAL PROPERTY',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFAF6F0),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                const Divider(color: Color(0xFFD4AF37), thickness: 1),
                const SizedBox(height: 16),

                // Certificate Title
                const Text(
                  'CERTIFICATE OF GEOGRAPHICAL INDICATION AUTHENTICITY',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'This document certifies that the handicraft product described below originates from the registered geographical cluster and adheres to traditional craft standards.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.4,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 24),

                // Product Details Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFBF7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow('Product Name', craft.name, isBold: true),
                      const SizedBox(height: 10),
                      _buildInfoRow('GI Registration No.', giRegistryNumber, isGold: true),
                      const SizedBox(height: 10),
                      _buildInfoRow('Craft Category', craft.category),
                      const SizedBox(height: 10),
                      _buildInfoRow('State of Origin', craft.stateName),
                      const SizedBox(height: 10),
                      _buildInfoRow('District / Village', craft.district.isNotEmpty ? craft.district : 'Craft Cluster'),
                      const SizedBox(height: 10),
                      _buildInfoRow('GI Recognition Year', craft.giTagYear > 0 ? '${craft.giTagYear}' : '2004 (GI Act 1999)'),
                      const SizedBox(height: 10),
                      _buildInfoRow('Master Artisan', craft.artisanName),
                      const SizedBox(height: 10),
                      _buildInfoRow('Cooperative / SHG', craft.cooperativeName),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // QR Code & Verification Stamp
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black26),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(Icons.qr_code_2_rounded, size: 68, color: Colors.black),
                              Container(
                                width: 20,
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check, size: 14, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Scan to Verify QR',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                            color: const Color(0xFFFAF6F0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.stars_rounded, color: Color(0xFFD4AF37), size: 28),
                              SizedBox(height: 2),
                              Text(
                                'OFFICIAL',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF6D3B28)),
                              ),
                              Text(
                                'VERIFIED',
                                style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Digital Stamp',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Back to Product Details', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, bool isGold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold || isGold ? FontWeight.bold : FontWeight.w600,
              color: isGold ? const Color(0xFFB55239) : AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}
