import 'package:dartz/dartz.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';

abstract interface class IChatRepository {
  Future<Either<Failure, ChatEntity>> startConversation({
    required String laptopId,
    required String sellerId,
    required String initialMessage,
  });

  Future<Either<Failure, List<ChatEntity>>> getConversations({
    int page = 1,
    int size = 20,
  });

  Future<Either<Failure, ChatEntity>> getConversationById(String id);

  Future<Either<Failure, ChatEntity?>> getConversationByLaptop(
    String laptopId,
  );

  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  });

  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
  });

  Future<Either<Failure, void>> markAsRead(String conversationId);

  Future<Either<Failure, void>> archiveConversation(String conversationId);
}
