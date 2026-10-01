import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/cards/product_card.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class GiProductsScreen extends ConsumerWidget {
  const GiProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(featuredProductsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: '100% GI Tagged Authentic Collection'),
      body: productsAsync.when(
        data: (products) {
          final giProducts = products.where((p) => p.isGiTagged).toList();
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.62,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: giProducts.length,
            itemBuilder: (context, index) => ProductCard(
              product: giProducts[index],
              onTap: () => context.push('/product-detail', extra: giProducts[index]),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => const SizedBox(),
      ),
    );
  }
}
