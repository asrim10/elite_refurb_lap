import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class GetConversationByLaptopParams extends Equatable {
  final String laptopId;

  const GetConversationByLaptopParams({required this.laptopId});

  @override
  List<Object?> get props => [laptopId];
}

final getConversationByLaptopUsecaseProvider =
    Provider<GetConversationByLaptopUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return GetConversationByLaptopUsecase(chatRepository: chatRepository);
});

class GetConversationByLaptopUsecase
    implements
        UsecaseWithParams<ChatEntity?, GetConversationByLaptopParams> {
  final IChatRepository _chatRepository;

  GetConversationByLaptopUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, ChatEntity?>> call(
      GetConversationByLaptopParams params) {
    return _chatRepository.getConversationByLaptop(params.laptopId);
  }
}
