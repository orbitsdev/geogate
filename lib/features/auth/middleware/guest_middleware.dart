import 'package:flutter/material.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';

class GuestMiddleware extends GetMiddleware {
   @override
  RouteSettings? redirect(String? route) {
    final AuthController authController = Get.find<AuthController>();
    print('GUEST MIDDLWARE-------------');
    print('${authController.token.value}');
    print('${authController.token.value.isNotEmpty}');

    // Check if the token is not empty, meaning the user is already logged in
    if (authController.token.value.isNotEmpty) {
      // Redirect authenticated users to the home page
      return RouteSettings(name: '/home-main');
    }
      // If the token is empty, allow access to guest routes
    print('GUEST MIDDLWARE----------------');
    
      return null;
  }

  
}
