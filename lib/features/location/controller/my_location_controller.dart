import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/shared/widgets/local_lottie_image.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:geogate/features/event/model/event.dart';
import 'package:geogate/features/event/model/event_schedule.dart';
import 'package:geogate/features/preregistration/pages/my_qr_page.dart';
import 'package:geogate/features/preregistration/pages/qr_display_page.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MyLocationController extends GetxController {
  // Observables
  var isLoading = false.obs;
  var isWithinRadius = false.obs;

  Rx<Event> activeEvent = Event().obs;
  Rx<EventSchedule> activeSchedule = EventSchedule().obs;

  RxList<Marker> markers = <Marker>[].obs;
  RxList<Circle> geofenceCircles = <Circle>[].obs;

  GoogleMapController? _googleMapController;
  late StreamSubscription<Position> _positionStream;

   var hasPreRegistration = false.obs;
  String preGeneratedQRData = ''; // Holds pre-generated QR data

  @override
  void onClose() {
    _positionStream.cancel();
    super.onClose();
  }

  void initializeData() {
    final arguments = Get.arguments;
    activeEvent(arguments['event']); // Set active event
    activeSchedule(arguments['event_schedule']); // Set active schedule
    calculateInitialDistance(); // Calculate initial distance
    setMarker(); // Add marker
    setGeofenceCircle(); // Add geofence
    startListeningToPosition(); // Monitor position updates
  }
Future<void> showCurrentLocation() async {
  try {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Modal.showToast(msg: "Location services are disabled. Please enable them.");
      return;
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Modal.showToast(msg: "Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Modal.showToast(msg: "Location permissions are permanently denied. Please enable them from settings.");
      return;
    }

    // Fetch the user's current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Debugging to check the fetched location
    print("Current Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");

    // Location is fetched, and the blue dot will be displayed because `myLocationEnabled: true`
  } catch (e) {
    Modal.showToast(msg: "Failed to fetch your location: $e");
  }
}

  Future<void> calculateInitialDistance() async {
    try {
      final campus = activeEvent.value.campus;
      if (campus == null) {
        Modal.showToast(msg: 'Campus information is missing.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        campus.latitude?.toDouble() ?? 0.0,
        campus.longitude?.toDouble() ?? 0.0,
      );

      isWithinRadius.value = distance <= (campus.radius?.toDouble() ?? 50);
      update();
    } catch (e) {
      Modal.showToast(msg: 'Failed to fetch your location.');
    }
  }
void startListeningToPosition() {
  final campus = activeEvent.value.campus;
  if (campus == null) {
    Modal.showToast(msg: 'Campus information is missing.');
    return;
  }

  _positionStream = Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // Trigger every 5 meters
    ),
  ).listen((Position position) {
    double distance = Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      campus.latitude?.toDouble() ?? 0.0,
      campus.longitude?.toDouble() ?? 0.0,
    );

    isWithinRadius.value = distance <= (campus.radius?.toDouble() ?? 50);

    // Debugging - Print distance and radius
    print('-LISTENING TO POSITION---------------------------------------');
    print('User Position: Latitude: ${position.latitude}, Longitude: ${position.longitude}');
    print('Campus Position: Latitude: ${campus.latitude}, Longitude: ${campus.longitude}');
    print('Calculated Distance: $distance meters');
    if (isWithinRadius.value) {
      print('User is within the radius of ${campus.radius} meters.');
    } else {
      print('User is outside the radius of ${campus.radius} meters.');
    }
    print('-------------------------------------------------------------');

    update();
  });
}


  void setMarker() {
    final campus = activeEvent.value.campus;
    if (campus == null) return;

    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('campus_location'),
        position: LatLng(
          campus.latitude?.toDouble() ?? 0.0,
          campus.longitude?.toDouble() ?? 0.0,
        ),
        infoWindow: InfoWindow(
          title: activeEvent.value.campus?.name ?? 'Campus Location',
        ),
      ),
    );
    update();
  }

  void setGeofenceCircle() {
    final campus = activeEvent.value.campus;
    if (campus == null) return;

    geofenceCircles.clear();
    geofenceCircles.add(
      Circle(
        circleId: const CircleId('geofence'),
        center: LatLng(
          campus.latitude?.toDouble() ?? 0.0,
          campus.longitude?.toDouble() ?? 0.0,
        ),
        radius: campus.radius?.toDouble() ?? 50,
        fillColor: Palette.PRIMARY.withOpacity(0.2),
        strokeColor: Palette.PRIMARY,
        strokeWidth: 2,
      ),
    );
    update();
  }

  void onMapCreated(GoogleMapController controller) {
    _googleMapController = controller;
    setMarker();
    setGeofenceCircle();
    update();
  }

