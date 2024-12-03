



import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geogate/core/shared/modal/modal.dart';

class FirebaseService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
static const String FIREBASE_API_KEY ="AIzaSyCTGOb_WXgQVyqSUnqQ64UkqiQShxbWZpw";
static const String FIREBASE_APP_ID ="1:519239616286:android:fda25c646613c6fbd1eb0f";
static const String FIREBASE_PROJECT_ID ="geogate-e01f8";
static const String FIREBASE_SENDER_ID ="519239616286";


static Future<FirebaseApp> initializeApp() async {
  try {
    var firebaseApp = await Firebase.initializeApp(
      options:  FirebaseOptions(
            apiKey: FIREBASE_API_KEY,
            appId: FIREBASE_APP_ID,
            messagingSenderId: FIREBASE_SENDER_ID,
            projectId: FIREBASE_PROJECT_ID)

    );
    return firebaseApp;
  } catch (e) {
    print('Error initializing Firebase: $e');
    rethrow;
  }
}


   static Future<String?> getDeviceToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      String? token = await messaging.getToken();
      print("----------------------------------");
      print("Device Token: $token");
      print("----------------------------------");
      return token;
    } catch (e) {
      Modal.showToast(msg: "Error fetching device token: $e");
      return null;
    }
  }
  


}
