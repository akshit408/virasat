import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../services/auth_service.dart';
import '../services/supabase_service.dart';

class NotificationService {
  String _getCurrentUserId() {
    final supaId = SupabaseService.client.auth.currentUser?.id;
    if (supaId != null && supaId.isNotEmpty) {
      return supaId;
    }
    final authId = AuthService().currentUser.id;
    if (authId.isNotEmpty) {
      return SupabaseService.toValidUuid(authId);
    }
    return '9af21e46-2791-43f2-bab8-67b3e87425c3';
  }

  Future<List<NotificationModel>> getNotifications() async {
    try {
      final userId = _getCurrentUserId();
      final res = await SupabaseService.client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if ((res as List).isNotEmpty) {
        return res.map((row) => NotificationModel(
          id: row['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: row['title'] ?? 'Notification',
          message: row['message'] ?? '',
          timestamp: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
          isRead: row['is_read'] ?? false,
          type: (row['type']?.toString().toLowerCase()) ?? 'order',
        )).toList();
      }
    } catch (e) {
      debugPrint('[NotificationService] Error fetching notifications: $e');
    }
    return [];
  }

  Stream<List<NotificationModel>> streamNotifications() {
    final userId = _getCurrentUserId();
    return SupabaseService.client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .map((res) {
          return res.map((row) => NotificationModel(
            id: row['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
            title: row['title'] ?? 'Notification',
            message: row['message'] ?? '',
            timestamp: DateTime.tryParse(row['created_at']?.toString() ?? '') ?? DateTime.now(),
            isRead: row['is_read'] ?? false,
            type: (row['type']?.toString().toLowerCase()) ?? 'order',
          )).toList();
        });
  }

  Future<void> markAsRead(String id) async {
    try {
      await SupabaseService.client.from('notifications').update({'is_read': true}).eq('id', id);
    } catch (e) {
      debugPrint('[NotificationService] Error marking notification read: $e');
    }
  }
}

