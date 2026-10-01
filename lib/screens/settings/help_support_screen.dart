import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Help & Artisan Support'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Artisan Support Toll-Free Helpline', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: const Row(
                children: [
                  Icon(Icons.phone_in_talk_outlined, color: AppColors.primary),
                  SizedBox(width: 14),
                  Text('1800-11-2026 (Toll-Free Hindi/Eng/Regional)', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Voice Assistant Help', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Need help listing products? Tap the mic icon on any page to speak directly to the Virasat AI assistant.'),
            const Spacer(),
            PrimaryButton(text: 'Start Live Support Chat', icon: Icons.chat_bubble_outline, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
