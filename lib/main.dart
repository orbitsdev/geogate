import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geogate/core/binding/app_binding.dart';
import 'package:geogate/core/services/firebase_service.dart';
import 'package:geogate/core/services/local_task_handler.dart';
import 'package:geogate/core/services/notificaiton_service.dart';
import 'package:geogate/core/shared/controller/modal_controller.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/theme/app_theme.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/auth/middleware/auth_middleware.dart';
import 'package:geogate/features/auth/middleware/complete_details_middleware.dart';
import 'package:geogate/features/auth/middleware/guest_middleware.dart';
import 'package:geogate/features/auth/middleware/in_complete_details_middleware.dart';
import 'package:geogate/features/auth/model/user_details.dart';
import 'package:geogate/features/auth/pages/login_page.dart';
import 'package:geogate/features/auth/pages/update_user_details.dart';
import 'package:geogate/features/auth/pages/user_details_page.dart';
import 'package:geogate/features/home_page.dart';
import 'package:geogate/features/monitor/controller/monitoring_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     if (task == "background_location_task") {
//       print('[WorkManager] Executing background location task.');
//       await MonitoringController.handleBackgroundTask();
//     }
//     return Future.value(true);
//   });
// }

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationsService.handleBackground(message);
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationsService.init();
  AppBinding().dependencies();
  await FirebaseService.initializeApp().then((value) {
    print(value);
  }).catchError((e) {
    print(e.toString());
    Modal.showToast(msg: e.toString());
  });

  await AuthController.controller.loadTokenAndUser(showModal: false);
  ModalController.controller.setDialog(false);
// Step 2: Request Location Permissions
  final locationPermission = await Geolocator.requestPermission();
  if (locationPermission == LocationPermission.denied || 
      locationPermission == LocationPermission.deniedForever) {
    print('[main] Location permissions denied.');
    return; // Exit if permissions are not granted
  }
  print('[main] Location permissions granted.');

  // // Step 3: Initialize WorkManager
  // await Workmanager().initialize(
  //   callbackDispatcher,
  //   isInDebugMode: true, // Set false for production
  // );
  runApp(const GeoGateApp());

  await NotificationsService().requestNotification();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    NotificationsService.handleForground(message);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    NotificationsService.handleWhenOfficialNotificationClick(message);
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  runApp(const GeoGateApp());
}

class GeoGateApp extends StatefulWidget {
  const GeoGateApp({Key? key}) : super(key: key);

  @override
  _GeoGateAppState createState() => _GeoGateAppState();
}

class _GeoGateAppState extends State<GeoGateApp> with WidgetsBindingObserver {


  

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      if (AuthController.controller.token.value.isNotEmpty) {
        await AuthController.controller .fetchAndUpdateUserDetails(showModal: true);
         MonitoringController.controller.startMonitoring();
      }
      AuthController.controller.updateDeviceToken();

       

    });
  }  

  
  


@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
            print('[GeoGateAppState] App resumed - Stop monitoring');
       // MonitoringController.controller.stopMonitoring();
        break;

      case AppLifecycleState.paused:
        print('[GeoGateAppState] App paused - Starting foreground service.------PAUSE');
         print('[GeoGateAppState] App paused - Start monitoring');
        MonitoringController.controller.startMonitoring();
        break;

      case AppLifecycleState.detached:


        // print('[GeoGateAppState] App detached - Cleanup if needed.------------------DETACH');
        // MonitoringController.controller.stopMonitoring(); // Cleanup
        break;
      case AppLifecycleState.inactive:

        // print('[GeoGateAppState] App inactice - Cleanup if needed.--------------INACTIVE');
        // MonitoringController.controller.stopMonitoring(); // Cleanup
        break;

      default:
        break;
    }



}

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
     MonitoringController.controller.stopMonitoring(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.UI,
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      getPages: [
        GetPage(
            name: '/login',
            page: () => LoginPage(),
            middlewares: [GuestMiddleware()]),
        GetPage(
            name: '/home-main',
            page: () => HomePage(),
            middlewares: [AuthMiddleware(), CompleteDetailsMiddleware()]),
        GetPage(
            name: '/update-user-details',
            page: () => UpdateUserDetailsPage(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: '/user-details',
            page: () => UserDetailsPage(),
            middlewares: [AuthMiddleware()]),
      ],
    );
  }
}
