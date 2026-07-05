import 'package:json_annotation/json_annotation.dart';
import 'package:EliteReurbLap/features/chat/domain/entities/chat_entity.dart';

part 'chat_api_model.g.dart';

@JsonSerializable()
class ChatApiModel {
  @JsonKey(name: '_id')
  final String? id;
  final String laptopId;
  final String buyerId;
  final String sellerId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSender;
  final int buyerUnreadCount;
  final int sellerUnreadCount;
  final String status;
  final String? laptopTitle;
  final String? laptopPrice;
  final String? laptopImage;
  final String? otherParticipantName;
  final String? otherParticipantImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatApiModel({
    this.id,
    required this.laptopId,
    required this.buyerId,
    required this.sellerId,
    this.lastMessage,
    this.lastMessageAt,
    this.lastMessageSender,
    this.buyerUnreadCount = 0,
    this.sellerUnreadCount = 0,
    this.status = 'active',
    this.laptopTitle,
    this.laptopPrice,
    this.laptopImage,
    this.otherParticipantName,
    this.otherParticipantImage,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatApiModel.fromJson(Map<String, dynamic> json) =>
      _$ChatApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatApiModelToJson(this);

  ChatEntity toEntity() {
    return ChatEntity(
      id: id,
      laptopId: laptopId,
      buyerId: buyerId,
      sellerId: sellerId,
      lastMessage: lastMessage,
      lastMessageAt: lastMessageAt,
      lastMessageSender: lastMessageSender,
      buyerUnreadCount: buyerUnreadCount,
      sellerUnreadCount: sellerUnreadCount,
      status: status,
      laptopTitle: laptopTitle,
      laptopPrice: laptopPrice,
      laptopImage: laptopImage,
      otherParticipantName: otherParticipantName,
      otherParticipantImage: otherParticipantImage,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory ChatApiModel.fromEntity(ChatEntity entity) {
    return ChatApiModel(
      id: entity.id,
      laptopId: entity.laptopId,
      buyerId: entity.buyerId,
      sellerId: entity.sellerId,
      lastMessage: entity.lastMessage,
      lastMessageAt: entity.lastMessageAt,
      lastMessageSender: entity.lastMessageSender,
      buyerUnreadCount: entity.buyerUnreadCount,
      sellerUnreadCount: entity.sellerUnreadCount,
      status: entity.status,
      laptopTitle: entity.laptopTitle,
      laptopPrice: entity.laptopPrice,
      laptopImage: entity.laptopImage,
      otherParticipantName: entity.otherParticipantName,
      otherParticipantImage: entity.otherParticipantImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ChatEntity> toEntityList(List<ChatApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
