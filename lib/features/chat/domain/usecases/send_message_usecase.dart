import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class SendMessageParams extends Equatable {
  final String conversationId;
  final String content;
  final String messageType;

  const SendMessageParams({
    required this.conversationId,
    required this.content,
    this.messageType = 'text',
  });

  @override
  List<Object?> get props => [conversationId, content, messageType];
}

final sendMessageUsecaseProvider = Provider<SendMessageUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return SendMessageUsecase(chatRepository: chatRepository);
});

class SendMessageUsecase
    implements UsecaseWithParams<MessageEntity, SendMessageParams> {
  final IChatRepository _chatRepository;

  SendMessageUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) {
    return _chatRepository.sendMessage(
      conversationId: params.conversationId,
      content: params.content,
      messageType: params.messageType,
    );
  }
}
