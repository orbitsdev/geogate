import 'package:flutter/material.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class CompleteDetailsMiddleware extends GetMiddleware {
 
 @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    final userDetails = authController.user.value.userDetails;
    if (userDetails != null &&
        userDetails.firstName != null &&
        userDetails.lastName != null &&
        userDetails.fullAddress != null &&
        userDetails.birthday != null &&
        userDetails.courseId != null) {
      // Redirect to the home page
      return const RouteSettings(name: '/home-main');
    }

    return null; 
  }


  
}
