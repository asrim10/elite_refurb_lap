import 'package:EliteReurbLap/features/notification/domain/entities/notification_entity.dart';

class NotificationModel {
  final String? id;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final String? relatedId;
  final DateTime? createdAt;

  NotificationModel({
    this.id,
    required this.title,
    required this.message,
    this.type = 'message',
    this.isRead = false,
    this.relatedId,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] as String?,
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: json['type'] as String? ?? 'message',
      isRead: json['isRead'] as bool? ?? json['read'] as bool? ?? false,
      relatedId: json['relatedId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      if (relatedId != null) 'relatedId': relatedId,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    };
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      message: message,
      type: type,
      isRead: isRead,
      relatedId: relatedId,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      message: entity.message,
      type: entity.type,
      isRead: entity.isRead,
      relatedId: entity.relatedId,
      createdAt: entity.createdAt,
    );
  }

  static List<NotificationEntity> toEntityList(List<NotificationModel> models) {
    return models.map((m) => m.toEntity()).toList();
  }
}
