import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:EliteReurbLap/core/api/api_client.dart';
import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/features/notification/data/datasources/notification_datasource.dart';
import 'package:EliteReurbLap/features/notification/data/models/notification_model.dart';

final notificationRemoteDatasourceProvider =
    Provider<INotificationRemoteDataSource>((ref) {
  return NotificationRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
  );
});

class NotificationRemoteDatasource implements INotificationRemoteDataSource {
  final ApiClient _apiClient;

  NotificationRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<NotificationModel>> getNotifications({
    int page = 1,
    int size = 20,
  }) async {
    final response = await _apiClient.get(
      ApiEndpoints.notifications,
      queryParameters: {'page': page, 'size': size},
    );
    final data = response.data['data'] as List<dynamic>;
    return data
        .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount() async {
    final response = await _apiClient.get(
      ApiEndpoints.notificationUnreadCount,
    );
    final data = response.data['data'];
    if (data is int) return data;
    if (data is Map) return (data['count'] as num?)?.toInt() ?? 0;
    return 0;
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    await _apiClient.patch(
      '${ApiEndpoints.notificationById}$notificationId/read',
    );
  }

  @override
  Future<void> markAllAsRead() async {
    await _apiClient.patch(
      ApiEndpoints.notificationMarkAllRead,
    );
  }
}
