import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // Liste des notifications locales
  final List<NotificationModel> _notificationsList = [];
  List<NotificationModel> get notifications => List.unmodifiable(_notificationsList);

  // Callback pour mettre à jour l'UI
  Function(List<NotificationModel>)? onNotificationsUpdated;

  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Demander les permissions pour Android 13+
    if (await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission() ??
        false) {
      _initialized = true;
    } else {
      _initialized = true; // Continuer même si la permission est refusée
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Gérer le tap sur la notification
    debugPrint('Notification tapped: ${response.payload}');
    // Vous pouvez naviguer vers une page spécifique ici
  }

  Future<void> showNotification(NotificationModel notification) async {
    if (!_initialized) {
      await initialize();
    }

    // Ajouter à la liste locale
    _notificationsList.insert(0, notification);
    onNotificationsUpdated?.call(_notificationsList);

    // Afficher la notification système
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'delivery_channel',
      'Livraisons',
      channelDescription: 'Notifications pour les livraisons',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      notification.id.hashCode,
      notification.title,
      notification.body,
      details,
      payload: notification.data?.toString(),
    );
  }

  Future<void> showNewDeliveryNotification({
    required String deliveryId,
    required String clientName,
    required String address,
  }) async {
    final notification = NotificationModel(
      id: 'delivery_$deliveryId',
      title: 'Nouvelle livraison',
      body: 'Nouvelle livraison pour $clientName à $address',
      type: NotificationType.newDelivery,
      timestamp: DateTime.now(),
      data: {
        'deliveryId': deliveryId,
        'type': 'new_delivery',
      },
    );

    await showNotification(notification);
  }

  Future<void> showDeliveryCompletedNotification({
    required String deliveryId,
    required String clientName,
  }) async {
    final notification = NotificationModel(
      id: 'delivery_completed_$deliveryId',
      title: 'Livraison terminée',
      body: 'La livraison pour $clientName a été complétée',
      type: NotificationType.deliveryCompleted,
      timestamp: DateTime.now(),
      data: {
        'deliveryId': deliveryId,
        'type': 'delivery_completed',
      },
    );

    await showNotification(notification);
  }

  Future<void> showDeliveryReturnedNotification({
    required String deliveryId,
    required String clientName,
    String? reason,
  }) async {
    final notification = NotificationModel(
      id: 'delivery_returned_$deliveryId',
      title: 'Livraison retournée',
      body: reason != null
          ? 'La livraison pour $clientName a été retournée: $reason'
          : 'La livraison pour $clientName a été retournée',
      type: NotificationType.deliveryReturned,
      timestamp: DateTime.now(),
      data: {
        'deliveryId': deliveryId,
        'type': 'delivery_returned',
        'reason': reason,
      },
    );

    await showNotification(notification);
  }

  void markAsRead(String notificationId) {
    final index = _notificationsList.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notificationsList[index] = _notificationsList[index].copyWith(isRead: true);
      onNotificationsUpdated?.call(_notificationsList);
    }
  }

  void markAllAsRead() {
    for (int i = 0; i < _notificationsList.length; i++) {
      _notificationsList[i] = _notificationsList[i].copyWith(isRead: true);
    }
    onNotificationsUpdated?.call(_notificationsList);
  }

  void clearAll() {
    _notificationsList.clear();
    onNotificationsUpdated?.call(_notificationsList);
  }

  int get unreadCount {
    return _notificationsList.where((n) => !n.isRead).length;
  }
}

