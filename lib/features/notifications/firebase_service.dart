// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class FirebaseService {
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
//   FlutterLocalNotificationsPlugin();
//
//   static Future<void> initialize() async {
//     await Firebase.initializeApp();
//
//     // Настройка уведомлений для Android
//     const AndroidInitializationSettings initializationSettingsAndroid =
//     AndroidInitializationSettings('@mipmap/ic_launcher');
//
//     // Настройка уведомлений для iOS
//     const DarwinInitializationSettings initializationSettingsIOS =
//     DarwinInitializationSettings();
//
//     const InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );
//
//     await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
//
//     // Запрашиваем разрешение на уведомления
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );
//
//     print('User granted permission: ${settings.authorizationStatus}');
//
//     String? token = await _firebaseMessaging.getToken();
//     print('FCM Token: $token');
//
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       _showNotification(message);
//     });
//
//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     });
//   }
//
//   static Future<void> _showNotification(RemoteMessage message) async {
//     const AndroidNotificationDetails androidPlatformChannelSpecifics =
//     AndroidNotificationDetails(
//       'your_channel_id',
//       'your_channel_name',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//
//     const DarwinNotificationDetails iOSPlatformChannelSpecifics =
//     DarwinNotificationDetails();
//
//     const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics,
//     );
//
//     await _flutterLocalNotificationsPlugin.show(
//       0,
//       message.notification?.title,
//       message.notification?.body,
//       platformChannelSpecifics,
//       payload: message.data['route'],
//     );
//   }
// }