void moveCameraToCampus() {
  final campus = activeEvent.value.campus;
  if (campus == null || _googleMapController == null) return;

  LatLng campusLocation = LatLng(
    campus.latitude?.toDouble() ?? 0.0,
    campus.longitude?.toDouble() ?? 0.0,
  );

  _googleMapController?.animateCamera(
    CameraUpdate.newCameraPosition(
      CameraPosition(
        target: campusLocation,
        zoom: _getZoomLevel(campus.radius?.toDouble() ?? 50),
      ),
    ),
  );
}

Future<void> submitPreRegistrationWithQR(String qrData) async {
  Modal.loading();
  var data = {
    'event_schedule_id': activeSchedule.value.id,
    'qr_code': qrData, // Use the provided QR data
  };

  var response = await ApiService.postAuthenticatedResource('/pre-registration', data);
  response.fold(
    (failure) {
      Get.back(); // Close the loading modal

       if (failure.statusCode == 409) {
        // Event is no longer active
        Modal.errorDialog(
          message: 'The event is no longer active. Refreshing data...',
          onDismiss: () async {
        
             EventController.controller.getActiveEvent();
            Get.until((route) => Get.currentRoute == '/home-main'); 
          },
        );
      } else {
        Modal.errorDialog(failure: failure);
      }
      // Modal.errorDialog(failure: failure);
    },
    (success) {
      Get.back(); // Close loading modal
      Modal.success(message: 'Pre-Registration successful!', onDismiss: () async {
    
        Get.until((route) => Get.currentRoute == '/home-main'); 
        await EventController.controller.getActiveEvent();
        Get.to(
          () => MyQRCodePage(),
          arguments: {
            'qrData': qrData,
            'event': activeEvent.value,
            'schedule': activeSchedule.value,
          },
        );
      });
    },
  );
}

  CameraPosition get initialPosition => CameraPosition(
        target: LatLng(
          activeEvent.value.campus?.latitude?.toDouble() ?? 0.0,
          activeEvent.value.campus?.longitude?.toDouble() ?? 0.0,
        ),
        zoom: _getZoomLevel(activeEvent.value.campus?.radius?.toDouble() ?? 50),
      );

  double _getZoomLevel(double radius) {
    double zoomLevel = 16;
    if (radius > 0) {
      double scale = radius / 500;
      zoomLevel = 16 - (log(scale) / log(2)); // Logarithmic scale
    }
    return zoomLevel.clamp(0.0, 20.0);
  }

  Future<void> generateAndNavigateToQR() async {
  try {
 
    Modal.loadingWithPulse();
    await Future.delayed(Duration(seconds: 1));
 
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

   
    final qrData = generateQRData(position);

  
    Get.back();

 
    Get.to(
      () => QRDisplayPage(),
      arguments: {
        'qrData': qrData,
        'event': activeEvent.value,
        'schedule': activeSchedule.value,
        'position': position, 
      },
    );
  } catch (e) {
    Get.back();
    Modal.errorDialog(message: 'Failed to generate QR: $e');
  }
}

String generateQRData(Position position) {
  final userId = Get.find<AuthController>().user.value.id; 
  final eventId = activeEvent.value.id;
  final scheduleId = activeSchedule.value.id;

  final latitude = '${position.latitude}'; 
  final longitude = '${position.longitude}';

  return '$eventId-$scheduleId-$userId-$latitude-$longitude'; //eventId-scheduleId-latitude-longtitude
}


}
