import 'dart:io';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as local_notifications;
import 'package:fyp/views/chat_view.dart';
import 'package:fyp/views/message_user_list.dart';
import 'package:get/get.dart';

//AAAANFZ7kDQ:APA91bFzd7VOzBXrRAd7B6l2PN5UEZv1NtXQR3QUqed2M32zYf4mLyppR5P9dzg9nid8pOGhKeVIsunwtJUDkye13ow4zQu8abSNdgYb_Ah29UVxZxPK5La37oQNF-226d8nmCDSL6Y3
class MessageNotification {
  final messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPremission() async {
    final settings = await messaging.requestPermission(
        announcement: true,
        alert: true,
        badge: true,
        criticalAlert: true,
        carPlay: true,
        sound: true,
        provisional: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted premission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional premission");
    } else {
      AppSettings.openAppSettings();
      print("user denided premission");
    }
  }

  void initLocalnNotification(
      BuildContext context, RemoteMessage remoteMessage) async {
    var _androidInitializationSettings =
        const AndroidInitializationSettings("@mipmap/launcher_icon");
    var _iosInitializationSettings = const DarwinInitializationSettings();
    var _initializationSettings = InitializationSettings(
        android: _androidInitializationSettings,
        iOS: _iosInitializationSettings);
    await _flutterLocalNotificationsPlugin.initialize(_initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, remoteMessage);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      print(message.notification?.title.toString());
      print(message.notification?.body.toString());
      print(message.data.toString());
      print(message.data['type']);
      print(message.data['id']);

      if (Platform.isAndroid) {
        initLocalnNotification(context, message);
        showNotification(message);
      } else {
        showNotification(message);
      }
    });
  }

  Future<void> showNotification(RemoteMessage remoteMessage) async {
    final channel = AndroidNotificationChannel(
        Random.secure().nextInt(1000000).toString(),
        "High Importance Notification",
        importance: local_notifications.Importance.max);
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: "This is My channel description",
            importance: local_notifications.Importance.high,
            priority: local_notifications.Priority.high,
            ticker: 'ticker');
    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    final notificationDetail = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          remoteMessage.notification!.title.toString(),
          remoteMessage.notification?.body.toString(),
          notificationDetail);
    });
  }

  Future<String> getMessageTokken() async {
    final String? fcmTokken = await messaging.getToken();
    return fcmTokken!;
  }

  void isTokenRefreshed() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
  }

  Future<void> setupInteractMessage(context) async {
    final intialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (intialMessage != null) {
      handleMessage(context, intialMessage);
    }
  }

  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == "chat") {
      Get.to(() => MessageList(id: "123456"));
    }

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, message);
    });
  }
}
