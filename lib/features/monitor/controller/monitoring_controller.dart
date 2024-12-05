import 'dart:async';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/model/event_schedule.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geogate/core/services/notificaiton_service.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:get/get.dart';

class MonitoringController extends GetxController {
  static MonitoringController get controller => Get.find();

  bool isMonitoring = false;
  late StreamSubscription<Position> _positionStream;

  void startMonitoring() {
  if (isMonitoring) return;

  isMonitoring = true;
  print('[MonitoringController] Monitoring started.');

  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      // distanceFilter: 5, // Update every 5 meters
    ),
  ).listen((Position position) {
    _handlePositionUpdate(position);
  });

  NotificationsService.showSimpleNotification(
    title: 'Monitoring Active',
    body: 'Monitoring has started in the background.',
  );
}

void stopMonitoring() {
  if (!isMonitoring) return;

  isMonitoring = false;
  print('[MonitoringController] Monitoring stopped.');
  _positionStream.cancel();

  NotificationsService.showSimpleNotification(
    title: 'Monitoring Stopped',
    body: 'Monitoring has been stopped.',
  );
}

  void _handlePositionUpdate(Position position) {
    final activeEvent = EventController.controller.activeEvent.value;

    // Ensure the active event and campus data are valid
    if (activeEvent.id == null || activeEvent.campus == null) {
      print('[MonitoringController] No active event or campus data available.');
      stopMonitoring();
      return;
    }

    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      activeEvent.campus!.latitude!.toDouble(),
      activeEvent.campus!.longitude!.toDouble(),
    );

    print('------------MOVEMENT');
    print('[MonitoringController] Current distance: $distance meters');
    print('[MonitoringController] Allowed radius: ${activeEvent.campus!.radius ?? 50} meters');
    print('------------END MOVE MENT');

    if (distance > (activeEvent.campus!.radius ?? 50)) {
      NotificationsService.showSimpleNotification(
        title: 'Out of Radius',
        body: 'You are outside the allowed radius of the event.',
      );
    }
  }

 void markAbsent() async {
    var user = AuthController.controller.user.value;
    var schedule = EventController.controller.activeEvent.value.activeSchedule;

    if (user.id == null || schedule == null) {
      print('[MonitoringController] Unable to mark absent - Missing user or schedule data.');
      return;
    }

     var data = {
          'event_schedule_id': schedule.id,
          'user_id': user.id,
        };

    var response = await ApiService.postAuthenticatedResource('attendance/mark-absent', data);

    response.fold((failure){
      Modal.errorDialog(failure: failure);
    }, (success){
      Modal.showToast(msg:  'You Have mar as absent');
    });

  }
}
