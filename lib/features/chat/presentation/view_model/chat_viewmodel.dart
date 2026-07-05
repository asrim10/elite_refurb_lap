import 'dart:async';

import 'package:EliteReurbLap/features/chat/data/services/chat_socket_service.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/archive_conversation_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/get_conversation_by_id_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/get_conversation_by_laptop_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/mark_as_read_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:EliteReurbLap/features/chat/domain/usecases/start_conversation_usecase.dart';
import 'package:EliteReurbLap/features/chat/presentation/state/chat_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatViewModelProvider = NotifierProvider<ChatViewModel, ChatState>(
  () => ChatViewModel(),
);

class ChatViewModel extends Notifier<ChatState> {
  late final StartConversationUsecase _startConversationUsecase;
  late final GetConversationsUsecase _getConversationsUsecase;
  late final GetConversationByIdUsecase _getConversationByIdUsecase;
  late final GetConversationByLaptopUsecase _getConversationByLaptopUsecase;
  late final GetMessagesUsecase _getMessagesUsecase;
  late final SendMessageUsecase _sendMessageUsecase;
  late final MarkAsReadUsecase _markAsReadUsecase;
  late final ArchiveConversationUsecase _archiveConversationUsecase;

  late final ChatSocketService _socketService;

  StreamSubscription<MessageEntity>? _newMessageSub;
  StreamSubscription<ConversationUpdateEvent>? _conversationUpdatedSub;
  StreamSubscription<ConversationReadEvent>? _conversationReadSub;
  StreamSubscription<TypingEvent>? _typingStartSub;
  StreamSubscription<TypingEvent>? _typingStopSub;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<String>? _errorSub;

