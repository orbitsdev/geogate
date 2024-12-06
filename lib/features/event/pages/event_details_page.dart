import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/widgets/ripple_container.dart';
import 'package:geogate/core/shared/widgets/status_indicator.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final EventController eventController = Get.find<EventController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.setCameraPositionToMyCurrentPosition();
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Event Details', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: RefreshIndicator(
        onRefresh: () => eventController.refreshData(),
        child: GetBuilder<EventController>(
          builder: (controller) {
            return controller.isLoading.value
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Map Section
                        Container(
                          height: 400,
                        
                          decoration: BoxDecoration(
                           
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GoogleMap(
                              gestureRecognizers: {
                                Factory<OneSequenceGestureRecognizer>(
                                  () => EagerGestureRecognizer(),
                                ),
                              },
                              mapType: MapType.normal,
                              myLocationButtonEnabled: true, // Ensure the button is enabled
                              myLocationEnabled: true, // Enable the user's current location indicator
                              onMapCreated: (GoogleMapController controller) {
                                eventController.onMapCreated(controller);
                              },
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  controller.activeEvent.value.campus?.latitude?.toDouble() ?? 0.0,
                                  controller.activeEvent.value.campus?.longitude?.toDouble() ?? 0.0,
                                ),
                                zoom: _getZoomLevel(controller.activeEvent.value.campus?.radius?.toDouble() ?? 50),
                              ),
                              markers: {
                                Marker(
                                  markerId: MarkerId('event_location'),
                                  position: LatLng(
                                    controller.activeEvent.value.campus?.latitude?.toDouble() ?? 0.0,
                                    controller.activeEvent.value.campus?.longitude?.toDouble() ?? 0.0,
                                  ),
                                  infoWindow: InfoWindow(
                                    title: controller.activeEvent.value.eventDescription ?? 'Event Location',
                                    snippet: 'Radius: ${controller.activeEvent.value.campus?.radius?.toStringAsFixed(2)} m',
                                  ),
                                ),
                              },
                              circles: {
                                Circle(
                                  circleId: CircleId('event_radius'),
                                  center: LatLng(
                                    controller.activeEvent.value.campus?.latitude?.toDouble() ?? 0.0,
                                    controller.activeEvent.value.campus?.longitude?.toDouble() ?? 0.0,
                                  ),
                                  radius: controller.activeEvent.value.campus?.radius?.toDouble() ?? 50,
                                  fillColor: Palette.PRIMARY.withOpacity(0.2),
                                  strokeColor: Palette.PRIMARY,
                                  strokeWidth: 2,
                                ),
                              },
                              zoomGesturesEnabled: true,
                            ),
                          ),
                        ),

                        // Event Details Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            boxShadow: [
                             
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Event Name and Organizer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.event, color: Palette.GREEN3, size: 28),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      controller.activeEvent.value.eventDescription ?? 'Unknown Event',
                                      style: Get.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Palette.GREEN3
                                      ),
                                    ),
                                  ),
                                  const StatusIndicator(),
                                ],
                              ),
                              Divider(color: Palette.GREEN1,),
                              SizedBox(height: 16),

                              // Location Section
                              RippleContainer(
                                onTap: (){
                                  // Using activeEvent to move the camera and fit bounds to campus location
    if (controller.activeEvent.value.campus != null) {
      final LatLng eventLocation = LatLng(
        controller.activeEvent.value.campus!.latitude?.toDouble() ?? 0.0,
        controller.activeEvent.value.campus!.longitude?.toDouble() ?? 0.0,
      );
      final double radius = controller.activeEvent.value.campus!.radius?.toDouble() ?? 50;

      // Call the moveToFitBounds function
      controller.moveToFitBounds(eventLocation, radius);
    }
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.location_on, color: Palette.GREEN3, size: 28),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            controller.activeEvent.value.campus?.name ?? 'Location not available',
                                            style: Get.textTheme.bodyMedium?.copyWith(
                                              color: Palette.TEXT_DARK,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    
                                    // Date Section
                                    Row(
                                      children: [
                                        Icon(Icons.calendar_today, color: Palette.GREEN3, size: 28),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            '${controller.activeEvent.value.startDate ?? 'Start Date'} - ${controller.activeEvent.value.endDate ?? 'End Date'}',
                                            style: Get.textTheme.bodyMedium?.copyWith(
                                              color: Palette.TEXT_DARK,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                             
                            ],
                          ),
                        ),
                        Gap(Get.size.height * 0.10),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }

  double _getZoomLevel(double radius) {
    double zoomLevel = 16; // Default zoom level
    if (radius > 0) {
      double scale = radius / 500; // Adjust scale factor if needed
      zoomLevel = 16 - (log(scale) / log(2)); // Logarithmic scale for zoom
    }
    return zoomLevel.clamp(0.0, 20.0); // Ensure zoom level stays within valid bounds
  }
}
