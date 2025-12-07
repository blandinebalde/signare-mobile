class NotificationModel {
  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final DateTime timestamp;
  final Map<String, dynamic>? data;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.timestamp,
    this.data,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: NotificationType.fromString(json['type'] ?? 'info'),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : DateTime.now(),
      data: json['data'],
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type.toString(),
      'timestamp': timestamp.toIso8601String(),
      'data': data,
      'isRead': isRead,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    NotificationType? type,
    DateTime? timestamp,
    Map<String, dynamic>? data,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum NotificationType {
  newDelivery,
  deliveryCompleted,
  deliveryReturned,
  info;

  static NotificationType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'new_delivery':
      case 'newdelivery':
        return NotificationType.newDelivery;
      case 'delivery_completed':
      case 'deliverycompleted':
        return NotificationType.deliveryCompleted;
      case 'delivery_returned':
      case 'deliveryreturned':
        return NotificationType.deliveryReturned;
      default:
        return NotificationType.info;
    }
  }

  @override
  String toString() {
    switch (this) {
      case NotificationType.newDelivery:
        return 'new_delivery';
      case NotificationType.deliveryCompleted:
        return 'delivery_completed';
      case NotificationType.deliveryReturned:
        return 'delivery_returned';
      case NotificationType.info:
        return 'info';
    }
  }
}

