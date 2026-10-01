import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class ExportCatalogScreen extends StatefulWidget {
  const ExportCatalogScreen({super.key});

  @override
  State<ExportCatalogScreen> createState() => _ExportCatalogScreenState();
}

class _ExportCatalogScreenState extends State<ExportCatalogScreen> {
  int _selectedProductIndex = 0;

  final List<Map<String, dynamic>> _exportProducts = const [
    {
      'name': 'Jaipur Blue Pottery Floral Vase',
      'hsn': '6912.00.10',
      'giTag': 'GI-Rajasthan-02',
      'dimensionsCm': '25 x 12 x 12 cm',
      'dimensionsIn': '9.8 x 4.7 x 4.7 in',
      'netWeight': '850 g',
      'grossWeight': '1,250 g',
      'packaging': 'Drop-tested 5-ply corrugated carton with honeycomb foam inserts & silica desiccants.',
      'originLabel': 'HANDCRAFTED IN INDIA • REGISTERED GEOGRAPHICAL INDICATION #RJ-BP-02',
      'priceInr': '₹ 3,200',
      'priceUsd': '\$ 38.50',
      'priceEur': '€ 35.80',
      'care': {
        'EN': 'Hand wash with mild soapy water. Avoid abrasive scrubbers.',
        'FR': 'Laver délicatement à la main avec de l\'eau tiède savonneuse.',
        'DE': 'Vorsichtig von Hand mit milder Seifenlauge reinigen.',
        'JA': '中性洗剤を使用し、柔らかいスポンジで手洗いしてください。',
      },
    },
    {
      'name': 'Kashmir Pashmina Handspun Shawl',
      'hsn': '6214.20.20',
      'giTag': 'GI-JK-01',
      'dimensionsCm': '200 x 70 cm',
      'dimensionsIn': '78.7 x 27.5 in',
      'netWeight': '180 g',
      'grossWeight': '350 g',
      'packaging': 'Silk-lined archival gift box, anti-moth organic cedar block, cellophane barrier.',
      'originLabel': '100% PURE CHANGTHANGI CASHMERE • GI PEHCHAN CERTIFIED #JK-PS-01',
      'priceInr': '₹ 18,500',
      'priceUsd': '\$ 225.00',
      'priceEur': '€ 210.00',
      'care': {
        'EN': 'Dry clean only. Store folded in breathable cotton bags.',
        'FR': 'Nettoyage à sec uniquement. Conserver plié dans une housse en coton.',
        'DE': 'Nur chemische Reinigung. Gefaltet in einem Baumwollbeutel aufbewahren.',
        'JA': 'ドライクリーニングのみ。通気性の良い布袋に保管してください。',
      },
    },
    {
      'name': 'Madhubani Kohbar Tree of Life',
      'hsn': '9701.10.10',
      'giTag': 'GI-Bihar-01',
      'dimensionsCm': '60 x 45 cm',
      'dimensionsIn': '23.6 x 17.7 in',
      'netWeight': '320 g',
      'grossWeight': '750 g',
      'packaging': 'Heavy-duty telescopic rigid mailing tube with acid-free glassine wrapping.',
      'originLabel': 'AUTHENTIC MITHILA FOLK ART • GI AUTHENTICATED USER #BR-MB-01',
      'priceInr': '₹ 4,800',
      'priceUsd': '\$ 58.00',
      'priceEur': '€ 54.00',
      'care': {
        'EN': 'Keep away from direct prolonged sunlight and excessive humidity.',
        'FR': 'Garder à l\'abri de la lumière directe du soleil et de l\'humidité.',
        'DE': 'Vor direkter Sonneneinstrahlung und hoher Luftfeuchtigkeit schützen.',
        'JA': '直射日光や湿気の多い場所を避けて保管・展示してください。',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final prod = _exportProducts[_selectedProductIndex];
    final care = prod['care'] as Map<String, String>;

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
          'Export Readiness & Catalog',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Export dossier link copied for international buyers'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Export Readiness Header Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF172554)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x331E3A8A), blurRadius: 10, offset: Offset(0, 4)),
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
                          color: const Color(0xFF166534),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'GLOBAL EXPORT STANDARDS',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.public_rounded, color: Colors.white70, size: 16),
                      const SizedBox(width: 4),
                      const Text('DGFT Compliant', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Multi-Jurisdiction Export Dossier',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Automated HSN Harmonization, Multilingual Care Labels & Drop-Test Certification.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Product Selector Tabs
            const Text(
              'Select Product for Export Dossier',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_exportProducts.length, (idx) {
                  final isSelected = _selectedProductIndex == idx;
                  final p = _exportProducts[idx];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      label: Text(
                        p['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                      onSelected: (val) {
                        setState(() => _selectedProductIndex = idx);
                      },
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 16),

            // International Pricing Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Recommended Export Pricing (FOB / CIF Ready)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildPriceBadge('DOMESTIC (INR)', prod['priceInr'] as String, AppColors.primary),
                      _buildPriceBadge('USA / GLOBAL (USD)', prod['priceUsd'] as String, const Color(0xFF166534)),
                      _buildPriceBadge('EUROPE (EUR)', prod['priceEur'] as String, const Color(0xFF1E3A8A)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Technical Specifications Grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Technical Specifications',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFF166534).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'HSN: ${prod["hsn"]}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildSpecRow('GI Registration No.', prod['giTag'] as String),
                  const SizedBox(height: 8),
                  _buildSpecRow('Dimensions (Metric)', prod['dimensionsCm'] as String),
                  const SizedBox(height: 8),
                  _buildSpecRow('Dimensions (Imperial)', prod['dimensionsIn'] as String),
                  const SizedBox(height: 8),
                  _buildSpecRow('Net Weight / Gross Weight', '${prod["netWeight"]} / ${prod["grossWeight"]}'),
                  const SizedBox(height: 8),
                  _buildSpecRow('Export Packaging', prod['packaging'] as String),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Country of Origin Label Preview
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.label_outline_rounded, size: 16, color: AppColors.primary),
                      SizedBox(width: 6),
                      Text('Country-of-Origin Label Preview', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    prod['originLabel'] as String,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Multilingual Care Instructions (4 Languages)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Multilingual Care Instructions (4 Languages)',
                    style: TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 12),
                  _buildCareRow('🇺🇸 English', care['EN'] ?? ''),
                  const SizedBox(height: 8),
                  _buildCareRow('🇫🇷 Français', care['FR'] ?? ''),
                  const SizedBox(height: 8),
                  _buildCareRow('🇩🇪 Deutsch', care['DE'] ?? ''),
                  const SizedBox(height: 8),
                  _buildCareRow('🇯🇵 日本語', care['JA'] ?? ''),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Download Catalog Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Export Specification Dossier (PDF) generated for ${prod["name"]}'),
                      backgroundColor: const Color(0xFF166534),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                icon: const Icon(Icons.file_download_rounded),
                label: const Text('Download Export Catalog PDF (EPCH Standard)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBadge(String label, String price, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        const SizedBox(height: 4),
        Text(
          price,
          style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  Widget _buildSpecRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary, height: 1.3)),
      ],
    );
  }

  Widget _buildCareRow(String lang, String instruction) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(lang, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary)),
          const SizedBox(height: 2),
          Text(instruction, style: const TextStyle(fontSize: 12, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
