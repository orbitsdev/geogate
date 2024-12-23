

import 'package:geogate/core/shared/controller/device_controller.dart';
import 'package:geogate/core/shared/controller/modal_controller.dart';
import 'package:geogate/core/shared/controller/notification_controller.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/course/controller/course_controller.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:geogate/features/location/controller/my_location_controller.dart';
import 'package:geogate/features/monitor/controller/monitoring_controller.dart';
import 'package:geogate/features/preregistration/model/pre_registration.dart';
import 'package:get/get.dart';

class AppBinding  extends Bindings{
  @override
  void dependencies() {

  
    Get.put(AuthController(), permanent: true);
    Get.put(DeviceController(), permanent: true);
    Get.put(NotificationController(), permanent: true);
    Get.put(ModalController(), permanent: true);
    Get.put(CourseController(), permanent: true);
    Get.put(EventController(), permanent: true);
    Get.put(PreRegistration(), permanent: true);
    Get.put(MonitoringController(), permanent: true);
    Get.put(MyLocationController(), permanent: true);
 
  }

}