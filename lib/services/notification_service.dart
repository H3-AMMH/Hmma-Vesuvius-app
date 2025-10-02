import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../main.dart';

class NotificationService {
  static Future<void> showOrderReadyNotification({
    required int orderId,
    required String? tableNumbers,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      'order_ready_channel',
      'Order Ready',
      channelDescription: 'Notifies when an order is ready',
      importance: Importance.max,
      priority: Priority.high,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      orderId,
      'Ordre #$orderId er klar!',
      'Ordre #$orderId er klar til bord ${tableNumbers ?? "-"}',
      notificationDetails,
    );
  }
}
