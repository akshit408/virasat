import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AccessibilityScreen extends StatefulWidget {
  const AccessibilityScreen({super.key});

  @override
  State<AccessibilityScreen> createState() => _AccessibilityScreenState();
}

class _AccessibilityScreenState extends State<AccessibilityScreen> {
  bool _largeFont = false;
  bool _highContrast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Accessibility Options'),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          SwitchListTile(
            title: const Text('Large Font Mode', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Increases text size for low vision users'),
            activeThumbColor: AppColors.primary,
            value: _largeFont,
            onChanged: (val) => setState(() => _largeFont = val),
          ),
          SwitchListTile(
            title: const Text('High Contrast Theme', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Enhances text contrast against background'),
            activeThumbColor: AppColors.primary,
            value: _highContrast,
            onChanged: (val) => setState(() => _highContrast = val),
          ),
        ],
      ),
    );
  }
}
