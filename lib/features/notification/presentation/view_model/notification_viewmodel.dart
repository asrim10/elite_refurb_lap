import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:EliteReurbLap/features/auth/presentation/state/auth_state.dart';
import 'package:EliteReurbLap/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:EliteReurbLap/features/notification/data/services/notification_socket_service.dart';
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

  late final NotificationSocketService _socketService;

  StreamSubscription<NotificationEntity>? _newNotificationSub;
  StreamSubscription<int>? _unreadCountSub;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<String>? _errorSub;

  @override
  NotificationState build() {
    _getNotificationsUsecase = ref.read(getNotificationsUsecaseProvider);
    _getUnreadCountUsecase = ref.read(getUnreadCountUsecaseProvider);
    _markNotificationReadUsecase =
        ref.read(markNotificationReadUsecaseProvider);
    _markAllReadUsecase = ref.read(markAllReadUsecaseProvider);

    _socketService = ref.read(notificationSocketServiceProvider);

    // Register socket event listeners
    _newNotificationSub =
        _socketService.onNewNotification.listen(_onNewNotification);
    _unreadCountSub =
        _socketService.onUnreadCountUpdate.listen(_onUnreadCountUpdate);
    _connectionSub =
        _socketService.onConnectionStatus.listen(_onConnectionChange);
    _errorSub = _socketService.onError.listen((msg) {
      debugPrint('🔔 Notification socket error: $msg');
    });

    // Connect the socket if already authenticated (e.g. from a previous session)
    final authState = ref.read(authViewModelProvider);
    if (authState.status == AuthStatus.authenticated &&
        authState.authEntity != null) {
      _socketService.connect();
    }

    // React to future auth state changes
    ref.listen(authViewModelProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated && next.authEntity != null) {
        _socketService.connect();
      } else if (next.status == AuthStatus.unauthenticated) {
        _socketService.disconnect();
      }
    });

    // Clean up subscriptions when the provider is disposed
    ref.onDispose(() {
      _newNotificationSub?.cancel();
      _unreadCountSub?.cancel();
      _connectionSub?.cancel();
      _errorSub?.cancel();
      _socketService.disconnect();
    });

    return const NotificationState();
  }

  /// Manually connect/reconnect the socket.
  Future<void> connectSocket() => _socketService.connect();

  /// Disconnect the socket.
  void disconnectSocket() => _socketService.disconnect();

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

  // ---- Socket event handlers ----

  void _onNewNotification(NotificationEntity notification) {
    debugPrint(
        '🔔 _onNewNotification: title="${notification.title}" type="${notification.type}"');

    // Skip if the notification already exists in the list (prevent duplicates
    // from REST fetch + WebSocket overlap)
    final alreadyExists =
        state.notifications.any((n) => n.id != null && n.id == notification.id);
    if (alreadyExists) return;

    // Prepend the new notification and re-sort
    final updated = _sortNotifications([
      notification,
      ...state.notifications,
    ]);
    final unread = updated.where((n) => !n.isRead).length;
    state = state.copyWith(
      status: NotificationStatus.loaded,
      notifications: updated,
      unreadCount: unread,
    );
  }

  void _onUnreadCountUpdate(int count) {
    debugPrint('🔔 _onUnreadCountUpdate: count=$count');
    // Only update if the count differs from what we already know
    if (count != state.unreadCount) {
      state = state.copyWith(unreadCount: count);
    }
  }

  void _onConnectionChange(bool connected) {
    debugPrint('🔔 Notification socket connected: $connected');
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
