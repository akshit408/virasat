import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/formatters.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Government Macro Analytics'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 28),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ministry of Textiles & Handicrafts Dashboard', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        Text('Real-time impact tracking across Indian craft clusters', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 1.5,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _adminStat('Total Artisans', '1,42,800', Icons.people_outline, AppColors.primary),
                _adminStat('Women Artisans', '92,400 (65%)', Icons.face_3_outlined, AppColors.accent),
                _adminStat('States Covered', '28 States / 8 UTs', Icons.map_outlined, AppColors.secondary),
                _adminStat('GI Products Listed', '420 GI Tags', Icons.verified_outlined, AppColors.success),
                _adminStat('Total Revenue', Formatters.currency(14205000), Icons.currency_rupee, AppColors.primary),
                _adminStat('Direct Orders', '84,200 Orders', Icons.shopping_bag_outlined, AppColors.secondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _adminStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(child: Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}
