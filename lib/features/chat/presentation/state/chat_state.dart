import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:equatable/equatable.dart';

enum ChatStatus {
  initial,
  loading,
  loaded,
  messagesLoaded,
  sent,
  archived,
  error,
}

class ChatState extends Equatable {
  final ChatStatus status;
  final List<ChatEntity> conversations;
  final ChatEntity? selectedConversation;
  final List<MessageEntity> messages;
  final String? errorMessage;
  final String currentUserId;
  final bool socketConnected;

  /// Maps conversationId -> list of userIds currently typing in that conversation.
  final Map<String, List<String>> typingUsers;

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.selectedConversation,
    this.messages = const [],
    this.errorMessage,
    this.currentUserId = '',
    this.socketConnected = false,
    this.typingUsers = const {},
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatEntity>? conversations,
    ChatEntity? selectedConversation,
    List<MessageEntity>? messages,
    String? errorMessage,
    String? currentUserId,
    bool? socketConnected,
    Map<String, List<String>>? typingUsers,
    bool clearMessages = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      selectedConversation: selectedConversation ?? this.selectedConversation,
      messages: clearMessages ? [] : (messages ?? this.messages),
      errorMessage: errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
      socketConnected: socketConnected ?? this.socketConnected,
      typingUsers: typingUsers ?? this.typingUsers,
    );
  }

  @override
  List<Object?> get props => [
        status,
        conversations,
        selectedConversation,
        messages,
        errorMessage,
        currentUserId,
        socketConnected,
        typingUsers,
      ];
}
