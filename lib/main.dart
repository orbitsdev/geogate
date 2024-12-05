import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geogate/core/binding/app_binding.dart';
import 'package:geogate/core/services/firebase_service.dart';
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
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

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
      // Stop monitoring when the app is active and visible to the user
      MonitoringController.controller.stopMonitoring();
      break;

    case AppLifecycleState.paused:
      print('[GeoGateAppState] App paused - Start monitoring');
      // Start monitoring when the app is paused (not visible but still active)
      MonitoringController.controller.startMonitoring();
      break;

    case AppLifecycleState.inactive:
      print('[GeoGateAppState] App inactive - Ensure monitoring is running');
      // Start monitoring here as well to handle transitions or temporary inactivity
      MonitoringController.controller.startMonitoring();
      break;

    case AppLifecycleState.detached:
      print('[GeoGateAppState] App detached - Cleanup if needed');
      // Optional: Cleanup resources if necessary, though monitoring can continue if required
      MonitoringController.controller.stopMonitoring();
      break;

    default:
      print('[GeoGateAppState] Unknown lifecycle state: $state');
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
