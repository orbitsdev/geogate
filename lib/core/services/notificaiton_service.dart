import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geogate/core/shared/controller/notification_controller.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:http/http.dart' as http;

class PushNotificationType {
  static const String TEXT_ONLY = "TEXT_ONLY";
  static const String TEXT_IMAGE = "TEXT_IMAGE";
}

class NotificationsService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid, iOS: null, linux: null);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  static Function(NotificationResponse)? onDidReceiveNotificationResponse(
      NotificationResponse details) {
    if (details.payload != null) {
      Map<String, dynamic> data = jsonDecode(details.payload as String);
      if (data['notification_type'] == 'order_notification') {
        // MyOrderController.controller  .goToOrderDetailsScreenFromNotification(data);
      }
    }
  }

  static void handleWhenOfficialNotificationClick(RemoteMessage message) async {
    // MyOrderController.controller
    //     .goToOrderDetailsScreenFromNotification(message.data);
  }

  static Function(NotificationResponse)?
      onDidReceiveBackgroundNotificationResponse(
          NotificationResponse details) {}

  static void handleBackground(RemoteMessage message) {
    print('--------------');
    print('BAckground');
    print('--------------');
    // Get.put(NotificationController());
    // if (message.data['notification_type'] == 'order_notification') {
    //   if (message.data['notification_type'] == 'order_notification') {
    //     NotificationController.controller.loadNotificationsWithoutContext();
    //   }
    // }
  }

  static void handleForground(RemoteMessage message) {
    
    if (message.data['notification'] == 'task') {
      print('task forground');
       NotificationController.controller.loadNotifications();
    }

    NotificationsService.showNotificationWithLongContent(
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data);
  }

  static showSimpleNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    // Use BigTextStyleInformation for expandable notification
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body ?? '',
      contentTitle: title,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "channel_id_8",
      "avantefoods",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      icon: '@mipmap/ic_launcher',

      styleInformation: bigTextStyleInformation, // Set the style information
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  static showNotificationWithLongContent({
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    final ByteData bytes =
        await rootBundle.load('assets/images/logo.png');
    final Uint8List byteArray = bytes.buffer.asUint8List();

    final largeIcon = ByteArrayAndroidBitmap(byteArray);

    // Use BigTextStyleInformation for expandable notification
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      body ?? '',
      contentTitle: title,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "channel_id_10",
      "geolocation",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      icon: '@mipmap/ic_launcher',
      largeIcon: largeIcon,
      styleInformation: bigTextStyleInformation, // Set the style information
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: jsonEncode(data),
    );
  }

  static Future<void> showNotificationWithImage({
    String? title,
    String? body,
    Map<String, dynamic>? data,
  }) async {
    // final ByteData largeIconBytes =
    //     await rootBundle.load('assets/images/avante_logo.png');
    // final Uint8List largeIconByteArray = largeIconBytes.buffer.asUint8List();

    // final ByteData bigPictureBytes =
    //     await rootBundle.load(samplePath('p5.jpg'));
    // final Uint8List bigPictureByteArray = bigPictureBytes.buffer.asUint8List();

    // final largeIcon = ByteArrayAndroidBitmap(largeIconByteArray);
    // final bigPicture = ByteArrayAndroidBitmap(bigPictureByteArray);

    // Use BigPictureStyleInformation for a large image on the left
    // BigPictureStyleInformation bigPictureStyleInformation =
    //     BigPictureStyleInformation(
    //   bigPicture,
    //   largeIcon: largeIcon,
    //   contentTitle: title,
    //   summaryText: body,
    //   htmlFormatContent: true,
    //   htmlFormatContentTitle: true,
    //   htmlFormatSummaryText: true,
    // );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "channel_id_10",
      "channel with image",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification'),
      icon: '@mipmap/ic_launcher', // This is the small icon
      // styleInformation: bigPictureStyleInformation, // Set the style information
      actions: <AndroidNotificationAction>[],
    );

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: data.toString(),
    );
  }

  // static showScheduleNotification({
  //   String? title,
  //   String? body,
  //   Map<String, dynamic>? data,
  // }) async {
  //   final bigPicture = await DownloadUtil.downloadAndSaveFile(
  //       "https://images.unsplash.com/photo-1624948465027-6f9b51067557?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80",
  //       "drinkwater");
  //   AndroidNotificationDetails androidNotificationDetails =
  //       AndroidNotificationDetails('notification', 'your channel name',
  //           channelDescription: 'your channel description',
  //           importance: Importance.max,
  //           priority: Priority.high,
  //           largeIcon: const DrawableResourceAndroidBitmap('justwater'),
  //           styleInformation: BigPictureStyleInformation(
  //             FilePathAndroidBitmap(bigPicture),
  //             hideExpandedLargeIcon: false,
  //           ),
  //           ticker: 'ticker');
  //   NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidNotificationDetails,
  //   );
  //   await _flutterLocalNotificationsPlugin.periodicallyShow(
  //       1, title, body, RepeatInterval.everyMinute, notificationDetails,
  //       payload: data.toString());
  // }

  static Future<String> _downloadAndSaveImage(
      String url, String fileName) async {
    final response = await http.get(Uri.parse(url));
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/$fileName');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  static stopScheduleNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> requestNotification() async {
    NotificationSettings notificationsettings =
        await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (notificationsettings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user is already granted');
    } else if (notificationsettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user is already granted permission');
    } else {
      Modal.showToast(msg: 'User denied permisions');
    }

   
  }

  Future<String?> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token;
  }

}



class DownloadUtil {
  static Future<String> downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName.png';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
} 
