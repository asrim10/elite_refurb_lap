import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/chat/data/repositories/chat_repository.dart';
import 'package:EliteReurbLap/features/chat/domain/repositories/chat_repository.dart';

class MarkAsReadParams extends Equatable {
  final String conversationId;

  const MarkAsReadParams({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

final markAsReadUsecaseProvider = Provider<MarkAsReadUsecase>((ref) {
  final chatRepository = ref.read(chatRepositoryProvider);
  return MarkAsReadUsecase(chatRepository: chatRepository);
});

class MarkAsReadUsecase
    implements UsecaseWithParams<void, MarkAsReadParams> {
  final IChatRepository _chatRepository;

  MarkAsReadUsecase({required IChatRepository chatRepository})
      : _chatRepository = chatRepository;

  @override
  Future<Either<Failure, void>> call(MarkAsReadParams params) {
    return _chatRepository.markAsRead(params.conversationId);
  }
}
