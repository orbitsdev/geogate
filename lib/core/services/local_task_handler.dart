import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geogate/core/services/notificaiton_service.dart';

class LocationTaskHandler extends TaskHandler {
  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('[LocationTaskHandler] Foreground task started by $starter.');

    // Start listening for location updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // Trigger updates every 5 meters
      ),
    ).listen((Position position) async {
      print('-------------------------------------------------------------- START');
      print('[LocationTaskHandler] Position: ${position.latitude}, ${position.longitude}');

       await NotificationsService.showNotificationWithLogo(
  title: 'Real-Time Location!',
  body: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
  assetPath: 'assets/images/logo.png', // Correct path to your asset
  data: {'type': 'welcome', 'id': 123},
);
     

      // Optional: You can send data to the app using FlutterForegroundTask.sendDataToTask()
      FlutterForegroundTask.sendDataToTask({
        "latitude": position.latitude,
        "longitude": position.longitude,
      });
    });
  }

  @override
  void onRepeatEvent(DateTime timestamp) {
    print('[LocationTaskHandler] onRepeatEvent called at $timestamp.');
    // Perform periodic actions here if needed
  }

  @override
  Future<void> onDestroy(DateTime timestamp) async {
    print('[LocationTaskHandler] Foreground task destroyed at $timestamp.');
    // Perform cleanup if necessary
  }

  @override
  void onReceiveData(Object data) {
    print('[LocationTaskHandler] Received data: $data');
    // Handle data sent from the app
  }
}
