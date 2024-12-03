

import 'package:geogate/core/shared/controller/device_controller.dart';
import 'package:geogate/core/shared/controller/notification_controller.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies() {

    // Get.put(LoginController(), permanent: true);
    // Get.put(SignupController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(DeviceController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
 
  }

}