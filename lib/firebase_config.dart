// import 'dart:async';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// Future<void> backgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//
//
//   // Handle the background message here
//   _showLocalNotification(message.data);
// }
//
// void _showLocalNotification(Map<String, dynamic> data) async {
//   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//     'channel_id',
//     'channel_name',
//     importance: Importance.max,
//     priority: Priority.high,
//   );
//
//
//   var platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );
//
//   await FlutterLocalNotificationsPlugin().show(
//     0,
//     data['title'],
//     data['body'],
//     platformChannelSpecifics,
//     //payload: data['data'],
//   );
// }
