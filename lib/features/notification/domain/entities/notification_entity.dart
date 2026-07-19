import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String? id;
  final String title;
  final String message;
  final String type; // "message", "price_drop", "new_listing", "saved_search", "sold_out"
  final bool isRead;
  final String? relatedId;
  final DateTime? createdAt;

  const NotificationEntity({
    this.id,
    required this.title,
    required this.message,
    this.type = 'message',
    this.isRead = false,
    this.relatedId,
    this.createdAt,
  });

  NotificationEntity copyWith({
    String? id,
    String? title,
    String? message,
    String? type,
    bool? isRead,
    String? relatedId,
    DateTime? createdAt,
  }) {
    return NotificationEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      relatedId: relatedId ?? this.relatedId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        isRead,
        relatedId,
        createdAt,
      ];
}
