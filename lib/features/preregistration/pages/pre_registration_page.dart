import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/preregistration/controller/preregistration_controller.dart';
import 'package:geogate/features/preregistration/pages/my_qr_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MakePreRegistrationPage extends StatelessWidget {
  const MakePreRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PreRegistrationController controller =
        Get.put(PreRegistrationController());
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
              // Google Map
              GoogleMap(
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

              // Bottom Container
              Positioned(
  bottom: 20,
  left: 8,
  right: 8,
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
          controller.activeEvent.value.eventDescription ?? 'Unknown Event',
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Palette.GREEN3,
          ),
        ),
        const Gap(8),
        Divider(color: Palette.GREEN1,),
        // Campus Name
        if (controller.activeEvent.value.campus != null)
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
            decoration: BoxDecoration(
              // color: Palette.GREEN1,
              borderRadius: BorderRadius.circular(8),
              // border: Border.all(width: 1, color: Palette.GREEN3)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Campus: ${controller.activeEvent.value.campus?.name ?? "Unknown"}',
                  style: Get.textTheme.bodyLarge?.copyWith(
                  ),
                ),
                // Map Pin Icon
                Container(
               
                  child: IconButton(
                    icon:  Icon(Icons.place_outlined, color: Palette.GREEN2,size: 34,),
                    onPressed: () {
                      controller.moveCameraToCampus();
                    },
                  ),
                ),
              ],
            ),
          ),
        const Gap(8),

        // Event Description
       

        // Time and Schedule
        Text(
          'Schedule: ${controller.activeSchedule.value.startTime ?? "N/A"} - ${controller.activeSchedule.value.endTime ?? "N/A"}',
          style: Get.textTheme.bodyMedium,
        ),
        const Gap(16),

        // QR Code or Button
        Obx(() {
          final hasPreRegistration = controller
                  .activeSchedule.value.hasPreRegistration?.user?.id ==
              AuthController.controller.user.value.id;
          return Column(
              children: [
                // QR Code
               if(hasPreRegistration) Center(
                  child: GestureDetector(
                    onTap: (){
                       Get.to(
          () => MyQRCodePage(),
          arguments: {
            'qrData': '${controller.activeSchedule.value.hasPreRegistration?.qrCode}',
            'event': controller.activeEvent.value,
            'schedule': controller.activeSchedule.value,
          },
        );
                    },
                    child: QrImageView(
                      data:
                          '${controller.activeSchedule.value.hasPreRegistration?.qrCode}',
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const Gap(8),

                // QR Details
                // Text(
                //   'QR Value: ${controller.activeSchedule.value.hasPreRegistration?.qrCode}',
                //   textAlign: TextAlign.center,
                //   style: Get.textTheme.bodyMedium,
                // ),
                // const Gap(16),
              // Text('resitaiton ${controller.activeSchedule.value.hasPreRegistration?.user?.id}'),
              // Text('User ${AuthController.controller.user.value.id}'),
              Text('${hasPreRegistration}'),
                // Update QR Button
                  SizedBox(
              width: Get.size.width,
              child: ElevatedButton(
                onPressed: controller.isWithinRadius.value
                    ? () async {
                        await controller.generateAndNavigateToQR();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: controller.isWithinRadius.value
                      ? Palette.PRIMARY
                      : Colors.grey.shade400,
                ),
                child: Text(
                  hasPreRegistration ? 'Update Qr': 'Generate QR',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            )
              ],
            );
        }),
      ],
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
