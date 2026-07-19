import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/notification/data/repositories/notification_repository.dart';
import 'package:EliteReurbLap/features/notification/domain/repositories/notification_repository.dart';

final markAllReadUsecaseProvider = Provider<MarkAllReadUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return MarkAllReadUsecase(repository: repository);
});

class MarkAllReadUsecase implements UsecaseWithoutParams<void> {
  final INotificationRepository _repository;

  MarkAllReadUsecase({required INotificationRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, void>> call() {
    return _repository.markAllAsRead();
  }
}
