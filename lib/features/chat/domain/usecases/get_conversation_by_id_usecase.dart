import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class GetConversationByIdParams extends Equatable {
  final String id;

  const GetConversationByIdParams({required this.id});

  @override
  List<Object?> get props => [id];
}

final getConversationByIdUsecaseProvider =
    Provider<GetConversationByIdUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetConversationByIdUsecase(chatRepository: chatRepository);
});

class GetConversationByIdUsecase
    implements UsecaseWithParams<ChatEntity, GetConversationByIdParams> {
  final IChatRepository _chatRepository;

  GetConversationByIdUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, ChatEntity>> call(GetConversationByIdParams params) {
    return _chatRepository.getConversationById(params.id);
  }
}
