import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Textiles', 'icon': Icons.checkroom_outlined, 'count': '1,240 Products'},
    {'name': 'Pottery', 'icon': Icons.local_cafe_outlined, 'count': '850 Products'},
    {'name': 'Jewellery', 'icon': Icons.diamond_outlined, 'count': '620 Products'},
    {'name': 'Paintings', 'icon': Icons.palette_outlined, 'count': '430 Products'},
    {'name': 'Wood Craft', 'icon': Icons.park_outlined, 'count': '910 Products'},
    {'name': 'Metal Craft', 'icon': Icons.hardware_outlined, 'count': '380 Products'},
    {'name': 'Embroidery', 'icon': Icons.design_services_outlined, 'count': '750 Products'},
    {'name': 'Handloom', 'icon': Icons.texture_outlined, 'count': '1,890 Products'},
    {'name': 'Leather', 'icon': Icons.shopping_bag_outlined, 'count': '290 Products'},
    {'name': 'Bamboo', 'icon': Icons.grass_outlined, 'count': '640 Products'},
    {'name': 'Home Decor', 'icon': Icons.chair_outlined, 'count': '1,120 Products'},
    {'name': 'Tribal Art', 'icon': Icons.brush_outlined, 'count': '510 Products'},
    {'name': 'Stone Craft', 'icon': Icons.landscape_outlined, 'count': '310 Products'},
    {'name': 'Natural Fibre', 'icon': Icons.eco_outlined, 'count': '470 Products'},
    {'name': 'Miniatures', 'icon': Icons.crop_original_outlined, 'count': '230 Products'},
    {'name': 'Terracotta', 'icon': Icons.opacity_outlined, 'count': '880 Products'},
    {'name': 'Cane', 'icon': Icons.grid_view_outlined, 'count': '340 Products'},
    {'name': 'Brass', 'icon': Icons.shield_outlined, 'count': '590 Products'},
    {'name': 'Toys', 'icon': Icons.smart_toy_outlined, 'count': '410 Products'},
    {'name': 'Accessories', 'icon': Icons.watch_outlined, 'count': '960 Products'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: '20 Craft Categories', showBack: false),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          return GestureDetector(
            onTap: () => context.push('/buyer/marketplace'),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: const [
                  BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.chipBackground,
                    child: Icon(cat['icon'] as IconData, color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    cat['name'] as String,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Text(
                    cat['count'] as String,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
