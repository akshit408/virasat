import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/auth_guard.dart';
import '../providers/cart_provider.dart';

class ShoppingBagIconButton extends ConsumerWidget {
  final Color? color;
  final double size;

  const ShoppingBagIconButton({
    super.key,
    this.color,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.notifier).totalItemsCount;

    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: IconButton(
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              color: color ?? AppColors.primary,
              size: size,
            ),
            if (cartCount > 0)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.shade600,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        onPressed: () async {
          final ok = await ensureAuthenticated(
            context,
            ref,
            title: 'Sign In Required',
            message: 'Please sign in to view your shopping bag and proceed to checkout.',
          );
          if (ok && context.mounted) {
            context.push('/cart');
          }
        },
        tooltip: 'Shopping Bag',
      ),
    );
  }
}
