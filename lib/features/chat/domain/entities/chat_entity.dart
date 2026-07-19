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
  final String? sellerName;
  final String? sellerImage;
  final String? buyerName;
  final String? buyerImage;
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
    this.sellerName,
    this.sellerImage,
    this.buyerName,
    this.buyerImage,
    this.createdAt,
    this.updatedAt,
  });

  /// Returns the other participant's display name based on who the current user is.
  String? resolveOtherName(String currentUserId) {
    if (sellerId == currentUserId) return buyerName ?? 'Unknown';
    return sellerName ?? otherParticipantName ?? 'Unknown';
  }

  /// Returns the other participant's profile image based on who the current user is.
  String? resolveOtherImage(String currentUserId) {
    if (sellerId == currentUserId) return buyerImage;
    return sellerImage ?? otherParticipantImage;
  }

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
        sellerName,
        sellerImage,
        buyerName,
        buyerImage,
        createdAt,
        updatedAt,
      ];
}
