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
      if (data['notification_type'] == 'absent_notification') {
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
    Get.put(NotificationController());
    if (message.data['notification_type'] == 'absent_notification') {
      
    }
  }

  static void handleForground(RemoteMessage message) {
    
    if (message.data['notification'] == 'task') {
      print('task forground');
      //  NotificationController.controller.loadNotifications();
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
      "channel_id_11",
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
static Future<void> showNotificationWithLogo({
  required String title,
  required String body,
  required String assetPath, // Path to the logo asset
  Map<String, dynamic>? data,
}) async {
  try {
    // Load the logo from assets
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List byteArray = bytes.buffer.asUint8List();

    // Save the logo to a temporary file
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/logo_icon.png';
    final File file = File(filePath);
    await file.writeAsBytes(byteArray);

    // Define Android notification details with the logo as a large icon
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'logo_notification_channel', // Channel ID
      'Logo Notifications', // Channel Name
      channelDescription: 'Notifications with a logo as the large icon', // Description
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      largeIcon: FilePathAndroidBitmap(filePath), // Set the logo as the large icon
      icon: '@mipmap/ic_launcher', // Small notification icon
    );

    // Platform-specific notification details
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Display the notification
    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      notificationDetails, // Notification details
      payload: data != null ? jsonEncode(data) : null, // Optional payload
    );
  } catch (e) {
    debugPrint('Error showing notification with logo: $e');
  }
}

  static Future<void> showNotificationWithAssetImage({
  required String title,
  required String body,
  required String assetPath, // Path to the asset image
  Map<String, dynamic>? data,
}) async {
  try {
    // Load the image from assets
    final ByteData bytes = await rootBundle.load(assetPath);
    final Uint8List byteArray = bytes.buffer.asUint8List();

    // Save the image to a temporary file
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/asset_image.png';
    final File file = File(filePath);
    await file.writeAsBytes(byteArray);

    // Create the Big Picture style information
    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
      FilePathAndroidBitmap(filePath), // Use the saved image as the big picture
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'), // Optional large icon
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );

    // Define Android notification details
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'asset_image_channel', // Channel ID
      'Asset Image Notifications', // Channel Name
      channelDescription: 'Notifications with images from assets', // Description
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      styleInformation: bigPictureStyleInformation, // Attach the style information
      icon: '@mipmap/ic_launcher', // Notification icon
    );

    // Platform-specific notification details
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    // Display the notification
    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      notificationDetails, // Notification details
      payload: data != null ? jsonEncode(data) : null, // Optional payload
    );
  } catch (e) {
    debugPrint('Error showing notification with asset image: $e');
  }
}


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

  static Future<void> showNotification({
  required String title,
  required String body,
  String? payload, // Optional payload to pass with notification
}) async {
  try {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'default_channel_id', // Channel ID
      'Default Channel', // Channel name
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: '@mipmap/ic_launcher', // Small icon
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    // Correct the reference to the static variable
    await NotificationsService._flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title, // Notification title
      body, // Notification body
      platformDetails,
      payload: payload, // Optional payload
    );
  } catch (e) {
    print("Error showing notification: $e");
  }
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
