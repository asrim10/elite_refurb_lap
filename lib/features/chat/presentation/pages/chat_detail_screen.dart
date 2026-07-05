import 'package:flutter/material.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_detail_app_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_date_separator.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_listing_card.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_message_model.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_quick_replies.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String? imageUrl;
  final bool isOnline;
  final String laptopTitle;
  final String laptopPrice;
  final String? laptopImage;
  final bool isBuyer;

  const ChatDetailScreen({
    super.key,
    required this.name,
    this.imageUrl,
    this.isOnline = false,
    required this.laptopTitle,
    required this.laptopPrice,
    this.laptopImage,
    this.isBuyer = true,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late final List<ChatMessage> _messages = List.from(
    widget.isBuyer ? buyerMockMessages : sellerMockMessages,
  );

  late final List<String> _quickReplies = List.from(
    widget.isBuyer ? buyerQuickReplies : sellerQuickReplies,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true, time: 'Just now'));
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendQuickReply(String text) {
    setState(() {
      _messages.add(ChatMessage(text: text, isMine: true, time: 'Just now'));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            ChatDetailAppBar(
              name: widget.name,
              imageUrl: widget.imageUrl,
              isOnline: widget.isOnline,
            ),
            ChatListingCard(
              title: widget.laptopTitle,
              price: widget.laptopPrice,
              imageUrl: widget.laptopImage,
            ),
            Expanded(child: _buildMessagesArea()),
            ChatQuickReplies(
              replies: _quickReplies,
              onTap: _sendQuickReply,
            ),
            ChatInputBar(
              controller: _messageController,
              onSend: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesArea() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final showDateSeparator = index == 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDateSeparator)
              ChatDateSeparator(label: message.dateLabel),
            ChatMessageBubble(message: message),
          ],
        );
      },
    );
  }
}
