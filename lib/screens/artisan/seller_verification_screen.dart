import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../models/seller_verification_model.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/inputs/virasat_input.dart';
import '../../widgets/inputs/virasat_image_picker.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

final sellerVerificationProvider = StateNotifierProvider<SellerVerificationNotifier, SellerVerificationModel?>((ref) {
  return SellerVerificationNotifier();
});

class SellerVerificationNotifier extends StateNotifier<SellerVerificationModel?> {
  SellerVerificationNotifier()
      : super(
          SellerVerificationModel(
            id: 'ver_1001',
            userId: 'user_101',
            fullName: 'Savitri Devi',
            phone: '+91 98765 43210',
            state: 'Rajasthan',
            district: 'Jaipur',
            craftType: 'Block Printing & Textiles',
            aadhaarNumber: 'XXXX-XXXX-8921',
            status: VerificationStatus.verified,
            submittedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
        );

  void submitVerification(SellerVerificationModel data) {
    state = data.copyWith(status: VerificationStatus.pending);
  }

  void setStatus(VerificationStatus status, {String? reason}) {
    if (state != null) {
      state = state!.copyWith(status: status, rejectionReason: reason);
    }
  }
}

class SellerVerificationScreen extends ConsumerStatefulWidget {
  const SellerVerificationScreen({super.key});

  @override
  ConsumerState<SellerVerificationScreen> createState() => _SellerVerificationScreenState();
}

class _SellerVerificationScreenState extends ConsumerState<SellerVerificationScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _stateController;
  late TextEditingController _districtController;
  late TextEditingController _craftCategoryController;
  late TextEditingController _aadhaarController;

  List<String> _aadhaarFrontImages = [];
  List<String> _aadhaarBackImages = [];
  List<String> _selfieImages = [];

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final current = ref.read(sellerVerificationProvider);
    _nameController = TextEditingController(text: current?.fullName ?? 'Savitri Devi');
    _phoneController = TextEditingController(text: current?.phone ?? '+91 98765 43210');
    _stateController = TextEditingController(text: current?.state ?? 'Rajasthan');
    _districtController = TextEditingController(text: current?.district ?? 'Jaipur');
    _craftCategoryController = TextEditingController(text: current?.craftType ?? 'Handloom Textiles');
    _aadhaarController = TextEditingController(text: current?.aadhaarNumber ?? '4821 9012 3841');
  }

  @override
  Widget build(BuildContext context) {
    final verificationState = ref.watch(sellerVerificationProvider);
    final status = verificationState?.status ?? VerificationStatus.pending;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Seller Verification & KYC'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Verification Status Banner
              _buildStatusCard(status, verificationState?.rejectionReason),

              const SizedBox(height: 24),
              const Text(
                'Personal & Location Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              VirasatTextField(
                label: 'Full Name (as per Aadhaar)',
                controller: _nameController,
                hintText: 'Enter full legal name',
              ),
              const SizedBox(height: 14),

              VirasatTextField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: VirasatTextField(
                      label: 'State',
                      controller: _stateController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: VirasatTextField(
                      label: 'District',
                      controller: _districtController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              VirasatTextField(
                label: 'Craft Category / Specialty',
                controller: _craftCategoryController,
                hintText: 'e.g. Terracotta, Textiles, Blue Pottery',
              ),
              const SizedBox(height: 24),

              const Text(
                'Identity Verification (Aadhaar & Selfie)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),

              VirasatTextField(
                label: 'Aadhaar Number (12-Digit)',
                controller: _aadhaarController,
                keyboardType: TextInputType.number,
                hintText: '1234 5678 9012',
              ),
              const SizedBox(height: 20),

              // Aadhaar Front Upload
              const Text(
                'Aadhaar Card - Front Side',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              VirasatImagePicker(
                maxImages: 1,
                initialImages: _aadhaarFrontImages,
                onImagesChanged: (imgs) => setState(() => _aadhaarFrontImages = imgs),
              ),
              const SizedBox(height: 20),

              // Aadhaar Back Upload
              const Text(
                'Aadhaar Card - Back Side',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              VirasatImagePicker(
                maxImages: 1,
                initialImages: _aadhaarBackImages,
                onImagesChanged: (imgs) => setState(() => _aadhaarBackImages = imgs),
              ),
              const SizedBox(height: 20),

              // Artisan Selfie Upload
              const Text(
                'Artisan Live Selfie Photo',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              VirasatImagePicker(
                maxImages: 1,
                initialImages: _selfieImages,
                onImagesChanged: (imgs) => setState(() => _selfieImages = imgs),
              ),

              const SizedBox(height: 32),

              PrimaryButton(
                text: status == VerificationStatus.verified ? 'Update KYC Submission' : 'Submit for Verification',
                isLoading: _isSubmitting,
                onPressed: () async {
                  setState(() => _isSubmitting = true);
                  await Future.delayed(const Duration(milliseconds: 1000));

                  final updated = SellerVerificationModel(
                    id: 'ver_${DateTime.now().millisecondsSinceEpoch}',
                    userId: 'user_101',
                    fullName: _nameController.text,
                    phone: _phoneController.text,
                    state: _stateController.text,
                    district: _districtController.text,
                    craftType: _craftCategoryController.text,
                    aadhaarNumber: _aadhaarController.text,
                    aadhaarFrontUrl: _aadhaarFrontImages.isNotEmpty ? _aadhaarFrontImages.first : '',
                    aadhaarBackUrl: _aadhaarBackImages.isNotEmpty ? _aadhaarBackImages.first : '',
                    selfieUrl: _selfieImages.isNotEmpty ? _selfieImages.first : '',
                    status: VerificationStatus.pending,
                    submittedAt: DateTime.now(),
                  );

                  ref.read(sellerVerificationProvider.notifier).submitVerification(updated);
                  setState(() => _isSubmitting = false);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification documents submitted successfully! 📋'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(VerificationStatus status, String? reason) {
    Color bg;
    Color borderColor;
    IconData icon;
    String statusTitle;
    String statusSubtitle;

    switch (status) {
      case VerificationStatus.verified:
        bg = Colors.green.shade50;
        borderColor = Colors.green.shade600;
        icon = Icons.verified_user_rounded;
        statusTitle = 'Verified Artisan Badge Active';
        statusSubtitle = 'Your account is verified by Government of India craft registry standards.';
        break;
      case VerificationStatus.rejected:
        bg = Colors.red.shade50;
        borderColor = Colors.red.shade600;
        icon = Icons.error_outline_rounded;
        statusTitle = 'Verification Needs Attention';
        statusSubtitle = reason ?? 'Document details did not match Aadhaar registry. Please re-upload clear photos.';
        break;
      case VerificationStatus.pending:
        bg = Colors.amber.shade50;
        borderColor = Colors.amber.shade700;
        icon = Icons.hourglass_top_rounded;
        statusTitle = 'Verification Under Review';
        statusSubtitle = 'Your documents are currently being processed by Virasat Admin team. Est. time: 24h.';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: borderColor, size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusTitle,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: borderColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  statusSubtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade800,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
