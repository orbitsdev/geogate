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
    final MyLocationController controller =
        Get.put(MyLocationController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initializeData();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Location'),
        centerTitle: true,
      ),
      body: GetBuilder<MyLocationController>(
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
Obx(() {
  if (controller.isWithinRadius.value) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Palette.GREEN1.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, color: Palette.GREEN3),
          Gap(8),
          Flexible(
            child: Text(
              'Great! You are within the allowed area. Keep up the good work!',
              style: Get.textTheme.bodyLarge?.copyWith(color: Palette.GREEN3),
              
            ),
          ),
        ],
      ),
    );
  } else {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.red.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning, color: Colors.red),
          Gap(8),
          Flexible(
            child: Text(
              'Oops! You are outside the allowed area. Please return to the campus to avoid being marked absent.',
              style: Get.textTheme.bodyLarge?.copyWith(color: Colors.red),
              
            ),
          ),
        ],
      ),
    );
  }
}),

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

                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                                      HeroIcons.buildingLibrary,
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
                                       if(hasPreRegistration)  Container(
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
                                          child:hasPreRegistration? QrImageView(
                                            data:
                                                '${controller.activeSchedule.value.hasPreRegistration?.qrCode ?? "No QR Data"}',
                                            version: QrVersions.auto,
                                            size: 60.0,
                                            backgroundColor: Colors.white,
                                          ): Container()
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
                        Container(width: Get.size.width),
                      
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
