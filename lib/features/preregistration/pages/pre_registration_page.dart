import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/preregistration/controller/preregistration_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class MakePreRegistrationPage extends StatelessWidget {
  const MakePreRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreRegistrationController controller = Get.put(PreRegistrationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pre-Register'),
        centerTitle: true,
      ),
      body: GetBuilder<PreRegistrationController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: (GoogleMapController mapController) {
                  controller.onMapCreated(mapController);
                  controller.moveCameraToCampus();
                  controller.startListeningToPosition(); // Move the camera to the campus location
                },
                initialCameraPosition: controller.initialPosition,
                myLocationEnabled: true,
                markers: controller.markers.toSet(),
                circles: controller.geofenceCircles.toSet(),
              ),
              Positioned(
                bottom: 20,
                left: 12,
                right: 12,
                child: Column(
                  children: [
                    Text(
                      controller.activeEvent.value.eventDescription ?? 'Unknown Event',
                      style: Get.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const Gap(16),
                   SizedBox(
  width: Get.size.width,
  child: ElevatedButton(
    onPressed: controller.isWithinRadius.value
        ? () => controller.submitPreRegistration()
        : null,
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      backgroundColor: controller.isWithinRadius.value
          ? Palette.PRIMARY
          : Colors.grey.shade400, // Adjust color for enabled/disabled states
      foregroundColor: Colors.white, // Text color
    ),
    child: Text(
      'Pre-Register',
      style: Get.textTheme.bodyLarge?.copyWith(color: Colors.white),
    ),
  ),
),

                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
