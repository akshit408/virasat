import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../models/rfq_model.dart';
import '../providers/b2b_rfq_provider.dart';

class B2bMarketplaceScreen extends ConsumerStatefulWidget {
  const B2bMarketplaceScreen({super.key});

  @override
  ConsumerState<B2bMarketplaceScreen> createState() => _B2bMarketplaceScreenState();
}

class _B2bMarketplaceScreenState extends ConsumerState<B2bMarketplaceScreen> {
  String _selectedCategory = 'All';
  String _selectedStatus = 'All';

  final List<String> _categories = const [
    'All',
    'Hotels & Resorts',
    'Retail Stores',
    'Government Buyers',
    'Corporate Gift Buyers',
    'Interior Designers',
    'Exporters',
    'Boutiques',
  ];

  final List<String> _statuses = const ['All', 'Open', 'Under Review', 'Awarded'];

  @override
  Widget build(BuildContext context) {
    final allRfqs = ref.watch(b2bRfqProvider);

    final filteredRFQs = allRfqs.where((rfq) {
      final matchesCat = _selectedCategory == 'All' || rfq.buyerType == _selectedCategory;
      final matchesStatus = _selectedStatus == 'All' || rfq.status == _selectedStatus;
      return matchesCat && matchesStatus;
    }).toList();

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
          'B2B Wholesale & Bulk Orders',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined, color: AppColors.primary),
            tooltip: 'Create New Quotation',
            onPressed: () => context.push('/b2b-quotation'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Hero Banner
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFA63E24), Color(0xFF6B2211)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Color(0x33A63E24), blurRadius: 10, offset: Offset(0, 4)),
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
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_rounded, size: 12, color: Colors.white),
                            SizedBox(width: 4),
                            Text('VIRASAT B2B PORTAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const Spacer(),
                      const Text('FY 2026-27 Active', style: TextStyle(color: Colors.white70, fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Direct Bulk Sourcing for Corporates & Govts',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Zero middleman commission. 100% GI verified artisan clusters.',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeroStat('₹68.5 L', 'Active RFQs'),
                      Container(width: 1, height: 28, color: Colors.white24),
                      _buildHeroStat('18', 'Open Tenders'),
                      Container(width: 1, height: 28, color: Colors.white24),
                      _buildHeroStat('100%', 'GI Certified'),
                      Container(width: 1, height: 28, color: Colors.white24),
                      _buildHeroStat('18 Days', 'Avg Fulfilment'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Category Filter
            const Text(
              'Buyer Categories',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categories.map((cat) {
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
                      checkmarkColor: Colors.white,
                      onSelected: (val) {
                        setState(() => _selectedCategory = cat);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Status Filter Chips
            Row(
              children: _statuses.map((st) {
                final isSelected = _selectedStatus == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: isSelected,
                    label: Text(
                      st,
                      style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : AppColors.textSecondary),
                    ),
                    selectedColor: const Color(0xFF166534),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(color: isSelected ? const Color(0xFF166534) : AppColors.border),
                    onSelected: (val) {
                      setState(() => _selectedStatus = st);
                    },
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Requests for Quotation (${filteredRFQs.length})',
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Auto-refresh active',
                  style: TextStyle(fontSize: 11, color: Colors.green.shade800, fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // RFQ List
            if (filteredRFQs.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                alignment: Alignment.center,
                child: const Text('No RFQs match the selected criteria.', style: TextStyle(color: AppColors.textSecondary)),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredRFQs.length,
                itemBuilder: (context, idx) {
                  final rfq = filteredRFQs[idx];
                  return _buildRFQCard(context, rfq);
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontFamily: 'Playfair Display', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
      ],
    );
  }

  Widget _buildRFQCard(BuildContext context, B2bRFQ rfq) {
    Color statusColor;
    switch (rfq.status) {
      case 'Open':
        statusColor = const Color(0xFF166534);
        break;
      case 'Under Review':
        statusColor = Colors.orange.shade800;
        break;
      case 'Awarded':
        statusColor = Colors.blue.shade800;
        break;
      default:
        statusColor = AppColors.textSecondary;
    }

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
          // Header: Buyer & Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          rfq.buyerName,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        if (rfq.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF166534)),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${rfq.buyerType} • ${rfq.location}',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: statusColor),
                ),
                child: Text(
                  rfq.status.toUpperCase(),
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            rfq.title,
            style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primary),
          ),

          const SizedBox(height: 8),

          // Notes
          Text(
            rfq.notes,
            style: const TextStyle(fontSize: 12, height: 1.35, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 12),

          // Metrics Grid (Units, Budget, Deadline)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMetric('QUANTITY', '${rfq.units} Units'),
                _buildMetric('BUDGET', '₹ ${(rfq.budget / 100000).toStringAsFixed(2)} L'),
                _buildMetric('DEADLINE', rfq.deadline),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Specification Document downloaded for ${rfq.buyerName}'),
                        backgroundColor: AppColors.secondary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.file_download_outlined, size: 16),
                  label: const Text('Spec PDF', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.push('/b2b-quotation', extra: rfq);
                  },
                  icon: const Icon(Icons.send_rounded, size: 16),
                  label: const Text('Submit Quotation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
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

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.textLight)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }
}
