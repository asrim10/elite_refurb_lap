import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/core/usecases/app_usercase.dart';
import 'package:EliteReurbLap/features/notification/data/repositories/notification_repository.dart';
import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';
import 'package:EliteReurbLap/features/notification/domain/repositories/notification_repository.dart';

class GetNotificationsParams extends Equatable {
  final int page;
  final int size;

  const GetNotificationsParams({this.page = 1, this.size = 20});

  @override
  List<Object?> get props => [page, size];
}

final getNotificationsUsecaseProvider =
    Provider<GetNotificationsUsecase>((ref) {
  final repository = ref.read(notificationRepositoryProvider);
  return GetNotificationsUsecase(repository: repository);
});

class GetNotificationsUsecase
    implements
        UsecaseWithParams<List<NotificationEntity>, GetNotificationsParams> {
  final INotificationRepository _repository;

  GetNotificationsUsecase({required INotificationRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
      GetNotificationsParams params) {
    return _repository.getNotifications(page: params.page, size: params.size);
  }
}
