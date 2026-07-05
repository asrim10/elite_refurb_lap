import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:EliteReurbLap/features/chat/presentation/state/chat_state.dart';
import 'package:EliteReurbLap/features/chat/presentation/view_model/chat_viewmodel.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_date_separator.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_detail_app_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_input_bar.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_listing_card.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_message_bubble.dart';
import 'package:EliteReurbLap/features/chat/presentation/widgets/chat_quick_replies.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String conversationId;
  final String otherParticipantName;
  final String? otherParticipantImage;
  final bool isOnline;
  final bool isBuyer;
  final String laptopTitle;
  final String laptopPrice;
  final String? laptopImage;

  const ChatDetailScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantName,
    this.otherParticipantImage,
    this.isOnline = false,
    this.isBuyer = true,
    required this.laptopTitle,
    required this.laptopPrice,
    this.laptopImage,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  // Quick replies based on role
  late final List<String> _quickReplies = widget.isBuyer
      ? [
          'Is this available?',
          'Can I see more photos?',
          'What is the lowest price?',
          'When can I pick it up?',
        ]
      : [
          'Yes, it\'s still available',
          'I can do NPR 1,100',
          'Sure, let me send more photos',
          'I\'m available this weekend',
        ];

  @override
  void initState() {
    super.initState();
    if (widget.conversationId.isNotEmpty) {
      Future.microtask(() {
        final vm = ref.read(chatViewModelProvider.notifier);
        vm.getMessages(conversationId: widget.conversationId);
        vm.joinConversation(widget.conversationId);
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    if (widget.conversationId.isNotEmpty) {
      ref.read(chatViewModelProvider.notifier).leaveConversation(
            widget.conversationId,
          );
    }
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || widget.conversationId.isEmpty) return;

    // Stop typing indicator
    if (_isTyping) {
      ref.read(chatViewModelProvider.notifier).stopTyping(
            widget.conversationId,
          );
      _isTyping = false;
    }

    // Send via socket (preferred) with REST fallback
    final vm = ref.read(chatViewModelProvider.notifier);
    if (ref.read(chatViewModelProvider).socketConnected) {
      vm.sendSocketMessage(
        conversationId: widget.conversationId,
        content: text,
      );
    } else {
      vm.sendMessage(
        conversationId: widget.conversationId,
        content: text,
      );
    }

    _messageController.clear();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _sendQuickReply(String text) {
    if (widget.conversationId.isEmpty) return;

    final vm = ref.read(chatViewModelProvider.notifier);
    if (ref.read(chatViewModelProvider).socketConnected) {
      vm.sendSocketMessage(
        conversationId: widget.conversationId,
        content: text,
      );
    } else {
      vm.sendMessage(
        conversationId: widget.conversationId,
        content: text,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _onTextChanged(String value) {
    if (widget.conversationId.isEmpty) return;
    if (value.isNotEmpty && !_isTyping) {
      _isTyping = true;
      ref.read(chatViewModelProvider.notifier).startTyping(
            widget.conversationId,
          );
    } else if (value.isEmpty && _isTyping) {
      _isTyping = false;
      ref.read(chatViewModelProvider.notifier).stopTyping(
            widget.conversationId,
          );
    }
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

  String _formatDateLabel(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final timeStr = DateFormat('h:mm a').format(dateTime);

    if (date == today) {
      return 'Today · $timeStr';
    } else if (date == today.subtract(const Duration(days: 1))) {
      return 'Yesterday · $timeStr';
    } else {
      return '${DateFormat('MMM d').format(dateTime)} · $timeStr';
    }
  }

  bool _shouldShowDateSeparator(int index, List<MessageEntity> messages) {
    if (index == 0) return true;
    final current = messages[index].createdAt;
    final previous = messages[index - 1].createdAt;
    if (current == null || previous == null) return false;
    // Show separator if they're on different days
    final currentDay = DateTime(current.year, current.month, current.day);
    final previousDay = DateTime(previous.year, previous.month, previous.day);
    return currentDay != previousDay;
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatViewModelProvider);
    final messages = chatState.messages;

    // Auto-scroll when new messages arrive
    if (messages.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0EC),
      body: SafeArea(
        child: Column(
          children: [
            ChatDetailAppBar(
              name: widget.otherParticipantName,
              imageUrl: widget.otherParticipantImage,
              isOnline: widget.isOnline,
            ),
            ChatListingCard(
              title: widget.laptopTitle,
              price: widget.laptopPrice,
              imageUrl: widget.laptopImage,
            ),
            Expanded(child: _buildMessagesArea(chatState, messages)),
            ChatQuickReplies(
              replies: _quickReplies,
              onTap: _sendQuickReply,
            ),
            ChatInputBar(
              controller: _messageController,
              onSend: _sendMessage,
              onTextChanged: _onTextChanged,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessagesArea(ChatState chatState, List<MessageEntity> messages) {
    if (chatState.status == ChatStatus.loading && messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatState.status == ChatStatus.error && messages.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48,
                  color: Color(0xFF848383)),
              const SizedBox(height: 16),
              Text(
                chatState.errorMessage ?? 'Could not load messages',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4B454A),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  ref
                      .read(chatViewModelProvider.notifier)
                      .getMessages(conversationId: widget.conversationId);
                },
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (messages.isEmpty) {
      return const Center(
        child: Text(
          'No messages yet. Start the conversation!',
          style: TextStyle(
            color: Color(0xFF848383),
            fontSize: 14,
          ),
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final showDateSeparator = _shouldShowDateSeparator(index, messages);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showDateSeparator)
              ChatDateSeparator(
                label: _formatDateLabel(message.createdAt),
              ),
            ChatMessageBubble(
              message: message,
              currentUserId: chatState.currentUserId,
            ),
          ],
        );
      },
    );
  }
}
