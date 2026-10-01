import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/cards/artisan_card.dart';
import '../../widgets/navigation/virasat_app_bar.dart';

class SpotlightScreen extends StatelessWidget {
  const SpotlightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VirasatAppBar(title: 'Women Artisan Spotlight 👩‍🎨'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Empowering Women Homemakers & Tribal Craft Leaders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Playfair Display')),
            const SizedBox(height: 8),
            const Text('Over 65% of Virasat registered artisans are women transforming centuries-old household craft techniques into independent livelihoods.'),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ArtisanCard(
                    name: 'Savitri Devi',
                    craft: 'Blue Pottery',
                    state: 'Jaipur, RJ',
                    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200',
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: ArtisanCard(
                    name: 'Sunita Mithila',
                    craft: 'Madhubani Art',
                    state: 'Madhubani, BR',
                    avatarUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200',
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
