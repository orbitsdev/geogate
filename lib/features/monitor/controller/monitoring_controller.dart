import 'dart:async';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:geogate/core/services/notificaiton_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MonitoringController extends GetxController {
  static MonitoringController get controller => Get.find();

  var isMonitoring = false.obs; // Reactive monitoring status
  var isOutside = false.obs; // Reactive outside status
  var isAlreadySent = false.obs; // Prevent duplicate notifications and actions

  late StreamSubscription<Position> _positionStream;

Future<void> refreshMonitoring() async {
  print('[MonitoringController] Refreshing monitoring...');
  stopMonitoring(); // Stop the current monitoring process
  
  // Fetch the latest active event
  await EventController.controller.getActiveEvent();
  
  // Restart monitoring with updated data
  await startMonitoring();
  print('[MonitoringController] Monitoring has been refreshed.');
}

  Future<void> startMonitoring() async {
    var isAuthenticated = AuthController.controller.user.value.id != null;
    if (!isAuthenticated) return;

    if (isMonitoring.value) return;

     if (EventController.controller.activeEvent.value.id == null) {
    await EventController.controller.getActiveEvent();
  }
if (EventController.controller.activeEvent.value.id == null) {
    print('[MonitoringController] No active event. Monitoring will not start.');
    return;
  }
    isMonitoring.value = true;
    print('[MonitoringController] Monitoring started.');

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
         distanceFilter: 10, // Trigger every 5 meters
      ),
    ).listen((Position position) {
      _handlePositionUpdate(position);
    });
  }

  void stopMonitoring() {
    if (!isMonitoring.value) return;

    isMonitoring.value = false;
    print('[MonitoringController] Monitoring stopped.');
    _positionStream.cancel();
  }
void _handlePositionUpdate(Position position) async {
  final activeEvent = EventController.controller.activeEvent.value;

  // Validate active event and campus data
  if (activeEvent.id == null || activeEvent.campus == null || 
      activeEvent.campus!.latitude == null || activeEvent.campus!.longitude == null) {
    print('[MonitoringController] No active event or campus data available.');
    stopMonitoring();
    return;
  }

  // Calculate distance
  double distance = _calculateDistanceFromCampus(
    userLatitude: position.latitude,
    userLongitude: position.longitude,
    campusLatitude: activeEvent.campus!.latitude!.toDouble(),
    campusLongitude: activeEvent.campus!.longitude!.toDouble(),
  );

  print('------------MOVEMENT------------');
  print('[MonitoringController] Current distance: $distance meters');
  print('[MonitoringController] Allowed radius: ${activeEvent.campus!.radius ?? 50} meters');
  print('---------------------------------');

  // Update isOutside reactive variable
  isOutside.value = distance > (activeEvent.campus!.radius?.toDouble() ?? 50);

  if (isOutside.value) {
    if (!isAlreadySent.value) {
      print('[MonitoringController] User is outside the allowed radius.');
      isAlreadySent.value = true; // Prevent redundant notifications/actions
      await markAbsent();
    }
  } else {
    if (isAlreadySent.value) {
      print('[MonitoringController] User is back inside the allowed radius.');
      isAlreadySent.value = false;

      NotificationsService.showNotificationWithLogoAndLongContent(
        title: 'You’re in the Right Place!',
        body:
            'You’re now within the allowed area for the event: "${activeEvent.eventDescription}". Thank you for staying on track!',
        data: {'notification_type': 'inside_notification', 'event_id': activeEvent.id},
      );
    }
  }
}
double _calculateDistanceFromCampus({
  required double userLatitude,
  required double userLongitude,
  required double campusLatitude,
  required double campusLongitude,
}) {
  return Geolocator.distanceBetween(
    userLatitude,
    userLongitude,
    campusLatitude,
    campusLongitude,
  );
}



  Future<void> markAbsent() async {
    var user = AuthController.controller.user.value;
    var schedule = EventController.controller.activeEvent.value.activeSchedule;

    if (user.id == null || schedule == null || schedule.hasAttendance == null) {
      Modal.showToast(
        msg: '[MonitoringController] Unable to mark absent - Missing user, schedule, or attendance data.',
      );
      print('[MonitoringController] Unable to mark absent - Missing user, schedule, or attendance data.');
      return;
    }

    var attendance = schedule.hasAttendance;

    if (attendance == null || attendance.id == null) {
      Modal.showToast(msg: '[MonitoringController] No attendance record found to mark absent.');
      print('[MonitoringController] No attendance record found to mark absent.');
      return;
    }

    // Check if the user is already marked as absent
    if (attendance.isPresent == false) {
      print('[MonitoringController] User is already marked as absent.');
      NotificationsService.showNotificationWithLogoAndLongContent(
        title: 'You’re Outside the Event Area',
        body:
            'You are currently outside the event radius for "${EventController.controller.activeEvent.value.eventDescription}". Please return to the area to stay on track.',
        data: {'notification_type': 'outside_notification', 'event_id': attendance.eventScheduleId},
      );
      return;
    }

    var data = {
      'attendance_id': attendance.id,
    };

    var response = await ApiService.postAuthenticatedResource('attendance/mark-absent', data);

    response.fold((failure) {
      Modal.errorDialog(failure: failure);
    }, (success) async{
      Modal.showToast(msg: 'You have been marked as absent.');
      await EventController.controller.getActiveEvent();

      NotificationsService.showNotificationWithLogoAndLongContent(
        title: 'You’ve Been Marked as Absent',
        body:
            'You’re currently outside the allowed area for the event: "${EventController.controller.activeEvent.value.eventDescription}". We’ve marked you as absent for now, but returning to the area will help keep your attendance on track.',
        data: {'notification_type': 'absent_notification', 'event_id': attendance.eventScheduleId},
      );
    });
  }
}
