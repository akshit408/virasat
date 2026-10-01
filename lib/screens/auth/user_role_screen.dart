import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/artisan_hub_provider.dart';
import '../../providers/auth_provider.dart';

class UserRoleScreen extends ConsumerStatefulWidget {
  const UserRoleScreen({super.key});

  @override
  ConsumerState<UserRoleScreen> createState() => _UserRoleScreenState();
}

class _UserRoleScreenState extends ConsumerState<UserRoleScreen> {
  UserRoleMode _selectedMode = UserRoleMode.buyer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              // Brand Logo Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.auto_awesome_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'VIRASAT',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              const Text(
                'Choose how you want to use VIRASAT',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.25,
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
              const SizedBox(height: 6),
              const Text(
                'One platform. Two journeys.',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

              const SizedBox(height: 32),

              // Card 1 — Explore & Buy (Buyer Mode)
              GestureDetector(
                onTap: () => setState(() => _selectedMode = UserRoleMode.buyer),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _selectedMode == UserRoleMode.buyer ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _selectedMode == UserRoleMode.buyer ? AppColors.primary : AppColors.border,
                      width: _selectedMode == UserRoleMode.buyer ? 2.5 : 1,
                    ),
                    boxShadow: _selectedMode == UserRoleMode.buyer
                        ? [
                            const BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 28),
                          ),
                          Radio<UserRoleMode>(
                            value: UserRoleMode.buyer,
                            groupValue: _selectedMode,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _selectedMode = val!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Explore & Buy',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Buyer Mode',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Discover authentic handcrafted products directly from India\'s master artisans across 28 states.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
              ),

              const SizedBox(height: 20),

              // Card 2 — Sell My Craft (Artisan Mode)
              GestureDetector(
                onTap: () => setState(() => _selectedMode = UserRoleMode.artisan),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: _selectedMode == UserRoleMode.artisan ? AppColors.surface : AppColors.surface.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: _selectedMode == UserRoleMode.artisan ? AppColors.primary : AppColors.border,
                      width: _selectedMode == UserRoleMode.artisan ? 2.5 : 1,
                    ),
                    boxShadow: _selectedMode == UserRoleMode.artisan
                        ? [
                            const BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.storefront_rounded, color: AppColors.secondary, size: 28),
                          ),
                          Radio<UserRoleMode>(
                            value: UserRoleMode.artisan,
                            groupValue: _selectedMode,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _selectedMode = val!),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Sell My Craft',
                        style: TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Artisan Mode (AI Assisted)',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your digital shop and sell handmade creations across India using AI assistance & voice listing.',
                        style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
              ),

              const SizedBox(height: 36),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ref.read(roleModeProvider.notifier).setRole(_selectedMode);
                    if (_selectedMode == UserRoleMode.buyer) {
                      ref.read(authProvider.notifier).switchRole(UserRole.buyer);
                      context.go('/home');
                    } else {
                      ref.read(authProvider.notifier).switchRole(UserRole.artisan);
                      context.go('/artisan-dashboard');
                    }
                  },
                  icon: Icon(_selectedMode == UserRoleMode.buyer ? Icons.explore_outlined : Icons.rocket_launch_outlined),
                  label: Text(
                    _selectedMode == UserRoleMode.buyer ? 'Continue as Buyer' : 'Start Selling with AI',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms, duration: 400.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
