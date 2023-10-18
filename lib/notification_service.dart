import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:permission_handler/permission_handler.dart';

import 'initialisation.dart';

class NotificationService {
  Random random = Random();
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('hindusanskriti');

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (int id, String? title, String? body, String? payload) async {},
    );

    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await notificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {});
  // Request notification permission
    if (await Permission.notification.request().isGranted) {
      print('Notification permission granted');
    } else {
      print('Notification permission denied');
    }
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId', 'channelName', importance: Importance.max),
      iOS: DarwinNotificationDetails(),
    );
  }

  Future showNotification({int id = 0, String? title, String? body, String? payLoad}) async {
    return notificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future scheduleNotification({String? title, String? body}) async {
    final now = DateTime.now();
    final scheduledDateTime8am = DateTime(now.year, now.month, now.day, 8, 0, 0);
    final scheduledDateTime230pm = DateTime(now.year, now.month, now.day, 14, 32, 0);
    final scheduledDateTime730 = DateTime(now.year, now.month, now.day, 19, 30, 0);

    await notificationsPlugin.zonedSchedule(
      0,
      title,
      factsList[random.nextInt(25)]['fact'],
      tz.TZDateTime.from(scheduledDateTime8am, tz.local),
      await notificationDetails(),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    await notificationsPlugin.zonedSchedule(
      1,
      title,
      factsList[random.nextInt(35)]['fact'],
      tz.TZDateTime.from(scheduledDateTime230pm, tz.local),
      await notificationDetails(),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );

    await notificationsPlugin.zonedSchedule(
      2,
      title,
      factsList[random.nextInt(45)]['fact'],
      tz.TZDateTime.from(scheduledDateTime730, tz.local),
      await notificationDetails(),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}