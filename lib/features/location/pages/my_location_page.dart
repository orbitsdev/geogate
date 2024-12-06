import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/widgets/ripple_container.dart';
import 'package:geogate/core/shared/widgets/status_indicator.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/location/controller/my_location_controller.dart';
import 'package:geogate/features/location/pages/my_location_page.dart';
import 'package:geogate/features/preregistration/controller/preregistration_controller.dart';
import 'package:geogate/features/preregistration/pages/full_screen_qr.dart';
import 'package:geogate/features/preregistration/pages/my_qr_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyLocationPage extends StatelessWidget {
  const MyLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreRegistrationController controller =
        Get.put(PreRegistrationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
        centerTitle: true,
      ),
      body: GetBuilder<PreRegistrationController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              // Google Map (Top Section)
              Container(
                height: Get.size.height * 0.40,
                child: GoogleMap(
                  onMapCreated: (GoogleMapController mapController) {
                    controller.onMapCreated(mapController);
                    controller.showCurrentLocation();
                    controller.moveCameraToCampus();
                    controller.startListeningToPosition();
                  },
                  initialCameraPosition: controller.initialPosition,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  markers: controller.markers.toSet(),
                  circles: controller.geofenceCircles.toSet(),
                ),
              ),

              // Details and Actions (Bottom Section)
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Event Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                '${controller.activeEvent.value.eventDescription ?? "Unknown Event"}' ,
                                style: Get.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.PRIMARY,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(color: Palette.GREEN1),
                        const Gap(8),
                    
                        // Campus and Schedule Details
                        
                        
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
