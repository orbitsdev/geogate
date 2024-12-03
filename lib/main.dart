import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geogate/core/binding/app_binding.dart';
import 'package:geogate/core/services/firebase_service.dart';
import 'package:geogate/core/services/notificaiton_service.dart';
import 'package:geogate/core/shared/controller/modal_controller.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/auth/middleware/auth_middleware.dart';
import 'package:geogate/features/auth/middleware/guest_middleware.dart';
import 'package:geogate/features/auth/pages/login_page.dart';
import 'package:geogate/features/home_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

@pragma('vm:entry-point') 
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  await Firebase.initializeApp();
  NotificationsService.handleBackground(message);
}
Future<void> main() async  {
    WidgetsFlutterBinding.ensureInitialized();
    NotificationsService.init();
     AppBinding().dependencies();
     await FirebaseService.initializeApp().then((value){
    print(value);
   }).catchError((e){
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
  const GeoGateApp({ Key? key }) : super(key: key);

  @override
  _GeoGateAppState createState() => _GeoGateAppState();
}

class _GeoGateAppState extends State<GeoGateApp>  with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

     WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero, () async {
      
      if(AuthController.controller.token.value.isNotEmpty){
        await AuthController.controller.fetchAndUpdateUserDetails(showModal: true);
      }
      AuthController.controller.updateDeviceToken();
    });  
  }

  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
      print('resume');
      case AppLifecycleState.inactive:
      print('ianctive');
      case AppLifecycleState.detached:
      print('detach');
      print('detach');
      case AppLifecycleState.paused:
      print('pause');
      default:
    }
  }

  @override
  void dispose() {
     WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', 
      getPages: [
       
      
        GetPage(name: '/login', page: () => LoginPage(), middlewares:[GuestMiddleware()]),
        GetPage(name: '/home-main', page: () => HomePage(), middlewares: [AuthMiddleware(),]),

      ],
    );
  
  }
}