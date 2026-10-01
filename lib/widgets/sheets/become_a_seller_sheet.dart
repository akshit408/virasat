import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/auth_guard.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../services/supabase_service.dart';

class BecomeASellerSheet extends ConsumerStatefulWidget {
  const BecomeASellerSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const BecomeASellerSheet(),
    );
  }

  @override
  ConsumerState<BecomeASellerSheet> createState() => _BecomeASellerSheetState();
}

class _BecomeASellerSheetState extends ConsumerState<BecomeASellerSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _studioNameController;
  late TextEditingController _phoneController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _bioController;

  String _selectedCraftCategory = 'Textiles';
  bool _isSubmitting = false;

  final List<String> _craftCategories = [
    'Textiles',
    'Woodwork & Carving',
    'Metalwork & Bronzes',
    'Pottery & Ceramics',
    'Handicraft Paintings',
    'Jewelry & Ornaments',
    'Leather & Footwear',
    'Stone & Marble Crafts',
    'Natural Fiber & Basketry',
  ];

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    _studioNameController = TextEditingController(text: user.name.isNotEmpty ? user.name : '');
    _phoneController = TextEditingController(text: user.phone);
    _stateController = TextEditingController(text: user.state ?? 'Rajasthan');
    _districtController = TextEditingController(text: user.district ?? 'Jaipur');
    _bioController = TextEditingController(text: user.bio ?? '');
  }

  @override
  void dispose() {
    _studioNameController.dispose();
    _phoneController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _submitBecomeSeller() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      final authState = ref.read(authProvider);
      if (authState.isGuest || !authState.isAuthenticated) {
        final ok = await ensureAuthenticated(
          context,
          ref,
          title: 'Sign In Required',
          message: 'Please sign in to complete your Artisan Seller activation.',
        );
        if (!ok) {
          setState(() {
            _isSubmitting = false;
          });
          return;
        }
      }

      final authNotifier = ref.read(authProvider.notifier);
      final user = ref.read(authProvider).user;

      // 1. Update Local State Profile & Role to Seller / Artisan
      await authNotifier.updateProfile(
        name: _studioNameController.text.trim(),
        phone: _phoneController.text.trim(),
        stateName: _stateController.text.trim(),
        district: _districtController.text.trim(),
        bio: _bioController.text.trim(),
      );

      await authNotifier.switchRole(UserRole.artisan);

      final String validUserId = user.id.isNotEmpty ? user.id : '524536a0-db7e-4d49-8e17-82c6770e2ccd';

      // 2. Row 1: Upsert User / Buyer Profile in Supabase (`users` table)
      await SupabaseService.upsertUserProfile({
        'id': validUserId,
        'full_name': _studioNameController.text.trim(),
        'email': user.email,
        'phone': _phoneController.text.trim(),
        'state': _stateController.text.trim(),
        'district': _districtController.text.trim(),
        'craft_category': _selectedCraftCategory,
        'role': 'ARTISAN',
        'is_artisan': true,
        'bio': _bioController.text.trim(),
      });

      // 3. Row 2: Upsert Artisan Details in Supabase (`artisans` table)
      await SupabaseService.ensureArtisanProfile(
        validUserId,
        _studioNameController.text.trim(),
        craftCategory: _selectedCraftCategory,
        phone: _phoneController.text.trim(),
        state: _stateController.text.trim(),
        district: _districtController.text.trim(),
        bio: _bioController.text.trim(),
      );

      if (!mounted) return;

      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 Congratulations! Your Seller Account is Active.'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );

      context.push('/artisan-dashboard');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to activate seller account: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.storefront_rounded, color: AppColors.secondary, size: 28),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Become a Verified Seller',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'List your authentic crafts & reach buyers direct',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Studio Name / Artisan Name
                TextFormField(
                  controller: _studioNameController,
                  decoration: InputDecoration(
                    labelText: 'Studio / Artisan Full Name *',
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your studio or artisan name' : null,
                ),
                const SizedBox(height: 14),

                // Phone Number
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'WhatsApp Contact Number *',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your contact phone number' : null,
                ),
                const SizedBox(height: 14),

                // Craft Category Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCraftCategory,
                  decoration: InputDecoration(
                    labelText: 'Craft Specialization *',
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  items: _craftCategories
                      .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedCraftCategory = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),

                // State & District Row
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: 'State *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter state' : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _districtController,
                        decoration: InputDecoration(
                          labelText: 'District *',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Enter district' : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Bio
                TextFormField(
                  controller: _bioController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Heritage Bio / Craft Story',
                    hintText: 'Describe your ancestral craft tradition...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 24),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _isSubmitting ? null : _submitBecomeSeller,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.check_circle_outline_rounded),
                    label: Text(
                      _isSubmitting ? 'Activating Seller Dashboard...' : 'Activate Seller Account',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
