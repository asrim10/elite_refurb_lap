import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class ArchiveConversationParams extends Equatable {
  final String conversationId;

  const ArchiveConversationParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

final archiveConversationUsecaseProvider =
    Provider<ArchiveConversationUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return ArchiveConversationUsecase(chatRepository: chatRepository);
});

class ArchiveConversationUsecase
    implements UsecaseWithParams<void, ArchiveConversationParams> {
  final IChatRepository _chatRepository;

  ArchiveConversationUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, void>> call(ArchiveConversationParams params) {
    return _chatRepository.archiveConversation(params.conversationId);
  }
}