  @override
  ChatState build() {
    _startConversationUsecase = ref.read(startConversationUsecaseProvider);
    _getConversationsUsecase = ref.read(getConversationsUsecaseProvider);
    _getConversationByIdUsecase = ref.read(getConversationByIdUsecaseProvider);
    _getConversationByLaptopUsecase =
        ref.read(getConversationByLaptopUsecaseProvider);
    _getMessagesUsecase = ref.read(getMessagesUsecaseProvider);
    _sendMessageUsecase = ref.read(sendMessageUsecaseProvider);
    _markAsReadUsecase = ref.read(markAsReadUsecaseProvider);
    _archiveConversationUsecase = ref.read(archiveConversationUsecaseProvider);

    _socketService = ref.read(chatSocketServiceProvider);

    // Register socket event listeners
    _newMessageSub = _socketService.onNewMessage.listen(_onNewMessage);
    _conversationUpdatedSub =
        _socketService.onConversationUpdated.listen(_onConversationUpdated);
    _conversationReadSub =
        _socketService.onConversationRead.listen(_onConversationRead);
    _typingStartSub = _socketService.onTypingStart.listen(_onTypingStart);
    _typingStopSub = _socketService.onTypingStop.listen(_onTypingStop);
    _connectionSub = _socketService.onConnectionStatus.listen(_onConnectionChange);
    _errorSub = _socketService.onError.listen((msg) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: msg,
      );
    });

    // Clean up subscriptions when the provider is disposed
    ref.onDispose(() {
      _newMessageSub?.cancel();
      _conversationUpdatedSub?.cancel();
      _conversationReadSub?.cancel();
      _typingStartSub?.cancel();
      _typingStopSub?.cancel();
      _connectionSub?.cancel();
      _errorSub?.cancel();
      _socketService.disconnect();
    });

    return const ChatState();
  }

  // ---- Socket lifecycle ----

  /// Set the current user ID and automatically connect the socket.
  Future<void> setCurrentUserId(String userId) async {
    state = state.copyWith(currentUserId: userId);
    if (userId.isNotEmpty) {
      await _socketService.connect();
    }
  }

  /// Manually connect/reconnect the socket.
  Future<void> connectSocket() => _socketService.connect();

  /// Disconnect the socket.
  void disconnectSocket() => _socketService.disconnect();

  // ---- Room management ----

  /// Join a conversation's room to receive real-time messages.
  void joinConversation(String conversationId) {
    _socketService.joinConversation(conversationId);
  }

  /// Leave a conversation's room.
  void leaveConversation(String conversationId) {
    _socketService.leaveConversation(conversationId);
  }

  // ---- REST-based data loading (kept for initial loads) ----

  Future<void> getConversations({int page = 1, int size = 20}) async {
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _getConversationsUsecase(
      GetConversationsParams(page: page, size: size),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (conversations) => state = state.copyWith(
        status: ChatStatus.loaded,
        conversations: conversations,
      ),
    );
  }

  Future<void> getConversationById(String id) async {
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _getConversationByIdUsecase(
      GetConversationByIdParams(id: id),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (conversation) => state = state.copyWith(
        status: ChatStatus.loaded,
        selectedConversation: conversation,
      ),
    );
  }

  Future<void> getOrCreateConversationByLaptop({
    required String laptopId,
    required String sellerId,
    String? initialMessage,
  }) async {
    state = state.copyWith(status: ChatStatus.loading);

    // Check if conversation exists for this laptop
    final existingResult = await _getConversationByLaptopUsecase(
      GetConversationByLaptopParams(laptopId: laptopId),
    );

    // Propagate API errors from the lookup instead of silently swallowing
    ChatEntity? existingConversation;
    final hasError = existingResult.fold(
      (failure) {
        state = state.copyWith(
          status: ChatStatus.error,
          errorMessage: failure.message,
        );
        return true;
      },
      (conversation) {
        existingConversation = conversation;
        return false;
      },
    );
    if (hasError) return;      if (existingConversation != null) {
      state = state.copyWith(
        status: ChatStatus.loaded,
        selectedConversation: existingConversation,
      );
      // Join the conversation room for real-time updates
      final convoId = existingConversation?.id;
      if (convoId != null) {
        joinConversation(convoId);
      }
      return;
    }

    // No existing conversation — start one
    if (initialMessage == null) {
      state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: 'Initial message is required to start a conversation',
      );
      return;
    }

    final result = await _startConversationUsecase(
      StartConversationParams(
        laptopId: laptopId,
        sellerId: sellerId,
        initialMessage: initialMessage,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (conversation) {
        state = state.copyWith(
          status: ChatStatus.loaded,
          selectedConversation: conversation,
          conversations: [conversation, ...state.conversations],
        );
        final convoId = conversation.id;
        if (convoId != null) {
          joinConversation(convoId);
        }
      },
    );
  }

  Future<void> startConversation({
    required String laptopId,
    required String sellerId,
    required String initialMessage,
  }) async {
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _startConversationUsecase(
      StartConversationParams(
        laptopId: laptopId,
        sellerId: sellerId,
        initialMessage: initialMessage,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (conversation) {
        state = state.copyWith(
          status: ChatStatus.loaded,
          selectedConversation: conversation,
          conversations: [conversation, ...state.conversations],
        );
        final convoId = conversation.id;
        if (convoId != null) {
          joinConversation(convoId);
        }
      },
    );
  }

  Future<void> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  }) async {
    state = state.copyWith(status: ChatStatus.loading);

    final result = await _getMessagesUsecase(
      GetMessagesParams(
        conversationId: conversationId,
        page: page,
        size: size,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (messages) => state = state.copyWith(
        status: ChatStatus.messagesLoaded,
        messages: messages,
      ),
    );
  }

  // ---- Socket-based actions (preferred for real-time) ----

  /// Send a message via Socket.IO.
  /// The server persists it and broadcasts `new:message` back to the room.
  /// The [_onNewMessage] handler adds the returned message to state.
  void sendSocketMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
  }) {
    _socketService.sendMessage(
      conversationId: conversationId,
      content: content,
      messageType: messageType,
    );
  }

  /// Mark conversation as read via Socket.IO.
  void markAsReadViaSocket(String conversationId) {
    _socketService.markAsRead(conversationId);
  }

  /// Fallback REST-based send message (if socket is unavailable).
  Future<void> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
  }) async {
    final result = await _sendMessageUsecase(
      SendMessageParams(
        conversationId: conversationId,
        content: content,
        messageType: messageType,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (message) => state = state.copyWith(
        status: ChatStatus.sent,
        messages: [...state.messages, message],
      ),
    );
  }

  /// Fallback REST-based mark as read.
  Future<void> markAsRead(String conversationId) async {
    final result = await _markAsReadUsecase(
      MarkAsReadParams(conversationId: conversationId),
    );

    result.fold(
      (failure) => null,
      (_) => _updateConversationUnread(conversationId, 0),
    );
  }

  // ---- Typing indicators ----

  /// Notify others the current user started typing in a conversation.
  void startTyping(String conversationId) {
    _socketService.startTyping(conversationId);
  }

  /// Notify others the current user stopped typing.
  void stopTyping(String conversationId) {
    _socketService.stopTyping(conversationId);
  }

  /// Whether a given user is typing in a given conversation.
  bool isUserTyping(String conversationId, String userId) {
    final users = state.typingUsers[conversationId];
    if (users == null) return false;
    return users.contains(userId);
  }

  Future<void> archiveConversation(String conversationId) async {
    final result = await _archiveConversationUsecase(
      ArchiveConversationParams(conversationId: conversationId),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ChatStatus.archived,
        conversations:
            state.conversations.where((c) => c.id != conversationId).toList(),
        selectedConversation: state.selectedConversation?.id == conversationId
            ? null
            : state.selectedConversation,
      ),
    );
  }

  // ---- Socket event handlers ----

  void _onNewMessage(MessageEntity message) {
    // Add message to the messages list if we're viewing that conversation
    final currentConvoId = state.selectedConversation?.id;
    if (currentConvoId != null &&
        message.conversationId == currentConvoId) {
      // Avoid duplicates (in case of optimistic + server response race)
      final alreadyExists =
          state.messages.any((m) => m.id != null && m.id == message.id);
      if (!alreadyExists) {
        state = state.copyWith(
          status: ChatStatus.messagesLoaded,
          messages: [...state.messages, message],
        );
      }
    }

    // Update the conversation preview (last message, timestamp, etc.)
    _updateConversationPreview(message);
  }

  void _onConversationUpdated(ConversationUpdateEvent event) {
    _updateConversationPreviewFromEvent(event);
  }

  void _onConversationRead(ConversationReadEvent event) {
    // Reset unread count for the conversation
    _updateConversationUnread(event.conversationId, 0);
  }

  void _onTypingStart(TypingEvent event) {
    // Don't track the current user's own typing status
    if (event.userId == state.currentUserId) return;

    final updatedTyping = Map<String, List<String>>.from(state.typingUsers);
    final users = List<String>.from(updatedTyping[event.conversationId] ?? []);
    if (!users.contains(event.userId)) {
      users.add(event.userId);
    }
    updatedTyping[event.conversationId] = users;

    state = state.copyWith(typingUsers: updatedTyping);
  }

  void _onTypingStop(TypingEvent event) {
    if (event.userId == state.currentUserId) return;

    final updatedTyping = Map<String, List<String>>.from(state.typingUsers);
    final users = List<String>.from(updatedTyping[event.conversationId] ?? []);
    users.remove(event.userId);
    if (users.isEmpty) {
      updatedTyping.remove(event.conversationId);
    } else {
      updatedTyping[event.conversationId] = users;
    }

    state = state.copyWith(typingUsers: updatedTyping);
  }

  void _onConnectionChange(bool connected) {
    state = state.copyWith(socketConnected: connected);
  }

  // ---- Helper methods ----

  void _updateConversationPreview(MessageEntity message) {
    final updatedList = state.conversations.map((c) {
      if (c.id == message.conversationId && c.id != null) {
        return ChatEntity(
          id: c.id,
          laptopId: c.laptopId,
          buyerId: c.buyerId,
          sellerId: c.sellerId,
          lastMessage: message.content,
          lastMessageAt: message.createdAt ?? DateTime.now(),
          lastMessageSender: message.senderId,
          // Unread count handled by _onConversationUpdated to avoid double-counting
          buyerUnreadCount: c.buyerUnreadCount,
          sellerUnreadCount: c.sellerUnreadCount,
          status: c.status,
          laptopTitle: c.laptopTitle,
          laptopPrice: c.laptopPrice,
          laptopImage: c.laptopImage,
          otherParticipantName: c.otherParticipantName,
          otherParticipantImage: c.otherParticipantImage,
          createdAt: c.createdAt,
          updatedAt: message.createdAt ?? c.updatedAt,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(conversations: updatedList);
  }

  void _updateConversationPreviewFromEvent(ConversationUpdateEvent event) {
    final updatedList = state.conversations.map((c) {
      if (c.id == event.conversationId && c.id != null) {
        final isFromOther = event.lastMessageSender != state.currentUserId;
        return ChatEntity(
          id: c.id,
          laptopId: c.laptopId,
          buyerId: c.buyerId,
          sellerId: c.sellerId,
          lastMessage: event.lastMessage ?? c.lastMessage,
          lastMessageAt: event.lastMessageAt ?? c.lastMessageAt,
          lastMessageSender: event.lastMessageSender ?? c.lastMessageSender,
          buyerUnreadCount: isFromOther ? c.buyerUnreadCount + 1 : c.buyerUnreadCount,
          sellerUnreadCount: isFromOther ? c.sellerUnreadCount + 1 : c.sellerUnreadCount,
          status: c.status,
          laptopTitle: c.laptopTitle,
          laptopPrice: c.laptopPrice,
          laptopImage: c.laptopImage,
          otherParticipantName: c.otherParticipantName,
          otherParticipantImage: c.otherParticipantImage,
          createdAt: c.createdAt,
          updatedAt: event.lastMessageAt ?? c.updatedAt,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(conversations: updatedList);
  }

  void _updateConversationUnread(String conversationId, int count) {
    final updatedList = state.conversations.map((c) {
      if (c.id == conversationId && c.id != null) {
        return ChatEntity(
          id: c.id,
          laptopId: c.laptopId,
          buyerId: c.buyerId,
          sellerId: c.sellerId,
          lastMessage: c.lastMessage,
          lastMessageAt: c.lastMessageAt,
          lastMessageSender: c.lastMessageSender,
          buyerUnreadCount: c.buyerId == state.currentUserId ? count : c.buyerUnreadCount,
          sellerUnreadCount: c.sellerId == state.currentUserId ? count : c.sellerUnreadCount,
          status: c.status,
          laptopTitle: c.laptopTitle,
          laptopPrice: c.laptopPrice,
          laptopImage: c.laptopImage,
          otherParticipantName: c.otherParticipantName,
          otherParticipantImage: c.otherParticipantImage,
          createdAt: c.createdAt,
          updatedAt: c.updatedAt,
        );
      }
      return c;
    }).toList();

    state = state.copyWith(conversations: updatedList);
  }
}
