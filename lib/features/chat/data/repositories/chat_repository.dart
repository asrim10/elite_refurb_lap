import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/chat/data/datasources/chat_datasource.dart';
import 'package:EliteReurbLap/features/chat/data/datasources/remote/chat_remote_datasource.dart';
import 'package:EliteReurbLap/features/chat/data/models/chat_api_model.dart';
import 'package:EliteReurbLap/features/chat/data/models/message_api_model.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<IChatRepository>((ref) {
  return ChatRepository(
    remoteDataSource: ref.read(chatRemoteDatasourceProvider),
  );
});

class ChatRepository implements IChatRepository {
  final IChatRemoteDataSource _remoteDataSource;

  ChatRepository({
    required IChatRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ChatEntity>> startConversation({
    required String laptopId,
    required String sellerId,
    required String initialMessage,
  }) async {
    try {
      final model = await _remoteDataSource.startConversation(
        laptopId: laptopId,
        sellerId: sellerId,
        initialMessage: initialMessage,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<ChatEntity>>> getConversations({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getConversations(
        page: page,
        size: size,
      );
      return Right(ChatApiModel.toEntityList(models));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getConversationById(String id) async {
    try {
      final model = await _remoteDataSource.getConversationById(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, ChatEntity?>> getConversationByLaptop(
    String laptopId,
  ) async {
    try {
      final model = await _remoteDataSource.getConversationByLaptop(laptopId);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages({
    required String conversationId,
    int page = 1,
    int size = 50,
  }) async {
    try {
      final models = await _remoteDataSource.getMessages(
        conversationId: conversationId,
        page: page,
        size: size,
      );
      return Right(MessageApiModel.toEntityList(models));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
  }) async {
    try {
      final model = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        content: content,
        messageType: messageType,
      );
      return Right(model.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      await _remoteDataSource.markAsRead(conversationId);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> archiveConversation(
    String conversationId,
  ) async {
    try {
      await _remoteDataSource.archiveConversation(conversationId);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(Object e) {
    if (e is DioException) {
      final message = e.response?.data?['message'] as String? ??
          e.message ??
          'Chat operation failed';
      return ApiFailure(message: message, statusCode: e.response?.statusCode);
    }
    return ApiFailure(message: e.toString());
  }
}
