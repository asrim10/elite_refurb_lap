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
  final String? sellerName;
  final String? sellerImage;
  final String? buyerName;
  final String? buyerImage;
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
    this.sellerName,
    this.sellerImage,
    this.buyerName,
    this.buyerImage,
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

  factory ChatApiModel.fromJson(Map<String, dynamic> json) {
    final laptopId = _parseId(json['laptopId']);
    final buyerId = _parseId(json['buyerId']);
    final sellerId = _parseId(json['sellerId']);
    final lastMessageSender = _parseId(json['lastMessageSender']);

    // Extract seller display info from the populated sellerId object
    String? otherParticipantName;
    String? otherParticipantImage;
    String? sellerName;
    String? sellerImage;
    if (json['sellerId'] is Map) {
      final sellerObj = json['sellerId'] as Map<String, dynamic>;
      otherParticipantName =
          sellerObj['fullName'] as String? ?? sellerObj['username'] as String?;
      otherParticipantImage = sellerObj['imageUrl'] as String?;
      sellerName = otherParticipantName;
      sellerImage = otherParticipantImage;
    }

    // Extract buyer display info from the populated buyerId object
    String? buyerName;
    String? buyerImage;
    if (json['buyerId'] is Map) {
      final buyerObj = json['buyerId'] as Map<String, dynamic>;
      buyerName =
          buyerObj['fullName'] as String? ?? buyerObj['username'] as String?;
      buyerImage = buyerObj['imageUrl'] as String?;
    }

    // Extract laptop details from the populated laptopId object if available
    String? laptopTitle;
    String? laptopPrice;
    String? laptopImage;
    if (json['laptopId'] is Map) {
      final laptopObj = json['laptopId'] as Map<String, dynamic>;
      laptopTitle = laptopObj['title'] as String?;
      final price = laptopObj['price'];
      if (price != null) {
        laptopPrice = price is num ? price.toStringAsFixed(0) : price.toString();
      }
      final images = laptopObj['images'];
      if (images is List && images.isNotEmpty) {
        laptopImage = images.first as String?;
      }
    }

    return ChatApiModel(
      id: json['_id'] as String?,
      laptopId: laptopId,
      buyerId: buyerId,
      sellerId: sellerId,
      lastMessage: json['lastMessage'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      lastMessageSender: lastMessageSender,
      buyerUnreadCount: (json['buyerUnreadCount'] as num?)?.toInt() ?? 0,
      sellerUnreadCount: (json['sellerUnreadCount'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'active',
      laptopTitle:
          json['laptopTitle'] as String? ?? laptopTitle,
      laptopPrice:
          json['laptopPrice'] as String? ?? laptopPrice,
      laptopImage:
          json['laptopImage'] as String? ?? laptopImage,
      otherParticipantName:
          json['otherParticipantName'] as String? ?? otherParticipantName,
      otherParticipantImage:
          json['otherParticipantImage'] as String? ?? otherParticipantImage,
      sellerName: sellerName,
      sellerImage: sellerImage,
      buyerName: buyerName,
      buyerImage: buyerImage,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );
  }

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
      sellerName: sellerName,
      sellerImage: sellerImage,
      buyerName: buyerName,
      buyerImage: buyerImage,
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
      sellerName: entity.sellerName,
      sellerImage: entity.sellerImage,
      buyerName: entity.buyerName,
      buyerImage: entity.buyerImage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  static List<ChatEntity> toEntityList(List<ChatApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
