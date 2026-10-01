import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/auth_guard.dart';
import '../../providers/artisan_hub_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_service.dart';
import '../../widgets/typography/section_title.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/localization/locale_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String selectedLanguage = 'English (EN)';

  @override
  Widget build(BuildContext context) {
    final roleMode = ref.watch(roleModeProvider);
    final isArtisanMode = roleMode == UserRoleMode.artisan;

    final authState = ref.watch(authProvider);
    final user = authState.user;
    final supaUser = SupabaseService.client.auth.currentUser;

    final displayName = supaUser?.userMetadata?['full_name'] as String? ?? (user.name.isNotEmpty ? user.name : (supaUser?.email?.split('@').first ?? 'Conscious Craft Patron'));
    final displaySubtitle = supaUser?.email ?? (user.email.isNotEmpty ? user.email : 'Explore India\'s Heritage Crafts');
    final initials = displayName.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Virasat Profile',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.surface,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Profile Header Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(alpha: 0.15),
                    border: Border.all(color: AppColors.secondary, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      initials.isNotEmpty ? initials : 'VP',
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Playfair Display',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        displaySubtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              user.isGuest
                                  ? 'Guest Explorer'
                                  : (user.isSeller ? 'Verified Artisan Seller' : 'Verified Conscious Patron'),
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                            ),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () async {
                              final ok = await ensureAuthenticated(
                                context,
                                ref,
                                title: 'Authentication Required',
                                message: 'Please log in to edit your profile details.',
                              );
                              if (ok && context.mounted) {
                                context.push('/edit-profile');
                              }
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit_outlined, size: 12, color: AppColors.primary),
                                  SizedBox(width: 4),
                                  Text(
                                    'Edit Profile',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primary),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms),

          const SizedBox(height: 16),

          // Role Mode Switcher (Buyer vs Seller/Artisan)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isArtisanMode ? Icons.storefront_rounded : Icons.shopping_bag_outlined,
                    color: AppColors.secondary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isArtisanMode ? 'Active Mode: Artisan Seller' : 'Active Mode: Buyer / Patron',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isArtisanMode ? 'Switch to shop crafts as a buyer' : 'Switch to sell crafts & view seller hub',
                        style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.go('/role-selection');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Switch Role', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Heritage Account Menu Options
          SectionTitle(title: isArtisanMode ? 'Artisan Profile & Portal' : 'Buyer Profile & Settings'),
          const SizedBox(height: 12),

          if (!isArtisanMode) ...[
            _buildMenuTile(
              title: 'Edit Profile',
              subtitle: 'Update photo, name, contact details & delivery region',
              icon: Icons.person_outline_rounded,
              onTap: () async {
                final ok = await ensureAuthenticated(
                  context,
                  ref,
                  title: 'Authentication Required',
                  message: 'Please log in to edit your profile details.',
                );
                if (ok && context.mounted) {
                  context.push('/edit-profile');
                }
              },
            ),
            _buildMenuTile(
              title: 'My Orders',
              subtitle: 'Track direct-from-artisan shipments & order history',
              icon: Icons.local_shipping_outlined,
              onTap: () async {
                final ok = await ensureAuthenticated(
                  context,
                  ref,
                  title: 'Authentication Required',
                  message: 'Please log in to view your order history.',
                );
                if (ok && context.mounted) {
                  context.push('/orders');
                }
              },
            ),
            _buildMenuTile(
              title: 'My Wishlist',
              subtitle: 'Saved crafts & favorite master artisans',
              icon: Icons.favorite_border_rounded,
              onTap: () async {
                final ok = await ensureAuthenticated(
                  context,
                  ref,
                  title: 'Authentication Required',
                  message: 'Please log in to view your saved wishlist.',
                );
                if (ok && context.mounted) {
                  context.push('/wishlist');
                }
              },
            ),
            _buildMenuTile(
              title: 'My Shopping Cart',
              subtitle: 'Items pending checkout',
              icon: Icons.shopping_cart_outlined,
              onTap: () async {
                final ok = await ensureAuthenticated(
                  context,
                  ref,
                  title: 'Authentication Required',
                  message: 'Please log in to view your shopping bag.',
                );
                if (ok && context.mounted) {
                  context.push('/cart');
                }
              },
            ),
            _buildMenuTile(
              title: 'Nearby Crafts & Artisans',
              subtitle: 'Discover verified craft clusters near your location',
              icon: Icons.near_me_outlined,
              onTap: () => context.push('/nearby-artisans'),
            ),
            _buildMenuTile(
              title: 'Delivery Addresses',
              subtitle: 'Manage saved shipping locations',
              icon: Icons.location_on_outlined,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved Delivery Addresses: Home (Ahmedabad), Office (Gandhinagar)'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildMenuTile(
              title: 'Payment Methods',
              subtitle: 'UPI, Cards & Direct DBT Checkout',
              icon: Icons.payment_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Saved Payment Methods: UPI, Credit Card'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _buildMenuTile(
              title: 'Help & Support',
              subtitle: 'Customer care & FAQs',
              icon: Icons.help_outline_rounded,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('VIRASAT Customer Care: support@virasat.in | 1800-11-2026'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ] else ...[
            _buildMenuTile(
              title: 'Artisan Edit Profile',
              subtitle: 'Update artisan studio profile, craft bio & region',
              icon: Icons.person_outline_rounded,
              onTap: () => context.push('/edit-profile'),
            ),
            _buildMenuTile(
              title: 'Upload Craft (AI Sell My Craft)',
              subtitle: 'AI photo scanner & voice product listing',
              icon: Icons.add_a_photo_outlined,
              onTap: () => context.push('/sell-my-craft'),
            ),
            _buildMenuTile(
              title: 'My Products',
              subtitle: 'Manage active catalog listings & stock',
              icon: Icons.inventory_2_outlined,
              onTap: () => context.push('/artisan-products'),
            ),
            _buildMenuTile(
              title: 'Incoming Artisan Orders',
              subtitle: 'Accept, pack, ship & deliver orders',
              icon: Icons.inbox_rounded,
              onTap: () => context.push('/artisan-orders'),
            ),
            _buildMenuTile(
              title: 'Earnings & Payouts',
              subtitle: 'View monthly revenue & direct bank transfers',
              icon: Icons.account_balance_wallet_outlined,
              onTap: () => context.push('/artisan-earnings'),
            ),
            _buildMenuTile(
              title: 'Artisan Hub Dashboard',
              subtitle: 'Seller overview, sales analytics & tools',
              icon: Icons.storefront_rounded,
              onTap: () => context.push('/artisan-dashboard'),
            ),
            _buildMenuTile(
              title: 'Women & Community Collectives',
              subtitle: 'SHGs and village cooperatives',
              icon: Icons.groups_outlined,
              onTap: () => context.push('/collectives'),
            ),
            _buildMenuTile(
              title: 'AI Assistant Tools Suite',
              subtitle: 'Visual scanner, pricing & voice listing',
              icon: Icons.auto_awesome_rounded,
              onTap: () => context.push('/ai-assistants'),
            ),
          ],

          const SizedBox(height: 20),

          // Language Selector
          Consumer(
            builder: (context, ref, child) {
              final currentLangName = ref.watch(currentLanguageNameProvider);
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.language_rounded, color: AppColors.primary),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.tr(context, 'app_language'),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            Text(
                              'Current: $currentLangName',
                              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        context.push('/language');
                      },
                      icon: const Icon(Icons.translate_rounded, size: 18, color: AppColors.primary),
                      label: Text(
                        currentLangName,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Log Out Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () async {
                await ref.read(authProvider.notifier).logout();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              label: Text(
                AppLocalizations.tr(context, 'logout'),
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.redAccent.withValues(alpha: 0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildMenuTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          subtitle: Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textLight),
          onTap: onTap,
        ),
      ),
    );
  }
}
