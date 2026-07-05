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

  factory MessageApiModel.fromJson(Map<String, dynamic> json) =>
      _$MessageApiModelFromJson(json);

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
