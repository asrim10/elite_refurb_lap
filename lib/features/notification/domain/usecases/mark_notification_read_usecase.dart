import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/notification/data/repositories/notification_repository.dart';
import 'package:EliteReurbLap/features/notification/domain/repositories/notification_repository.dart';

class MarkNotificationReadParams extends Equatable {
  final String notificationId;

  const MarkNotificationReadParams({required this.notificationId});

  @override
  List<Object?> get props => [notificationId];
}

final markNotificationReadUsecaseProvider =
    Provider<MarkNotificationReadUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return MarkNotificationReadUsecase(repository: repository);
});

class MarkNotificationReadUsecase
    implements UsecaseWithParams<void, MarkNotificationReadParams> {
  final INotificationRepository _repository;

  MarkNotificationReadUsecase({required INotificationRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call(MarkNotificationReadParams params) {
    return _repository.markAsRead(params.notificationId);
  }
}
