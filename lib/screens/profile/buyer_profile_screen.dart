import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';

class BuyerProfileScreen extends ConsumerWidget {
  const BuyerProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Header Badge Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 10, offset: Offset(0, 4))],
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.person, size: 44, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display'),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: AppColors.chipBackground, borderRadius: BorderRadius.circular(12)),
                      child: const Text('CRAFT CONNOISSEUR • BUYER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Switch to Artisan Mode Card
              GestureDetector(
                onTap: () {
                  ref.read(authProvider.notifier).switchRole(UserRole.artisan);
                  context.go('/artisan/dashboard');
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.swap_horiz_rounded, color: Colors.white),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Switch to Artisan Studio', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            Text('Manage your craft listings & AI tools', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              _profileTile(Icons.local_shipping_outlined, 'My Orders & Tracking', () => context.push('/orders')),
              _profileTile(Icons.favorite_border, 'Saved Crafts (Wishlist)', () => context.push('/wishlist')),
              _profileTile(Icons.location_on_outlined, 'Delivery Addresses', () => context.push('/addresses')),
              _profileTile(Icons.language_outlined, 'App Language', () => context.push('/language')),
              _profileTile(Icons.accessibility_new_rounded, 'Accessibility Settings', () => context.push('/accessibility')),
              _profileTile(Icons.auto_graph_outlined, 'Government Analytics', () => context.push('/admin')),
              _profileTile(Icons.help_outline, 'Help & Support Helpline', () => context.push('/help')),
              _profileTile(Icons.info_outline, 'About Virasat Platform', () => context.push('/about')),
              _profileTile(Icons.settings_outlined, 'Settings', () => context.push('/settings')),
              _profileTile(Icons.logout, 'Log Out', () => context.go('/login'), color: AppColors.error),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color ?? AppColors.textPrimary)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textSecondary),
        onTap: onTap,
      ),
    );
  }
}
