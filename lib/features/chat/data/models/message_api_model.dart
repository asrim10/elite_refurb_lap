import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/message_entity.dart';

part 'message_api_model.g.dart';

@JsonSerializable()
class MessageApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String conversationId;
  final String senderId;
  final String content;
  final String messageType;
  final String? fileUrl;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MessageApiModel({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    this.messageType = 'text',
    this.fileUrl,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Safely extracts a string ID from a value that may be a plain string
  /// or a populated object (MongoDB populate).
  /// Handles both `_id` (MongoDB convention) and `id` (alternative) field names.
  static String _parseId(dynamic value) {
    if (value is Map) {
      final id = value['_id'] ?? value['id'];
      if (id is String) return id;
      if (id != null) return id.toString();
      return '';
    }
    if (value is String) return value;
    return '';
  }

  factory MessageApiModel.fromJson(Map<String, dynamic> json) {
    final senderId = _parseId(json['senderId']);
    final conversationId = _parseId(json['conversationId']);

    return MessageApiModel(
      id: json['_id'] as String?,
      conversationId: conversationId,
      senderId: senderId,
      content: json['content'] as String? ?? '',
      messageType: json['messageType'] as String? ?? 'text',
      fileUrl: json['fileUrl'] as String?,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => _$MessageApiModelToJson(this);

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      conversationId: conversationId,
      senderId: senderId,
      content: content,
      messageType: messageType,
      fileUrl: fileUrl,
      readAt: readAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory MessageApiModel.fromEntity(MessageEntity entity) {
    return MessageApiModel(
      id: entity.id,
      conversationId: entity.conversationId,
      senderId: entity.senderId,
      content: entity.content,
      messageType: entity.messageType,
      fileUrl: entity.fileUrl,
      readAt: entity.readAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<MessageEntity> toEntityList(List<MessageApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
