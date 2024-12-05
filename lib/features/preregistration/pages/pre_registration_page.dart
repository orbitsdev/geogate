import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/widgets/ripple_container.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/preregistration/controller/preregistration_controller.dart';
import 'package:geogate/features/preregistration/pages/full_screen_qr.dart';
import 'package:geogate/features/preregistration/pages/my_qr_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
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
                        Text(
                          '${controller.activeEvent.value.eventDescription ?? "Unknown Event"}',
                          style: Get.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Palette.PRIMARY,
                          ),
                        ),
                        Divider(color: Palette.GREEN1),
                        const Gap(8),
                    
                        // Campus and Schedule Details
                        if (controller.activeEvent.value.campus != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Campus: ${controller.activeEvent.value.campus?.name ?? "Unknown"}' ,
                                      style: Get.textTheme.bodyLarge,
                                    ),
                                    Text(
                                      'Schedule: ${controller.activeSchedule.value.startTime ?? "N/A"} - ${controller.activeSchedule.value.endTime ?? "N/A"}',
                                      style: Get.textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  RippleContainer(
                                    onTap: () {
                                      controller.moveCameraToCampus();
                                    },
                                    child: HeroIcon(
                                      HeroIcons.mapPin,
                                      size: 40,
                                      color: Palette.PRIMARY,
                                    ),
                                  ),
                                  Obx(
                                    (){
                                  
                                      final hasPreRegistration = controller
                                      .activeSchedule.value.hasPreRegistration?.user
                                      ?.id ==
                                  AuthController.controller.user.value.id;
                                  
                                  return Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Palette.GREEN2.withOpacity(0.2),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: hasPreRegistration
                                              ? () {
                                                 Get.to(()=> FullScreenQr(qrValue:'${controller.activeSchedule.value.hasPreRegistration?.qrCode}'  ), transition: Transition.zoom);
                                                }
                                              : null,
                                          child: QrImageView(
                                            data:
                                                '${controller.activeSchedule.value.hasPreRegistration?.qrCode ?? "No QR Data"}',
                                            version: QrVersions.auto,
                                            size: 60.0,
                                            backgroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    );
                                    } 
                                  ),
                                  
                                ],
                              ),
                            ],
                          ),
                        const Gap(16),
                    
                        // QR Code and Button
                        Obx(() {
                          final hasPreRegistration = controller
                                  .activeSchedule.value.hasPreRegistration?.user
                                  ?.id ==
                              AuthController.controller.user.value.id;
                    
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container( width: Get.size.width),
                              // QR Code in Circular Background
                              
                              const Gap(16),
                    
                              // Title and Subtitle
                              Text(
                                'Generate QR And Register',
                                style: Get.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Palette.PRIMARY,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const Gap(8),
                              Text(
                                'Generate a QR Code for attendance',
                                style: Get.textTheme.bodyMedium,
                                textAlign: TextAlign.center,
                              ),
                              const Gap(16),
                    
                              // Generate/Update QR Button
                              SizedBox(
                                width: Get.size.width * 0.8,
                                child: ElevatedButton(
                                  onPressed: controller.isWithinRadius.value
                                      ? () async {
                                          await controller.generateAndNavigateToQR();
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor:
                                        controller.isWithinRadius.value
                                            ? Palette.PRIMARY
                                            : Colors.grey.shade400,
                                  ),
                                  child: Text(
                                    hasPreRegistration
                                        ? 'Update QR Code'
                                        : 'Generate QR Code',
                                    style: Get.textTheme.bodyLarge?.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
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
