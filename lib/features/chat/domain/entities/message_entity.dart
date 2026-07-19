import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String? id;
  final String conversationId;
  final String senderId;
  final String content;
  final String messageType; // "text" | "image" | "file"
  final String? fileUrl;
  final DateTime? readAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const MessageEntity({
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

  @override
  List<Object?> get props => [
        id,
        conversationId,
        senderId,
        content,
        messageType,
        fileUrl,
        readAt,
        createdAt,
        updatedAt,
      ];
}
