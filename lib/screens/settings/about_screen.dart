import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.background,
      appBar: VirasatAppBar(title: 'About Virasat'),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(radius: 40, backgroundColor: AppColors.primary, child: Icon(Icons.auto_awesome, color: Colors.white, size: 40)),
            SizedBox(height: 16),
            Text('VIRASAT', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 3, fontFamily: 'Playfair Display')),
            Text('Where Every Craft Tells a Story', style: TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text(
              'Virasat is an AI-powered cultural commerce platform designed to empower artisans, weavers, women homemakers, and tribal craftspeople across India.',
              textAlign: TextAlign.center,
              style: TextStyle(height: 1.5),
            ),
            Spacer(),
            Text('Version 1.0.0 (Production Build)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
