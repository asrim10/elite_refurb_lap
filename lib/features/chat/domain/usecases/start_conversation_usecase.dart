import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class StartConversationParams extends Equatable {
  final String laptopId;
  final String sellerId;
  final String initialMessage;

  const StartConversationParams({
    required this.laptopId,
    required this.sellerId,
    required this.initialMessage,
  });

  @override
  List<Object?> get props => [laptopId, sellerId, initialMessage];
}

final startConversationUsecaseProvider =
    Provider<StartConversationUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return StartConversationUsecase(chatRepository: chatRepository);
});

class StartConversationUsecase
    implements UsecaseWithParams<ChatEntity, StartConversationParams> {
  final IChatRepository _chatRepository;

  StartConversationUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, ChatEntity>> call(StartConversationParams params) {
    return _chatRepository.startConversation(
      laptopId: params.laptopId,
      sellerId: params.sellerId,
      initialMessage: params.initialMessage,
    );
  }
}
