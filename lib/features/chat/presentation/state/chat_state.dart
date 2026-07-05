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

  const ChatState({
    this.status = ChatStatus.initial,
    this.conversations = const [],
    this.selectedConversation,
    this.messages = const [],
    this.errorMessage,
    this.currentUserId = '',
  });

  ChatState copyWith({
    ChatStatus? status,
    List<ChatEntity>? conversations,
    ChatEntity? selectedConversation,
    List<MessageEntity>? messages,
    String? errorMessage,
    String? currentUserId,
    bool clearMessages = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      conversations: conversations ?? this.conversations,
      selectedConversation: selectedConversation ?? this.selectedConversation,
      messages: clearMessages ? [] : (messages ?? this.messages),
      errorMessage: errorMessage,
      currentUserId: currentUserId ?? this.currentUserId,
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
      ];
}
