// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatApiModel _$ChatApiModelFromJson(Map<String, dynamic> json) => ChatApiModel(
      id: json['_id'] as String?,
      laptopId: json['laptopId'] as String,
      buyerId: json['buyerId'] as String,
      sellerId: json['sellerId'] as String,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessageSender: json['lastMessageSender'] as String?,
      buyerUnreadCount: (json['buyerUnreadCount'] as num?)?.toInt() ?? 0,
      sellerUnreadCount: (json['sellerUnreadCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
      laptopTitle: json['laptopTitle'] as String?,
      laptopPrice: json['laptopPrice'] as String?,
      laptopImage: json['laptopImage'] as String?,
      otherParticipantName: json['otherParticipantName'] as String?,
      otherParticipantImage: json['otherParticipantImage'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$ChatApiModelToJson(ChatApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'laptopId': instance.laptopId,
      'buyerId': instance.buyerId,
      'sellerId': instance.sellerId,
      'lastMessage': instance.lastMessage,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'lastMessageSender': instance.lastMessageSender,
      'buyerUnreadCount': instance.buyerUnreadCount,
      'sellerUnreadCount': instance.sellerUnreadCount,
      'status': instance.status,
      'laptopTitle': instance.laptopTitle,
      'laptopPrice': instance.laptopPrice,
      'laptopImage': instance.laptopImage,
      'otherParticipantName': instance.otherParticipantName,
      'otherParticipantImage': instance.otherParticipantImage,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
