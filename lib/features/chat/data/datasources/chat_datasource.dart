import 'package:dio/dio.dart';
import 'package:EliteReurbLap/features/chat/data/models/chat_api_model.dart';
import 'package:EliteReurbLap/features/chat/data/models/message_api_model.dart';

abstract interface class IChatRemoteDataSource {
  Future<ChatApiModel> startConversation({
    required String laptopId,
    required String sellerId,
    required String initialMessage,
  });

  Future<List<ChatApiModel>> getConversations({
    int page = 1,
    int size = 20,
  });

  Future<ChatApiModel> getConversationById(String id);

  Future<ChatApiModel?> getConversationByLaptop(String laptopId);

  Future<List<MessageApiModel>> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  });

  Future<MessageApiModel> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    MultipartFile? file,
  });

  Future<void> markAsRead(String conversationId);

  Future<void> archiveConversation(String conversationId);
}
