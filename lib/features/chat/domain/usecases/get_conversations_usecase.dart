import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class GetConversationsParams extends Equatable {
  final int page;
  final int size;

  const GetConversationsParams({this.page = 1, this.size = 20});

  @override
  List<Object?> get props => [page, size];
}

final getConversationsUsecaseProvider =
    Provider<GetConversationsUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetConversationsUsecase(chatRepository: chatRepository);
});

class GetConversationsUsecase
    implements UsecaseWithParams<List<ChatEntity>, GetConversationsParams> {
  final IChatRepository _chatRepository;

  GetConversationsUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, List<ChatEntity>>> call(
      GetConversationsParams params) {
    return _chatRepository.getConversations(
      page: params.page,
      size: params.size,
    );
  }
}
