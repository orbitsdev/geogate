import 'package:flutter/material.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    var authController = Get.find<AuthController>();

    if (authController.token.value.isEmpty == true) {
      return RouteSettings(name: '/login');
    }

    return null;
  }
}
