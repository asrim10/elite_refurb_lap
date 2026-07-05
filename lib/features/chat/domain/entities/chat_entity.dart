import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String? id;
  final String laptopId;
  final String buyerId;
  final String sellerId;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final String? lastMessageSender;
  final int buyerUnreadCount;
  final int sellerUnreadCount;
  final String status; // "active" | "archived"
  final String? laptopTitle;
  final String? laptopPrice;
  final String? laptopImage;
  final String? otherParticipantName;
  final String? otherParticipantImage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ChatEntity({
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

  @override
  List<Object?> get props => [
        id,
        laptopId,
        buyerId,
        sellerId,
        lastMessage,
        lastMessageAt,
        lastMessageSender,
        buyerUnreadCount,
        sellerUnreadCount,
        status,
        laptopTitle,
        laptopPrice,
        laptopImage,
        otherParticipantName,
        otherParticipantImage,
        createdAt,
        updatedAt,
      ];
}
