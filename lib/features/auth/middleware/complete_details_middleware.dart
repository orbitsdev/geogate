import 'package:flutter/material.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class CompleteDetailsMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();

    final userDetails = authController.user.value.userDetails;

    // Check if user details are complete
    if (userDetails == null ||
        userDetails.firstName == null ||
        userDetails.lastName == null ||
        userDetails.fullAddress == null ||
        userDetails.birthday == null ||
        userDetails.course?.id == null) {
      // If details are incomplete, redirect to update-user-details page
      return const RouteSettings(name: '/update-user-details');
    }

    // All required fields are present
    return null; 
  }
}
