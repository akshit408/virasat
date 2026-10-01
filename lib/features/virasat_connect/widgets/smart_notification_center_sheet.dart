import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/localization/app_localizations.dart';
import '../models/smart_notification_model.dart';
import '../providers/virasat_connect_provider.dart';

class SmartNotificationCenterSheet extends ConsumerWidget {
  const SmartNotificationCenterSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const SmartNotificationCenterSheet(),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.workshop:
        return Icons.event_available_rounded;
      case NotificationType.scheme:
        return Icons.account_balance_rounded;
      case NotificationType.giCamp:
        return Icons.verified_rounded;
      case NotificationType.exhibition:
        return Icons.campaign_rounded;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.workshop:
        return AppColors.primaryTerracotta;
      case NotificationType.scheme:
        return AppColors.forestGreen;
      case NotificationType.giCamp:
        return AppColors.saffronGold;
      case NotificationType.exhibition:
        return AppColors.darkBrown;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(virasatConnectProvider);
    final notifier = ref.read(virasatConnectProvider.notifier);
    final notifications = state.notifications;

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.only(top: 24, left: 20, right: 20, bottom: 20),
      child: Column(
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

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.tr(context, 'notification_center'),
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (state.unreadNotificationsCount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTerracotta,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${state.unreadNotificationsCount} NEW',
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.refresh_rounded, color: AppColors.primaryTerracotta),
                tooltip: 'Simulate Artisan Profile Match',
                onPressed: () {
                  notifier.triggerSmartNotificationsForArtisan(
                    artisanLocation: 'Jamnagar, Gujarat',
                    craftCategory: 'Bandhani Tie-Dye',
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 6),
          const Text(
            'Personalized notification stream based on your GPS location & craft category',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),

          const SizedBox(height: 16),
          const Divider(color: AppColors.border),

          Expanded(
            child: notifications.isEmpty
                ? const Center(
                    child: Text('No notifications yet.', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      final typeColor = _getColorForType(item.type);
                      final icon = _getIconForType(item.type);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: item.isRead ? AppColors.background : AppColors.surface,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: item.isRead ? AppColors.border : typeColor.withValues(alpha: 0.5),
                            width: item.isRead ? 1 : 1.5,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: typeColor.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, color: typeColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.getLocalizedTitle(context),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (!item.isRead)
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: typeColor,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.getLocalizedBody(context),
                                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '📍 ${item.location} • ${item.craftCategory}',
                                        style: const TextStyle(fontSize: 10, color: AppColors.textLight),
                                      ),
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
                                            const Icon(Icons.volume_up_rounded, size: 14, color: AppColors.secondary),
                                            const SizedBox(width: 4),
                                            Text(
                                              AppLocalizations.tr(context, 'listen_audio'),
                                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondary),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
