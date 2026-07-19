import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/all_caught_up_card.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_card.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_header.dart';
import 'package:EliteReurbLap/features/notification/presentation/widgets/notification_section_header.dart';

// A single notification item model used for the screen.
class _NotificationItem {
  final String title;
  final String subtitle;
  final String timeAgo;
  final bool isUnread;
  final Color avatarColor;
  const _NotificationItem({
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.isUnread = false,
    required this.avatarColor,
  });
}

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  // Mock notification data - replace with a real ViewModel + State later
  static const _todayNotifications = [
    _NotificationItem(
      title: 'Ram Bahadur',
      subtitle: 'Replied: "Tomorrow 2PM works!"',
      timeAgo: '2M AGO',
      isUnread: true,
      avatarColor: Color(0xFFFBDCCD),
    ),
    _NotificationItem(
      title: '💰 Price drop',
      subtitle: 'MacBook Pro now Rs 45,000. Don\'t miss out on this refurbished deal.',
      timeAgo: '1H AGO',
      isUnread: true,
      avatarColor: Colors.black,
    ),
    _NotificationItem(
      title: 'New listing',
      subtitle: 'Dell XPS 15 near you. Inspected and ready for sale in Kathmandu.',
      timeAgo: '4H AGO',
      isUnread: true,
      avatarColor: Color(0xFFEEEEEE),
    ),
  ];

  static const _yesterdayNotifications = [
    _NotificationItem(
      title: 'Saved Search',
      subtitle: 'Your saved search "MacBook" has 3 new results for you to review.',
      timeAgo: 'YESTERDAY, 10:30 AM',
      isUnread: false,
      avatarColor: Color(0xFFE4E2E1),
    ),
    _NotificationItem(
      title: '⚠ Sold Out',
      subtitle: 'Lenovo ThinkPad on wishlist is sold. Check similar items in stock.',
      timeAgo: 'YESTERDAY, 4:15 PM',
      isUnread: false,
      avatarColor: Color(0xFFFFDAD6),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            NotificationHeader(onMarkAllRead: _onMarkAllRead),

            // Scrollable content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                children: [
                  // TODAY section
                  const NotificationSectionHeader(label: 'TODAY'),
                  const SizedBox(height: 12),
                  ..._todayNotifications.map(_buildNotificationCard),

                  const SizedBox(height: 28),

                  // YESTERDAY section
                  const NotificationSectionHeader(label: 'YESTERDAY'),
                  const SizedBox(height: 12),
                  ..._yesterdayNotifications.map(_buildNotificationCard),

                  const SizedBox(height: 28),

                  // All caught up
                  const AllCaughtUpCard(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onMarkAllRead() {
    // TODO: Mark all notifications as read via ViewModel
  }

  Widget _buildNotificationCard(_NotificationItem item) {
    return NotificationCard(
      title: item.title,
      subtitle: item.subtitle,
      timeAgo: item.timeAgo,
      isUnread: item.isUnread,
      avatarColor: item.avatarColor,
    );
  }
}
