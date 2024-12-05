import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geogate/core/services/local_task_handler.dart';
import 'package:get/get.dart';

class MonitoringController extends GetxController {
  static MonitoringController get controller => Get.find();

  bool isMonitoring = false;

  void startMonitoring() {
    if (isMonitoring) return; // Prevent duplicate calls
    isMonitoring = true;
    print('[MonitoringController] Starting location tracking...');

    FlutterForegroundTask.startService(
      notificationTitle: 'GeoGate Tracking',
      notificationText: 'Location tracking is active.',
      callback: () => FlutterForegroundTask.setTaskHandler(LocationTaskHandler()),
    );
  }

  void stopMonitoring() {
    if (!isMonitoring) return; // Prevent duplicate calls
    isMonitoring = false;
    print('[MonitoringController] Stopping location tracking...');

    FlutterForegroundTask.stopService();
  }
}
