import 'package:flutter/material.dart';
import 'package:EliteReurbLap/app/theme/app_color.dart';
import 'package:EliteReurbLap/features/chat/presentation/pages/chat_detail_screen.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_filter_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_list_tile.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_preview_model.dart';
import 'package:EliteReurbLap/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:EliteReurbLap/features/laptop/presentation/pages/add_laptop_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  int _selectedFilter = 0;

  @override
  Widget build(BuildContext context) {
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
            Expanded(child: _buildChatList()),
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
        child: Row(
          children: [
            const Icon(Icons.search, size: 18, color: AppColors.textHint),
            const SizedBox(width: 10),
            Text(
              'Search conversations...',
              style: TextStyle(
                color: AppColors.textHint.withValues(alpha: 0.8),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<ChatPreview> _filteredConversations() {
    switch (_selectedFilter) {
      case 0: // ALL MESSAGES
        return mockConversations;
      case 1: // UNREAD
        return mockConversations.where((c) => c.unreadCount > 0).toList();
      case 2: // BUYING
        return mockConversations.where((c) => c.isBuyer).toList();
      case 3: // SELLING
        return mockConversations.where((c) => !c.isBuyer).toList();
      default:
        return mockConversations;
    }
  }

  Widget _buildChatList() {
    final conversations = _filteredConversations();

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
        return ChatListTile(
          name: chat.name,
          lastMessage: chat.lastMessage,
          time: chat.time,
          unreadCount: chat.unreadCount,
          isOnline: chat.isOnline,
          imageUrl: chat.imageUrl,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ChatDetailScreen(
                  name: chat.name,
                  imageUrl: chat.imageUrl,
                  isOnline: chat.isOnline,
                  laptopTitle: chat.laptopTitle,
                  laptopPrice: chat.laptopPrice,
                  isBuyer: chat.isBuyer,
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
