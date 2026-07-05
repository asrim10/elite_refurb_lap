// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageApiModel _$MessageApiModelFromJson(Map<String, dynamic> json) =>
    MessageApiModel(
      id: json['_id'] as String?,
      conversationId: json['conversationId'] as String,
      senderId: json['senderId'] as String,
      content: json['content'] as String,
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

Map<String, dynamic> _$MessageApiModelToJson(MessageApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'conversationId': instance.conversationId,
      'senderId': instance.senderId,
      'content': instance.content,
      'messageType': instance.messageType,
      'fileUrl': instance.fileUrl,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
