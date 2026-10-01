import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/ai_studio_provider.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/navigation/virasat_app_bar.dart';
import '../../core/utils/craft_image_helper.dart';

class AiImageStudioScreen extends ConsumerStatefulWidget {
  const AiImageStudioScreen({super.key});

  @override
  ConsumerState<AiImageStudioScreen> createState() => _AiImageStudioScreenState();
}

class _AiImageStudioScreenState extends ConsumerState<AiImageStudioScreen> {
  bool _whiteBg = true;
  bool _autoCrop = true;
  bool _isProcessing = false;
  String? _enhancedUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'AI Image Enhancer Studio'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Studio Quality Product Photos in 1-Click',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display'),
            ),
            const SizedBox(height: 6),
            const Text('Upload your product photo taken at home. Our AI cleans up lighting, replaces background with clean studio ivory, and enhances colors.'),
            const SizedBox(height: 20),

            // Image Preview Comparison Box
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: _enhancedUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(getCraftImagePath(_enhancedUrl), fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/crafts/blue_pottery_01.jpg',
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text('Tap button below to select image and enhance', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      ],
                    ),
            ),

            const SizedBox(height: 24),

            SwitchListTile(
              title: const Text('Pure White Studio Background', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Replaces dark/cluttered room background'),
              activeThumbColor: AppColors.primary,
              value: _whiteBg,
              onChanged: (val) => setState(() => _whiteBg = val),
            ),
            SwitchListTile(
              title: const Text('Smart Centering & Auto-Crop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              subtitle: const Text('Adjusts aspect ratio to 1:1 for marketplace'),
              activeThumbColor: AppColors.primary,
              value: _autoCrop,
              onChanged: (val) => setState(() => _autoCrop = val),
            ),

            const SizedBox(height: 28),

            PrimaryButton(
              text: 'Process & Enhance Image',
              isLoading: _isProcessing,
              onPressed: () async {
                setState(() => _isProcessing = true);
                final res = await ref.read(aiServiceProvider).enhanceProductImage('mock_path');
                setState(() {
                  _enhancedUrl = res;
                  _isProcessing = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
