import 'package:EliteReurbLap/features/notification/data/models/notification_model.dart';

abstract interface class INotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int size = 20,
  });

  Future<int> getUnreadCount();

  Future<void> markAsRead(String notificationId);

  Future<void> markAllAsRead();
}
