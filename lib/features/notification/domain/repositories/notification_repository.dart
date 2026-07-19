import 'package:dartz/dartz.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';

abstract interface class INotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int size = 20,
  });

  Future<Either<Failure, int>> getUnreadCount();

  Future<Either<Failure, void>> markAsRead(String notificationId);

  Future<Either<Failure, void>> markAllAsRead();
}
