import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/error/failures.dart';
import 'package:EliteReurbLap/features/notification/data/datasources/notification_datasource.dart';
import 'package:EliteReurbLap/features/notification/data/datasources/remote/notification_remote_datasource.dart';
import 'package:EliteReurbLap/features/notification/data/models/notification_model.dart';
import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';
import 'package:EliteReurbLap/features/notification/domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<INotificationRepository>((ref) {
  return NotificationRepository(
    remoteDataSource: ref.read(notificationRemoteDatasourceProvider),
  );
});

class NotificationRepository implements INotificationRepository {
  final INotificationRemoteDataSource _remoteDataSource;

  NotificationRepository({
    required INotificationRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    int page = 1,
    int size = 20,
  }) async {
    try {
      final models = await _remoteDataSource.getNotifications(
        page: page,
        size: size,
      );
      return Right(NotificationModel.toEntityList(models));
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await _remoteDataSource.getUnreadCount();
      return Right(count);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await _remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await _remoteDataSource.markAllAsRead();
      return const Right(null);
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  Failure _handleError(Object e) {
    if (e is DioException) {
      final message = e.response?.data?['message'] as String? ??
          e.message ??
          'Notification operation failed';
      return ApiFailure(message: message, statusCode: e.response?.statusCode);
    }
    return ApiFailure(message: e.toString());
  }
}
