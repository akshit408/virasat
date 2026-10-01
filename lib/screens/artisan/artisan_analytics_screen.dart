import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/artisan_hub_provider.dart';

class ArtisanAnalyticsScreen extends ConsumerWidget {
  const ArtisanAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(artisanOrdersProvider);
    final totalEarnings = ref.read(artisanOrdersProvider.notifier).totalEarnings;
    final acceptedCount = orders.where((o) => o.status.toLowerCase() == 'accepted' || o.status.toLowerCase() == 'delivered' || o.status.toLowerCase() == 'shipped' || o.status.toLowerCase() == 'packed').length;

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
          'Earnings & Analytics',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Revenue Cards Grid
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: "Today's Revenue",
                    value: '₹ ${(totalEarnings * 0.1).toStringAsFixed(0)}',
                    change: '+14% vs yesterday',
                    icon: Icons.payments_outlined,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Monthly Revenue',
                    value: '₹ ${totalEarnings.toStringAsFixed(0)}',
                    change: '+28% vs last month',
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard(
                    title: 'Total Orders',
                    value: '${orders.length} Orders',
                    change: '$acceptedCount Accepted',
                    icon: Icons.local_shipping_outlined,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildMetricCard(
                    title: 'Best Selling Craft',
                    value: 'Authentic Heritage Saree',
                    change: '24 units sold',
                    icon: Icons.star_outline_rounded,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 28),

            // Weekly Sales Trend Visual Bar Chart
            const Text(
              'Weekly Sales Performance (₹)',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildChartBar('Mon', 0.4, '₹ 3.2k'),
                      _buildChartBar('Tue', 0.6, '₹ 4.8k'),
                      _buildChartBar('Wed', 0.3, '₹ 2.4k'),
                      _buildChartBar('Thu', 0.85, '₹ 7.2k'),
                      _buildChartBar('Fri', 0.5, '₹ 4.1k'),
                      _buildChartBar('Sat', 0.95, '₹ 8.5k'),
                      _buildChartBar('Sun', 0.7, '₹ 5.6k'),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Category Sales Distribution & Top States
            const Text(
              'Top Buyer States & Distribution',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildStateProgressRow('Maharashtra', 0.35, '35% (₹ 16.9k)'),
                  const SizedBox(height: 12),
                  _buildStateProgressRow('Delhi NCR', 0.28, '28% (₹ 13.5k)'),
                  const SizedBox(height: 12),
                  _buildStateProgressRow('Karnataka', 0.20, '20% (₹ 9.7k)'),
                  const SizedBox(height: 12),
                  _buildStateProgressRow('Tamil Nadu', 0.17, '17% (₹ 8.2k)'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 10),
          Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textLight)),
          const SizedBox(height: 2),
          Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(change, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.success)),
        ],
      ),
    );
  }

  Widget _buildChartBar(String day, double heightFactor, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.primary)),
        const SizedBox(height: 6),
        Container(
          height: 120 * heightFactor,
          width: 20,
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStateProgressRow(String stateName, double progress, String percentStr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(stateName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            Text(percentStr, style: const TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}
