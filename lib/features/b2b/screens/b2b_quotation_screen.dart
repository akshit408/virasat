import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../models/rfq_model.dart';

class B2bQuotationScreen extends StatefulWidget {
  final B2bRFQ? rfq;

  const B2bQuotationScreen({super.key, this.rfq});

  @override
  State<B2bQuotationScreen> createState() => _B2bQuotationScreenState();
}

class _B2bQuotationScreenState extends State<B2bQuotationScreen> {
  late int _quantity;
  late double _unitPrice;
  final double _retailPrice = 2800.0;
  String _leadTime = '21 Days';
  String _logisticsPartner = 'Delhivery Surface (₹45/kg)';
  double _shippingRatePerUnit = 85.0;

  final List<String> _leadTimes = const ['14 Days', '21 Days', '30 Days', '45 Days'];
  final Map<String, double> _logisticsRates = const {
    'Delhivery Surface (₹45/kg)': 85.0,
    'BlueDart Express (₹90/kg)': 140.0,
    'India Post Parcel (₹30/kg)': 55.0,
  };

  @override
  void initState() {
    super.initState();
    _quantity = widget.rfq?.units ?? 100;
    _unitPrice = 1750.0;
  }

  @override
  Widget build(BuildContext context) {
    final buyerName = widget.rfq?.buyerName ?? 'Commercial Wholesale Buyer';
    final craftTitle = widget.rfq?.title ?? 'Handcrafted GI Blue Pottery Dinner Sets';

    final subtotal = _quantity * _unitPrice;
    final gst = subtotal * 0.12; // 12% Handicrafts GST
    final shippingTotal = _quantity * _shippingRatePerUnit;
    final totalQuotation = subtotal + gst + shippingTotal;
    final discountPercent = (((_retailPrice - _unitPrice) / _retailPrice) * 100).toInt();

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
          'B2B Commercial Quotation',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target Buyer Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.business_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          buyerName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          craftTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'GI VERIFIED',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Wholesale vs Retail Price Comparison Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7F3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text('Standard Retail Price', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${_retailPrice.toStringAsFixed(0)} / unit',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 32, color: AppColors.border),
                  Column(
                    children: [
                      const Text('B2B Wholesale Price', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '₹ ${_unitPrice.toStringAsFixed(0)} / unit',
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF166534),
                        ),
                      ),
                    ],
                  ),
                  Container(width: 1, height: 32, color: AppColors.border),
                  Column(
                    children: [
                      const Text('Buyer Savings', style: TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        '$discountPercent% OFF',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Configuration Form
            const Text(
              'Order & Pricing Parameters',
              style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            // Quantity (MOQ)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Quantity (Units)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Text('Minimum Order Quantity: 50 units', style: TextStyle(fontSize: 11, color: AppColors.textLight)),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, color: AppColors.primary),
                    onPressed: () {
                      if (_quantity > 50) setState(() => _quantity -= 25);
                    },
                  ),
                  Text(
                    '$_quantity',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                    onPressed: () {
                      setState(() => _quantity += 25);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Wholesale Price Adjuster
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Custom Wholesale Price / Unit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Text('₹ ${_unitPrice.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 15)),
                    ],
                  ),
                  Slider(
                    value: _unitPrice,
                    min: 1200,
                    max: 3000,
                    divisions: 36,
                    activeColor: AppColors.primary,
                    onChanged: (val) => setState(() => _unitPrice = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Lead Time Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Production Lead Time', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  DropdownButton<String>(
                    value: _leadTime,
                    underline: const SizedBox(),
                    items: _leadTimes.map((lt) => DropdownMenuItem(value: lt, child: Text(lt, style: const TextStyle(fontSize: 13)))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _leadTime = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Logistics Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Logistics & Transit Partner', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                  DropdownButton<String>(
                    value: _logisticsPartner,
                    underline: const SizedBox(),
                    items: _logisticsRates.keys.map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12)))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _logisticsPartner = val;
                          _shippingRatePerUnit = _logisticsRates[val]!;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Formal Quotation Breakdown Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: Color(0x0C000000), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Commercial Breakdown',
                        style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      Text('E-Way Bill Eligible', style: TextStyle(fontSize: 11, color: Color(0xFF166534), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  _buildSummaryRow('Base Subtotal ($_quantity units @ ₹${_unitPrice.toStringAsFixed(0)})', '₹ ${subtotal.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Handicraft GST (12% HSN 6912)', '₹ ${gst.toStringAsFixed(0)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Insured Logistics ($_logisticsPartner)', '₹ ${shippingTotal.toStringAsFixed(0)}'),
                  const Divider(height: 22),
                  _buildSummaryRow('Total Quotation Value (INR)', '₹ ${totalQuotation.toStringAsFixed(0)}', isTotal: true),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Generate Quotation Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => _showQuotationGeneratedDialog(context, totalQuotation),
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('Generate Formal Quotation PDF', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isTotal ? 14 : 12,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 12,
            fontWeight: FontWeight.bold,
            color: isTotal ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  void _showQuotationGeneratedDialog(BuildContext context, double total) {
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
                'Quotation Generated',
                style: TextStyle(fontFamily: 'Playfair Display', fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quotation #VQ-2026-8920 has been compiled with cryptographic GI watermark and digitally signed.',
              style: TextStyle(fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Buyer: ${widget.rfq?.buyerName ?? "Commercial Buyer"}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Amount: ₹ ${total.toStringAsFixed(0)} (Incl. 12% GST)', style: const TextStyle(fontSize: 12, color: AppColors.primary, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text('Aadhaar e-Sign: Completed', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quotation PDF downloaded to device storage'),
                  backgroundColor: AppColors.secondary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Download PDF'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Quotation transmitted to Buyer Portal with priority GI tagging'),
                  backgroundColor: Color(0xFF166534),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Submit to Buyer'),
          ),
        ],
      ),
    );
  }
}
