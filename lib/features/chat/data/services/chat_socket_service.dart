import 'dart:async';

import 'package:EliteReurbLap/core/api/api_endpoints.dart';
import 'package:EliteReurbLap/core/services/storage/token_service.dart';
import 'package:EliteReurbLap/features/chat/data/models/message_api_model.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

// Provider for ChatSocketService
final chatSocketServiceProvider = Provider<ChatSocketService>((ref) {
  final tokenService = ref.read(tokenServiceProvider);
  return ChatSocketService(tokenService: tokenService);
});

class ChatSocketService {
  final TokenService _tokenService;
  io.Socket? _socket;

  // Stream controllers for incoming events
  final _newMessageController =
      StreamController<MessageEntity>.broadcast();
  final _conversationUpdatedController =
      StreamController<ConversationUpdateEvent>.broadcast();
  final _conversationReadController =
      StreamController<ConversationReadEvent>.broadcast();
  final _typingStartController =
      StreamController<TypingEvent>.broadcast();
  final _typingStopController =
      StreamController<TypingEvent>.broadcast();
  final _connectionStatusController =
      StreamController<bool>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // Public streams
  Stream<MessageEntity> get onNewMessage => _newMessageController.stream;
  Stream<ConversationUpdateEvent> get onConversationUpdated =>
      _conversationUpdatedController.stream;
  Stream<ConversationReadEvent> get onConversationRead =>
      _conversationReadController.stream;
  Stream<TypingEvent> get onTypingStart => _typingStartController.stream;
  Stream<TypingEvent> get onTypingStop => _typingStopController.stream;
  Stream<bool> get onConnectionStatus => _connectionStatusController.stream;
  Stream<String> get onError => _errorController.stream;

  bool get isConnected => _socket?.connected ?? false;

  ChatSocketService({required TokenService tokenService})
      : _tokenService = tokenService;

  /// Derive the Socket.IO server URL from the REST API base URL.
  /// Strips the /api or /api/v1 suffix so sockets connect to the server root.
  static String get _socketUrl {
    final base = ApiEndpoints.baseUrl;

    if (kDebugMode) {
      debugPrint('🔌 Socket URL derived from baseUrl: $base');
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
      debugPrint('🔌 Socket already connected');
      return;
    }

    final token = _tokenService.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('🔌 Cannot connect — no auth token');
      _errorController.add('No auth token available');
      return;
    }

    try {
      _socket = io.io(
        _socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket']) // Use WebSocket for Flutter
            .setAuth({'token': token}) // JWT auth via handshake
            .disableAutoConnect()
            .build(),
      );

      _socket!.onConnect((_) {
        debugPrint('🔌 Socket connected: ${_socket!.id}');
        _connectionStatusController.add(true);
      });

      _socket!.onDisconnect((_) {
        debugPrint('🔌 Socket disconnected');
        _connectionStatusController.add(false);
      });

      _socket!.onConnectError((data) {
        debugPrint('🔌 Socket connection error: $data');
        _errorController.add('Connection error: $data');
        _connectionStatusController.add(false);
      });

      _socket!.onError((data) {
        debugPrint('🔌 Socket error: $data');
        _errorController.add('Socket error: $data');
      });

      // ---- Incoming events ----

      _socket!.on('new:message', (data) {
        _handleNewMessage(data);
      });

      _socket!.on('conversation:updated', (data) {
        _handleConversationUpdated(data);
      });

      _socket!.on('conversation:read', (data) {
        _handleConversationRead(data);
      });

      _socket!.on('typing:start', (data) {
        _handleTypingStart(data);
      });

      _socket!.on('typing:stop', (data) {
        _handleTypingStop(data);
      });

      _socket!.on('error', (data) {
        final message = data is Map ? data['message']?.toString() ?? 'Unknown socket error' : data.toString();
        _errorController.add(message);
      });

      _socket!.connect();
    } catch (e) {
      debugPrint('🔌 Socket init error: $e');
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

  // ---- Room management ----

  /// Join a conversation's room to receive real-time events.
  void joinConversation(String conversationId) {
    _socket?.emit('join:conversation', conversationId);
  }

  /// Leave a conversation's room.
  void leaveConversation(String conversationId) {
    _socket?.emit('leave:conversation', conversationId);
  }

  // ---- Outgoing events ----

  /// Send a message via socket (server persists and broadcasts).
  void sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    String? fileUrl,
  }) {
    _socket?.emit('send:message', {
      'conversationId': conversationId,
      'content': content,
      'messageType': messageType,
      if (fileUrl != null) 'fileUrl': fileUrl,
    });
  }

  /// Mark a conversation as read via socket.
  void markAsRead(String conversationId) {
    _socket?.emit('conversation:read', conversationId);
  }

  /// Notify that the current user started typing.
  void startTyping(String conversationId) {
    _socket?.emit('typing:start', {'conversationId': conversationId});
  }

  /// Notify that the current user stopped typing.
  void stopTyping(String conversationId) {
    _socket?.emit('typing:stop', {'conversationId': conversationId});
  }

  // ---- Incoming event handlers ----

  void _handleNewMessage(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    try {
      final model = MessageApiModel.fromJson(data);
      _newMessageController.add(model.toEntity());
    } catch (e) {
      debugPrint('🔌 Error parsing new:message: $e');
    }
  }

  void _handleConversationUpdated(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    try {
      _conversationUpdatedController.add(ConversationUpdateEvent(
        conversationId: data['conversationId'] as String,
        lastMessage: data['lastMessage'] as String?,
        lastMessageAt: data['lastMessageAt'] != null
            ? DateTime.parse(data['lastMessageAt'] as String)
            : null,
        lastMessageSender: data['lastMessageSender'] as String?,
      ));
    } catch (e) {
      debugPrint('🔌 Error parsing conversation:updated: $e');
    }
  }

  void _handleConversationRead(dynamic data) {
    if (data is! Map<String, dynamic>) return;
    try {
      _conversationReadController.add(ConversationReadEvent(
        conversationId: data['conversationId'] as String,
        readBy: data['readBy'] as String?,
      ));
    } catch (e) {
      debugPrint('🔌 Error parsing conversation:read: $e');
    }
  }

  void _handleTypingStart(dynamic data) {
    if (data is! Map<String, dynamic>) return;      _typingStartController.add(TypingEvent(
      conversationId: data['conversationId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
    ));
  }

  void _handleTypingStop(dynamic data) {
    if (data is! Map<String, dynamic>) return;      _typingStopController.add(TypingEvent(
      conversationId: data['conversationId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
    ));
  }

  /// Clean up all stream controllers.
  void dispose() {
    disconnect();
    _newMessageController.close();
    _conversationUpdatedController.close();
    _conversationReadController.close();
    _typingStartController.close();
    _typingStopController.close();
    _connectionStatusController.close();
    _errorController.close();
  }
}

// ---- Event value classes ----

class ConversationUpdateEvent {
  final String conversationId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSender;

  const ConversationUpdateEvent({
    required this.conversationId,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSender,
  });
}

class ConversationReadEvent {
  final String conversationId;
  final String? readBy;

  const ConversationReadEvent({
    required this.conversationId,
    this.readBy,
  });
}

class TypingEvent {
  final String conversationId;
  final String userId;

  const TypingEvent({
    required this.conversationId,
    required this.userId,
  });
}
