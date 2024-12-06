import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/helpers/logger.dart';
import 'package:geogate/core/services/notificaiton_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/model/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

class EventController extends GetxController {
  static EventController controller = Get.find();
  final Completer<GoogleMapController> mapCompleter = Completer();
  var activeEvent = Event().obs;
  var isLoading = false.obs;

CameraPosition? cameraPosition = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  GoogleMapController? googleMapController;

  // Fetch active event from API
  Future<void> getActiveEvent() async {
    await NotificationsService.showNotificationWithLogo(
  title: 'Welcome!',
  body: 'Thank you for joining our app!',
  assetPath: 'assets/images/logo.png', // Correct path to your asset
  data: {'type': 'welcome', 'id': 123},
);

    var logger = Logger();


    isLoading.value = true;
    final response = await ApiService.getAuthenticatedResource('active-event');

    response.fold(
      (failure) {
        isLoading.value = false;
        Modal.errorDialog(failure: failure);
      },
      (success) {
        logger.d("${success.data['data']['active_schedule']}");
     
        isLoading.value = false;
        // print('Active Event Data: ${success.data['data']}');
        final fetchedEvent = Event.fromJson(success.data['data']);
        activeEvent(fetchedEvent);
        update();
      },
    );
  }

  // Refresh data for the event details page
  Future<void> refreshData() async {
    await Future.wait([
      AuthController.controller.fetchAndUpdateUserDetails(),
      getActiveEvent(),
    ]);
  }


   // Set the Google Map camera to focus on the event location
  Future<void> setCameraPositionToEvent() async {
    if (googleMapController != null && activeEvent.value.campus != null) {
      final LatLng position = LatLng(
        activeEvent.value.campus!.latitude?.toDouble() ?? 0.0,
        activeEvent.value.campus!.longitude?.toDouble() ?? 0.0,
      );
      CameraPosition cameraPosition = CameraPosition(
        target: position,
        zoom: 15,
      );
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition),
      );
    }
  }

  // Move camera to user's current location
  Future<void> setCameraPositionToMyCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('User denied location permissions.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied, we cannot request permissions.');
      return;
    }

    try {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // LatLng position = LatLng(currentPosition.latitude, currentPosition.longitude);
      // googleMapController?.animateCamera(
      //   CameraUpdate.newLatLng(position),
      // );
    } catch (e) {
      print('Error setting camera position: $e');
    }
  }


  // Handle the map creation and assign the Google Map controller
  void onMapCreated(GoogleMapController controller) {
    if (!mapCompleter.isCompleted) {
      mapCompleter.complete(controller);
      googleMapController = controller;
    }
  }

  // Method to move the camera to a specific position
  void moveCamera(LatLng position) async {
    if (googleMapController != null) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 17.999, tilt: 30, bearing: -1000),
        ),
      );
    } else {
      googleMapController = await mapCompleter.future;
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 17.999, tilt: 30, bearing: -1000),
        ),
      );
    }
  }
  // Set the Google Map camera to focus on the event location
  

  // Move camera to user's current location

  void moveToFitBounds(LatLng center, double radius) async {
  if (googleMapController != null) {
    final bounds = _calculateBounds(center, radius);
    googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  } else {
    googleMapController = await mapCompleter.future;
    final bounds = _calculateBounds(center, radius);
    googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}

// Utility function to calculate the bounds around a point
LatLngBounds _calculateBounds(LatLng center, double radius) {
  double latAdjustment = radius / 111320; // ~1 degree latitude per 111km
  double lngAdjustment = radius / (111320 * cos(center.latitude * pi / 180));
  return LatLngBounds(
    southwest: LatLng(center.latitude - latAdjustment, center.longitude - lngAdjustment),
    northeast: LatLng(center.latitude + latAdjustment, center.longitude + lngAdjustment),
  );
}

// Utility function to calculate appropriate zoom level based on radius
double _getZoomLevel(double radius) {
  double zoomLevel = 16; // Default zoom level
  if (radius > 0) {
    double scale = radius / 500; // Adjust scale factor if needed
    zoomLevel = 16 - (log(scale) / log(2)); // Logarithmic scale for zoom
  }
  return zoomLevel.clamp(0.0, 20.0); // Ensure zoom level stays within valid bounds
}
 

}
