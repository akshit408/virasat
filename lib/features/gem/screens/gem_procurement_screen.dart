import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class GemProcurementScreen extends StatefulWidget {
  const GemProcurementScreen({super.key});

  @override
  State<GemProcurementScreen> createState() => _GemProcurementScreenState();
}

class _GemProcurementScreenState extends State<GemProcurementScreen> {
  final List<Map<String, dynamic>> _tenders = const [
    {
      'id': 'GEM/2026/B/89210',
      'dept': 'National Handloom Dev Corp (Ministry of Textiles)',
      'title': '1,000 Pochampally Ikat Silk & Cotton Shawls',
      'quantity': '1,000 Units',
      'budget': '₹ 24,00,000',
      'closingDate': '18 Apr 2026',
      'emdExemption': 'MSME / Artisan Cluster Exempted',
      'deliveryLocation': 'Handloom Pavilion, Pragati Maidan, New Delhi',
      'tag': 'GI Certified Only',
    },
    {
      'id': 'GEM/2026/B/77123',
      'dept': 'State Bank of India Corporate Admin',
      'title': '500 Handcrafted Madhubani Desk Planters',
      'quantity': '500 Units',
      'budget': '₹ 6,50,000',
      'closingDate': '25 Apr 2026',
      'emdExemption': 'Vishwakarma Card Holder Exempted',
      'deliveryLocation': 'SBI Bhavan, Nariman Point, Mumbai',
      'tag': 'ODOP Preferred',
    },
    {
      'id': 'GEM/2026/B/66432',
      'dept': 'Indian Railways Luxury Trains (IRCTC)',
      'title': '300 Carved Kashmiri Walnut Wood Serving Trays',
      'quantity': '300 Units',
      'budget': '₹ 11,20,000',
      'closingDate': '02 May 2026',
      'emdExemption': 'Artisan Cluster 100% Exempted',
      'deliveryLocation': 'IRCTC Palace on Wheels Hub, Safdarjung, New Delhi',
      'tag': 'GI Pehchan Priority',
    },
    {
      'id': 'GEM/2026/B/55198',
      'dept': 'Ministry of External Affairs (State Visits)',
      'title': '250 Bidriware Silver Inlay Keepsake Boxes',
      'quantity': '250 Units',
      'budget': '₹ 14,75,000',
      'closingDate': '12 May 2026',
      'emdExemption': 'MSME / GI Registered Exempted',
      'deliveryLocation': 'Jawaharlal Nehru Bhawan, New Delhi',
      'tag': 'Diplomatic Protocol',
    },
  ];

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
          'GeM Saras Procurement',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          TextButton.icon(
            onPressed: () => _exportToGemCatalog(context),
            icon: const Icon(Icons.cloud_upload_outlined, size: 16, color: Color(0xFF166534)),
            label: const Text('Sync GeM', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Official Portal Header Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F3A22), Color(0xFF166534)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x33166534), blurRadius: 12, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade700,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'GOVT e-MARKETPLACE',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.shield_rounded, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'GI Pehchan Verified',
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'GeM Saras Collection • Ministry of Commerce',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Priority procurement corridor for verified Indian GI artisans & craft SHGs.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Artisan Udyam: UDYAM-RJ-14-0029182', style: TextStyle(color: Colors.white, fontSize: 11)),
                        Text('GI AU: 8821/2021', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Pre-compliance Checklist Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Automated GeM Bidder Compliance',
                    style: TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 12),
                  _ComplianceRow(label: 'GI Registered User Certificate Verified', isChecked: true),
                  SizedBox(height: 8),
                  _ComplianceRow(label: 'Fair Price Minimum Wage Guarantee Active', isChecked: true),
                  SizedBox(height: 8),
                  _ComplianceRow(label: 'Quality Standard Compliance (IS 15888)', isChecked: true),
                  SizedBox(height: 8),
                  _ComplianceRow(label: 'Zero Child Labor & Ethical Cluster Certification', isChecked: true),
                  SizedBox(height: 8),
                  _ComplianceRow(label: 'Public Procurement Policy (MSE Order 2012) 25% Exemption', isChecked: true),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Live Government Tenders',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Text(
                    '${_tenders.length} Active Bids',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Tenders List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _tenders.length,
              itemBuilder: (context, idx) {
                final tender = _tenders[idx];
                return _buildTenderCard(context, tender);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTenderCard(BuildContext context, Map<String, dynamic> tender) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Color(0x0C000000), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tender['id'] as String,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF166534).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  tender['tag'] as String,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Text(
            tender['title'] as String,
            style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),

          const SizedBox(height: 4),

          Text(
            tender['dept'] as String,
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTenderStat('QUANTITY', tender['quantity'] as String),
                _buildTenderStat('EST. BUDGET', tender['budget'] as String),
                _buildTenderStat('CLOSING', tender['closingDate'] as String),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.verified_outlined, size: 14, color: Color(0xFF166534)),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  tender['emdExemption'] as String,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notice Inviting Tender (NIT) downloaded: ${tender["id"]}'),
                        backgroundColor: AppColors.secondary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Download NIT', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () => _showBidDialog(context, tender),
                  icon: const Icon(Icons.gavel_rounded, size: 16),
                  label: const Text('Submit EOI Bid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF166534),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTenderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }

  void _showBidDialog(BuildContext context, Map<String, dynamic> tender) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF166534),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Submit GeM EOI Bid',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tender: ${tender["id"]}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary)),
            const SizedBox(height: 4),
            Text('${tender["title"]}', style: const TextStyle(fontSize: 13, height: 1.3)),
            const SizedBox(height: 12),
            const Text(
              'Your pre-verified credentials will be attached automatically:',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Udyam: UDYAM-RJ-14-0029182', style: TextStyle(fontSize: 11)),
                  Text('• GI AU License: 8821/2021', style: TextStyle(fontSize: 11)),
                  Text('• Direct Bank Mandate: SBI Verified', style: TextStyle(fontSize: 11)),
                  Text('• EMD Status: 100% Fee Exempted', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Expression of Interest (EOI) submitted successfully to ${tender["dept"]}'),
                  backgroundColor: const Color(0xFF166534),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF166534), foregroundColor: Colors.white),
            child: const Text('Confirm & Sign Bid'),
          ),
        ],
      ),
    );
  }

  void _exportToGemCatalog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cloud_sync_rounded, color: Color(0xFF166534)),
            SizedBox(width: 8),
            Text('Sync to GeM Saras', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Your active catalog (25 GI-certified products) is being pushed to Government e-Marketplace (GeM) Saras Artisan Pavilion with live HSN mapping and compliant GST invoicing.',
          style: TextStyle(fontSize: 13, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Catalog successfully synchronized to GeM Saras! Catalog ID: GEM-VIRASAT-2026-9921'),
                  backgroundColor: Color(0xFF166534),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF166534), foregroundColor: Colors.white),
            child: const Text('Proceed to Sync'),
          ),
        ],
      ),
    );
  }
}

class _ComplianceRow extends StatelessWidget {
  final String label;
  final bool isChecked;
  const _ComplianceRow({required this.label, required this.isChecked});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isChecked ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: 16,
          color: isChecked ? const Color(0xFF166534) : AppColors.textLight,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
