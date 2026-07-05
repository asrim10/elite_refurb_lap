import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesParams extends Equatable {
  final String conversationId;
  final int page;
  final int size;

  const GetMessagesParams({
    required this.conversationId,
    this.page = 1,
    this.size = 50,
  });

  @override
  List<Object?> get props => [conversationId, page, size];
}

final getMessagesUsecaseProvider = Provider<GetMessagesUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetMessagesUsecase(chatRepository: chatRepository);
});

class GetMessagesUsecase
    implements UsecaseWithParams<List<MessageEntity>, GetMessagesParams> {
  final IChatRepository _chatRepository;

  GetMessagesUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetMessagesParams params) {
    return _chatRepository.getMessages(
      conversationId: params.conversationId,
      page: params.page,
      size: params.size,
    );
  }
}
