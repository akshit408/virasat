import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/buttons/primary_button.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class SavedAddressesScreen extends StatelessWidget {
  const SavedAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Saved Delivery Addresses'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: const Row(
                children: [
                  Icon(Icons.home_outlined, color: AppColors.primary),
                  SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Home (Default)', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('42, Heritage Enclave, Civil Lines, Jaipur, Rajasthan - 302006', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(text: 'Add New Address', icon: Icons.add, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
