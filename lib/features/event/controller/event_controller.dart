import 'package:flutter/material.dart';
import 'package:geogate/core/api/dio/api_service.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/shared/widgets/local_lottie_image.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/model/event.dart';
import 'package:get/get.dart';

class EventController extends GetxController {
  static EventController controller = Get.find();

  var activeEvent = Event().obs; 
  var isLoading = false.obs; 

  
  Future<void> refreshData() async {
    await Future.wait([
      AuthController.controller.fetchAndUpdateUserDetails(),
      getActiveEvent(),
    ]);
  }


  Future<void> getActiveEvent() async {
    isLoading.value = true;
    final response = await ApiService.getAuthenticatedResource('active-event');

    response.fold(
      (failure) {
        isLoading.value = false;
         Modal.errorDialog(failure: failure
          );
        
      },
      (success) {
        isLoading.value = false;
        print('Active Event Data: ${success.data['data']}');

        
        final fetchedEvent = Event.fromJson(success.data['data']);
        activeEvent(fetchedEvent); 
        update(); 
      },
    );
  }
}
