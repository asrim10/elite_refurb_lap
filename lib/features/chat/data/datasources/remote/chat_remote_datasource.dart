import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/chat/data/datasources/chat_datasource.dart';
import 'package:EliteReurbLap/features/chat/data/models/chat_api_model.dart';
import 'package:EliteReurbLap/features/chat/data/models/message_api_model.dart';

final chatRemoteDatasourceProvider = Provider<IChatRemoteDataSource>((ref) {
  return ChatRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class ChatRemoteDatasource implements IChatRemoteDataSource {
  final ApiClient _apiClient;

  ChatRemoteDatasource({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<ChatApiModel> startConversation({
    required String laptopId,
    required String sellerId,
    required String initialMessage,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.chats,
      data: {
        'laptopId': laptopId,
        'sellerId': sellerId,
        'initialMessage': initialMessage,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ChatApiModel.fromJson(data);
  }

  @override
  Future<List<ChatApiModel>> getConversations({
    int page = 1,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.chats,
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => ChatApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<ChatApiModel> getConversationById(String id) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.chatById}$id',
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return ChatApiModel.fromJson(data);
  }

  @override
  Future<ChatApiModel?> getConversationByLaptop(String laptopId) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.chatByLaptop}$laptopId',
    );
    final data = response.data['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    return ChatApiModel.fromJson(data);
  }

  @override
  Future<List<MessageApiModel>> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.chatById}$conversationId/messages',
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => MessageApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<MessageApiModel> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    MultipartFile? file,
  }) async {
    if (file != null) {
      final formData = FormData.fromMap({
        'content': content,
        'messageType': messageType,
        'file': file,
      });
      final response = await _apiClient.dio.post(
        '${ApiEndpoints.chatById}$conversationId/messages',
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
        ),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return MessageApiModel.fromJson(data);
    }

    final response = await _apiClient.post(
      '${ApiEndpoints.chatById}$conversationId/messages',
      data: {
        'content': content,
        'messageType': messageType,
      },
    );
    final data = response.data['data'] as Map<String, dynamic>;
    return MessageApiModel.fromJson(data);
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    await _apiClient.patch(
      '${ApiEndpoints.chatById}$conversationId/read',
    );
  }

  @override
  Future<void> archiveConversation(String conversationId) async {
    await _apiClient.patch(
      '${ApiEndpoints.chatById}$conversationId/archive',
    );
  }
}
