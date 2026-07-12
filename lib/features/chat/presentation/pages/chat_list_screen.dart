import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/core/services/storage/user_session_service.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:EliteReurbLap/features/chat/presentation/state/chat_state.dart';
import 'package:EliteReurbLap/features/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_filter_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_list_tile.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      // 1. Set currentUserId and refresh socket BEFORE loading conversations
      final sessionService = ref.read(userSessionServiceProvider);
      final userId = sessionService.getCurrentUserId();
      if (userId != null && userId.isNotEmpty) {
        await ref.read(chatViewModelProvider.notifier).setCurrentUserId(userId);
      }

      // 2. Load conversations (socket is fresh if user switched)
      await ref.read(chatViewModelProvider.notifier).getConversations();
    });
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final local = dateTime.toLocal();
    final now = DateTime.now();
    final diff = now.difference(local);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return DateFormat('MMM d').format(dateTime);
    }
  }

  int _unreadForCurrentUser(ChatEntity chat, String currentUserId) {
    if (currentUserId.isEmpty) return 0;
    if (chat.buyerId == currentUserId) return chat.buyerUnreadCount;
    if (chat.sellerId == currentUserId) return chat.sellerUnreadCount;
    return 0;
  }

  bool _isCurrentUserBuyer(ChatEntity chat, String currentUserId) {
    return chat.buyerId == currentUserId;
  }

  List<ChatEntity> _filteredConversations(ChatState chatState) {
    final conversations = chatState.conversations;
    switch (_selectedFilter) {
      case 0: // ALL MESSAGES
        return conversations;
      case 1: // UNREAD
        return conversations.where((c) => _unreadForCurrentUser(c, chatState.currentUserId) > 0).toList();
      case 2: // BUYING
        return conversations.where((c) => c.buyerId == chatState.currentUserId).toList();
      case 3: // SELLING
        return conversations.where((c) => c.sellerId == chatState.currentUserId).toList();
      default:
        return conversations;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            ChatFilterBar(
              selectedIndex: _selectedFilter,
              onFilterChanged: (index) =>
                  setState(() => _selectedFilter = index),
            ),
            Expanded(child: _buildChatList(chatState)),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavBar(
        selectedIndex: 3,
        onTabChanged: (index) {
          if (index == 2) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const AddLaptopScreen(),
              ),
            );
          } else if (index != 3) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: Container(
        width: double.infinity,
        height: 60,
        decoration: const ShapeDecoration(
          color: Color(0xFFF9F9F9),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: Color(0xFFCDC4CA)),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back, color: Colors.black),
            ),
            const Spacer(),
            const Text(
              'Messages',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_horiz, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Container(
        width: double.infinity,
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: AppColors.border),
            borderRadius: BorderRadius.circular(9999),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.search, size: 18, color: AppColors.textHint),
            SizedBox(width: 10),
            Text(
              'Search conversations...',
              style: TextStyle(
                color: AppColors.textHint,
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatList(ChatState chatState) {
    if (chatState.status == ChatStatus.loading && chatState.conversations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatState.status == ChatStatus.error && chatState.conversations.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.textDisabled),
              const SizedBox(height: 16),
              Text(
                chatState.errorMessage ?? 'Something went wrong',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.read(chatViewModelProvider.notifier).getConversations(),
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    final conversations = _filteredConversations(chatState);

    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const ShapeDecoration(
                color: AppColors.surfaceVariant,
                shape: CircleBorder(),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                size: 36,
                color: AppColors.textDisabled,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No messages yet',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _emptyStateMessage(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textHint,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                height: 1.4,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: conversations.length,
      separatorBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(left: 72),
        child: Divider(height: 1, color: AppColors.divider),
      ),
      itemBuilder: (context, index) {
        final chat = conversations[index];
        final unread = _unreadForCurrentUser(chat, chatState.currentUserId);
        final isBuyer = _isCurrentUserBuyer(chat, chatState.currentUserId);
        final otherName = chat.resolveOtherName(chatState.currentUserId) ?? 'Unknown';
        final otherImage = chat.resolveOtherImage(chatState.currentUserId);

        return ChatListTile(
          name: otherName,
          lastMessage: chat.lastMessage ?? '',
          time: _formatTime(chat.lastMessageAt),
          unreadCount: unread,
          isOnline: false,
          imageUrl: otherImage,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(
                  conversationId: chat.id ?? '',
                  otherParticipantName: otherName,
                  otherParticipantImage: otherImage,
                  isOnline: false,
                  isBuyer: isBuyer,
                  laptopTitle: chat.laptopTitle ?? 'Laptop',
                  laptopPrice: chat.laptopPrice ?? '',
                  laptopImage: chat.laptopImage,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _emptyStateMessage() {
    switch (_selectedFilter) {
      case 1:
        return 'No unread messages.';
      case 2:
        return 'No active buying conversations.\nBrowse laptops and message a seller!';
      case 3:
        return 'No active selling conversations.\nList a laptop to start receiving inquiries!';
      default:
        return 'No conversations yet.\nBrowse laptops to buy, or list one to start selling!';
    }
  }
}
