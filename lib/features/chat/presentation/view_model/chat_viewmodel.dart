import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
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
    return const ChatState();
  }

  Future<void> setCurrentUserId(String userId) async {
    state = state.copyWith(currentUserId: userId);
  }

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
    if (hasError) return;

    if (existingConversation != null) {
      state = state.copyWith(
        status: ChatStatus.loaded,
        selectedConversation: existingConversation,
      );
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
      (conversation) => state = state.copyWith(
        status: ChatStatus.loaded,
        selectedConversation: conversation,
        conversations: [conversation, ...state.conversations],
      ),
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
      (conversation) => state = state.copyWith(
        status: ChatStatus.loaded,
        selectedConversation: conversation,
        conversations: [conversation, ...state.conversations],
      ),
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

  Future<void> markAsRead(String conversationId) async {
    final result = await _markAsReadUsecase(
      MarkAsReadParams(conversationId: conversationId),
    );

    result.fold(
      (failure) => null, // Silently fail — non-critical operation
      (_) {
        final updatedConversations = state.conversations.map((c) {
          if (c.id == conversationId) {
            return ChatEntity(
              id: c.id,
              laptopId: c.laptopId,
              buyerId: c.buyerId,
              sellerId: c.sellerId,
              lastMessage: c.lastMessage,
              lastMessageAt: c.lastMessageAt,
              lastMessageSender: c.lastMessageSender,
              buyerUnreadCount: c.buyerId == state.currentUserId ? 0 : c.buyerUnreadCount,
              sellerUnreadCount: c.sellerId == state.currentUserId ? 0 : c.sellerUnreadCount,
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

        state = state.copyWith(conversations: updatedConversations);
      },
    );
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
}
