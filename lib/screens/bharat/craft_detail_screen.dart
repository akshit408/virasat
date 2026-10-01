import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/bharat_virasat_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/loaders/virasat_loaders.dart';
import '../../widgets/navigation/virasat_app_bar.dart';
import '../../core/utils/craft_image_helper.dart';

class CraftDetailScreen extends ConsumerWidget {
  final String craftId;

  const CraftDetailScreen({super.key, required this.craftId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final craftAsync = ref.watch(craftDetailProvider(craftId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Craft Heritage Overview'),
      body: craftAsync.when(
        data: (cr) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 220,
                width: double.infinity,
                child: Image.asset(
                  getCraftImagePath(cr.imageUrl.isNotEmpty ? cr.imageUrl : cr.name),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(cr.state, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                        const Spacer(),
                        if (cr.isGiTagged)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(12)),
                            child: const Text('GI CERTIFIED', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(cr.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display')),
                    const SizedBox(height: 12),
                    const Text('Historical Origin', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(cr.history, style: const TextStyle(fontSize: 13, height: 1.5, color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    const Text('Raw Materials Used', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(cr.rawMaterials, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 16),
                    const Text('Artisanal Technique', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(cr.technique, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 28),
                    PrimaryButton(
                      text: 'Browse ${cr.name} Items',
                      onPressed: () => context.push('/buyer/marketplace'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        loading: () => const VirasatLoader(),
        error: (err, stack) => const SizedBox(),
      ),
    );
  }
}
