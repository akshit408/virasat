import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../widgets/cards/safe_product_image.dart';
import '../models/workshop_event_model.dart';
import '../providers/virasat_connect_provider.dart';
import '../../../providers/auth_provider.dart';

class WorkshopRegistrationSheet extends ConsumerStatefulWidget {
  final WorkshopEvent workshop;

  const WorkshopRegistrationSheet({super.key, required this.workshop});

  static void show(BuildContext context, WorkshopEvent workshop) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => WorkshopRegistrationSheet(workshop: workshop),
    );
  }

  @override
  ConsumerState<WorkshopRegistrationSheet> createState() => _WorkshopRegistrationSheetState();
}

class _WorkshopRegistrationSheetState extends ConsumerState<WorkshopRegistrationSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _pehchanIdController;
  bool _isProcessing = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).user;
    final defaultName = user.name.isNotEmpty ? user.name : (user.email.isNotEmpty ? user.email.split('@').first : 'Artisan Explorer');
    final defaultPhone = user.phone.isNotEmpty ? user.phone : '+91 98765 43210';
    _nameController = TextEditingController(text: defaultName);
    _phoneController = TextEditingController(text: defaultPhone);
    _pehchanIdController = TextEditingController(text: 'GJ-BANDH-881');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pehchanIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRegistration() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 900));

    ref.read(virasatConnectProvider.notifier).registerForWorkshop(widget.workshop.id);

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workshop = widget.workshop;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      child: SingleChildScrollView(
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
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (_isSuccess) ...[
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8F5E9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_rounded, color: AppColors.forestGreen, size: 54),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.tr(context, 'ticket_confirmation'),
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTerracotta,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Registration Ticket #VIR-WS-${workshop.id.toUpperCase()}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(workshop.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          const SizedBox(height: 4),
                          Text('📍 ${workshop.location}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          Text('📅 ${workshop.startDate} - ${workshop.endDate}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          const SizedBox(height: 8),
                          const Row(
                            children: [
                              Icon(Icons.verified_user_rounded, color: AppColors.forestGreen, size: 16),
                              SizedBox(width: 6),
                              Text('100% Free Government Sponsored Seat', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.forestGreen)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryTerracotta, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))),
                        child: const Text('Done & View Tickets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Workshop Header Summary
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SafeProductImage(
                    imagePath: workshop.bannerImage,
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(14),
                    placeholderIcon: Icons.palette_outlined,
                    placeholderText: 'Workshop Image',
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primaryTerracotta.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            workshop.craftCategory,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryTerracotta),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workshop.getLocalizedTitle(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          workshop.getLocalizedDescription(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 6),
                        InkWell(
                          onTap: () {
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    const Icon(Icons.volume_up_rounded, color: Colors.amber),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.tr(context, 'playing_audio'),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                backgroundColor: AppColors.primary,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.volume_up_rounded, size: 16, color: AppColors.secondary),
                              const SizedBox(width: 4),
                              Text(
                                AppLocalizations.tr(context, 'listen_audio'),
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: AppColors.border),
              const SizedBox(height: 12),

              const Text('Participant Details', style: TextStyle(fontFamily: 'Playfair Display', fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Artisan Full Name',
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mobile Phone Number',
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _pehchanIdController,
                decoration: InputDecoration(
                  labelText: 'Pehchan Card / GI Registration Code',
                  prefixIcon: const Icon(Icons.verified_outlined, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Workshop Seat Fee:', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                  Text(
                    workshop.fee == 0.0 ? 'FREE (Sponsored)' : '₹ ${workshop.fee.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.forestGreen),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleRegistration,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTerracotta,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Confirm Workshop Seat Registration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
