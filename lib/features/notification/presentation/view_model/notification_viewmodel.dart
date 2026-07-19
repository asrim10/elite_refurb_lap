import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';
import 'package:EliteReurbLap/features/notification/domain/usecases/get_notifications_usecase.dart';
import 'package:EliteReurbLap/features/notification/domain/usecases/get_unread_count_usecase.dart';
import 'package:EliteReurbLap/features/notification/domain/usecases/mark_all_read_usecase.dart';
import 'package:EliteReurbLap/features/notification/domain/usecases/mark_notification_read_usecase.dart';
import 'package:EliteReurbLap/features/notification/presentation/state/notification_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notificationViewModelProvider =
    NotifierProvider<NotificationViewModel, NotificationState>(
  () => NotificationViewModel(),
);

class NotificationViewModel extends Notifier<NotificationState> {
  late final GetNotificationsUsecase _getNotificationsUsecase;
  late final GetUnreadCountUsecase _getUnreadCountUsecase;
  late final MarkNotificationReadUsecase _markNotificationReadUsecase;
  late final MarkAllReadUsecase _markAllReadUsecase;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    _getUnreadCountUsecase = ref.read(getUnreadCountUsecaseProvider);
    _markNotificationReadUsecase =
        ref.read(markNotificationReadUsecaseProvider);
    _markAllReadUsecase = ref.read(markAllReadUsecaseProvider);

    return const NotificationState();
  }

  Future<void> getNotifications({int page = 1, int size = 20}) async {
    state = state.copyWith(status: NotificationStatus.loading);

    final result = await _getNotificationsUsecase(
      GetNotificationsParams(page: page, size: size),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      ),
      (notifications) {
        final unread = notifications.where((n) => !n.isRead).length;
        state = state.copyWith(
          status: NotificationStatus.loaded,
          notifications: _sortNotifications(notifications),
          unreadCount: unread,
        );
      },
    );
  }

  Future<void> refreshUnreadCount() async {
    final result = await _getUnreadCountUsecase();

    result.fold(
      (failure) => null,
      (count) => state = state.copyWith(unreadCount: count),
    );
  }

  Future<void> markAsRead(String notificationId) async {
    final result = await _markNotificationReadUsecase(
      MarkNotificationReadParams(notificationId: notificationId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        final updated = state.notifications.map((n) {
          if (n.id == notificationId) return n.copyWith(isRead: true);
          return n;
        }).toList();
        final unread = updated.where((n) => !n.isRead).length;
        state = state.copyWith(
          status: NotificationStatus.markedRead,
          notifications: updated,
          unreadCount: unread,
        );
      },
    );
  }

  Future<void> markAllAsRead() async {
    final result = await _markAllReadUsecase();

    result.fold(
      (failure) => state = state.copyWith(
        status: NotificationStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        final updated = state.notifications
            .map((n) => n.copyWith(isRead: true))
            .toList();
        state = state.copyWith(
          status: NotificationStatus.allMarkedRead,
          notifications: updated,
          unreadCount: 0,
        );
      },
    );
  }

  /// Sort notifications newest first
  List<NotificationEntity> _sortNotifications(
      List<NotificationEntity> notifications) {
    final sorted = List<NotificationEntity>.from(notifications);
    sorted.sort((a, b) {
      final aTime = a.createdAt?.millisecondsSinceEpoch ?? 0;
      final bTime = b.createdAt?.millisecondsSinceEpoch ?? 0;
      return bTime.compareTo(aTime);
    });
    return sorted;
  }
}
