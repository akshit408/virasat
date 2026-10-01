import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/state_model.dart';
import '../../core/utils/craft_image_helper.dart';
import '../../core/utils/state_helper.dart';

class StateCard extends StatelessWidget {
  final StateModel stateModel;
  final VoidCallback onTap;

  const StateCard({
    super.key,
    required this.stateModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = getStateFullName(stateModel.name.isNotEmpty ? stateModel.name : stateModel.id);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                getCraftImagePath(stateModel.bannerUrl.isNotEmpty ? stateModel.bannerUrl : stateModel.name),
                fit: BoxFit.cover,
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.7),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      stateModel.famousCrafts.take(3).join(', '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
