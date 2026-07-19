import 'dart:async';

import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/core/services/storage/token_service.dart';
import 'package:EliteReurbLap/features/notification/data/models/notification_model.dart';
import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

final notificationSocketServiceProvider =
    Provider<NotificationSocketService>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return NotificationSocketService(tokenService: tokenService);
});

class NotificationSocketService {
  final TokenService _tokenService;
  io.Socket? _socket;

  // Stream controllers for incoming events
  final _newNotificationController =
      StreamController<NotificationEntity>.broadcast();
  final _unreadCountController = StreamController<int>.broadcast();
  final _connectionStatusController =
      StreamController<bool>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // Public streams
  Stream<NotificationEntity> get onNewNotification =>
      _newNotificationController.stream;
  Stream<int> get onUnreadCountUpdate => _unreadCountController.stream;
  Stream<bool> get onConnectionStatus => _connectionStatusController.stream;
  Stream<String> get onError => _errorController.stream;

  bool get isConnected => _socket?.connected ?? false;

  NotificationSocketService({required TokenService tokenService})
      : _tokenService = tokenService;

  /// Derive the Socket.IO server URL from the REST API base URL.
  static String get _socketUrl {
    final base = ApiEndpoints.baseUrl;

    if (kDebugMode) {
      debugPrint('🔔 Notification socket URL derived from baseUrl: $base');
    }

    if (base.endsWith('/api/v1')) {
      return base.substring(0, base.length - '/api/v1'.length);
    }
    if (base.endsWith('/api')) {
      return base.substring(0, base.length - '/api'.length);
    }
    return base;
  }

  /// Connect to the socket server with JWT authentication.
  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      debugPrint('🔔 Notification socket already connected');
      return;
    }

    final token = _tokenService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('🔔 Cannot connect — no auth token');
      _errorController.add('No auth token available');
      return;
    }

    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = '$_socketUrl?_ts=$timestamp';
      debugPrint('🔔 Connecting notification socket: $url');

      _socket = io.io(
        url,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .disableAutoConnect()
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint('🔔 Notification socket connected: ${_socket!.id}');
        _connectionStatusController.add(true);
      });

      _socket!.onDisconnect((_) {
        debugPrint('🔔 Notification socket disconnected');
        _connectionStatusController.add(false);
      });

      _socket!.onConnectError((data) {
        debugPrint('🔔 Notification socket connection error: $data');
        _errorController.add('Connection error: $data');
        _connectionStatusController.add(false);
      });

      _socket!.onError((data) {
        debugPrint('🔔 Notification socket error: $data');
        _errorController.add('Socket error: $data');
      });

      // ---- Incoming notification events ----

      _socket!.on('notification:new', (data) {
        _handleNewNotification(data);
      });

      _socket!.on('notification:unread', (data) {
        _handleUnreadCount(data);
      });

      _socket!.on('error', (data) {
        final message = data is Map
            ? data['message']?.toString() ?? 'Unknown socket error'
            : data.toString();
        _errorController.add(message);
      });

      _socket!.connect();
    } catch (e) {
      debugPrint('🔔 Notification socket init error: $e');
      _errorController.add('Socket init error: $e');
    }
  }

  /// Disconnect from the socket server.
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _connectionStatusController.add(false);
  }

  // ---- Incoming event handlers ----

  void _handleNewNotification(dynamic data) {
    if (data is! Map<String, dynamic>) {
      debugPrint(
          '🔔 notification:new data is not a Map: $data (type=${data.runtimeType})');
      return;
    }

    debugPrint(
        '🔔 notification:new raw keys: [${data.keys.join(', ')}]');

    // Unwrap if nested under "notification" or "data" key
    Map<String, dynamic> notificationData = data;
    if (data.containsKey('notification') &&
        data['notification'] is Map<String, dynamic>) {
      notificationData =
          data['notification'] as Map<String, dynamic>;
      debugPrint('🔔 notification:new unwrapped from "notification" key');
    }
    if (data.containsKey('data') &&
        data['data'] is Map<String, dynamic>) {
      if (!data.containsKey('notification') ||
          data['notification'] is! Map<String, dynamic>) {
        notificationData = data['data'] as Map<String, dynamic>;
        debugPrint('🔔 notification:new unwrapped from "data" key');
      }
    }

    try {
      final model = NotificationModel.fromJson(notificationData);
      debugPrint(
          '🔔 notification:new parsed -> title="${model.title}" type="${model.type}"');
      _newNotificationController.add(model.toEntity());
    } catch (e) {
      debugPrint(
          '🔔 Error parsing notification:new: $e — raw keys: [${notificationData.keys.join(', ')}]');
    }
  }

  void _handleUnreadCount(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    try {
      final count = (data['count'] as num?)?.toInt() ?? 0;
      debugPrint('🔔 notification:unread -> count=$count');
      _unreadCountController.add(count);
    } catch (e) {
      debugPrint('🔔 Error parsing notification:unread: $e');
    }
  }

  /// Clean up all stream controllers.
  void dispose() {
    disconnect();
    _newNotificationController.close();
    _unreadCountController.close();
    _connectionStatusController.close();
    _errorController.close();
  }
}
