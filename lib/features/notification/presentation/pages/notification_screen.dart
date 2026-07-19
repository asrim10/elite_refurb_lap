import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';
import 'package:EliteReurbLap/features/notification/presentation/state/notification_state.dart';
import 'package:EliteReurbLap/features/notification/presentation/view_model/notification_viewmodel.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/all_caught_up_card.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_card.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_header.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_section_header.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationViewModelProvider.notifier).getNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            NotificationHeader(
              onBack: () => Navigator.of(context).pop(),
              onMarkAllRead: _onMarkAllRead,
            ),

            // Scrollable content
            Expanded(child: _buildContent(state)),
          ],
        ),
      ),
    );
  }

  void _onMarkAllRead() {
    ref.read(notificationViewModelProvider.notifier).markAllAsRead();
  }

  Widget _buildContent(NotificationState state) {
    switch (state.status) {
      case NotificationStatus.initial:
      case NotificationStatus.loading:
        if (state.notifications.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFFC4B0A4),
            ),
          );
        }
        // Still show existing data during refresh
        return _buildNotificationList(state);
      case NotificationStatus.error:
        if (state.notifications.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Color(0xFF9A8174),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'Failed to load notifications',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF9A8174),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () {
                      ref
                          .read(notificationViewModelProvider.notifier)
                          .getNotifications();
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }
        return _buildNotificationList(state);
      case NotificationStatus.loaded:
      case NotificationStatus.markedRead:
      case NotificationStatus.allMarkedRead:
        return _buildNotificationList(state);
    }
  }

  Widget _buildNotificationList(NotificationState state) {
    final unread = state.notifications
        .where((n) => !n.isRead)
        .toList();
    final read = state.notifications
        .where((n) => n.isRead)
        .toList();

    if (state.notifications.isEmpty) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: const [
          SizedBox(height: 60),
          AllCaughtUpCard(),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        // New/Unread section
        if (unread.isNotEmpty) ...[
          const NotificationSectionHeader(label: 'NEW'),
          const SizedBox(height: 12),
          ...unread.map((n) => _buildCard(n)),
          const SizedBox(height: 28),
        ],

        // Earlier/Read section
        if (read.isNotEmpty) ...[
          const NotificationSectionHeader(label: 'EARLIER'),
          const SizedBox(height: 12),
          ...read.map((n) => _buildCard(n)),
          const SizedBox(height: 28),
        ],

        // All caught up
        const AllCaughtUpCard(),
      ],
    );
  }

  Widget _buildCard(NotificationEntity notification) {
    return NotificationCard(
      title: notification.title,
      subtitle: notification.message,
      timeAgo: _formatTime(notification.createdAt),
      isUnread: !notification.isRead,
      avatarColor: _resolveAvatarColor(notification.type),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'JUST NOW';
    if (diff.inMinutes < 60) return '${diff.inMinutes}M AGO';
    if (diff.inHours < 24) return '${diff.inHours}H AGO';
    if (diff.inDays < 7) return '${diff.inDays}D AGO';
    return '${dateTime.month}/${dateTime.day}/${dateTime.year}';
  }

  Color _resolveAvatarColor(String type) {
    switch (type) {
      case 'message':
        return const Color(0xFFFBDCCD);
      case 'price_drop':
        return Colors.black;
      case 'new_listing':
        return const Color(0xFFEEEEEE);
      case 'saved_search':
        return const Color(0xFFE4E2E1);
      case 'sold_out':
        return const Color(0xFFFFDAD6);
      default:
        return const Color(0xFFFBDCCD);
    }
  }
}
