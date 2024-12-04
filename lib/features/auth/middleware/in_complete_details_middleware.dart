import 'package:flutter/material.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';

class InCompleteDetailsMiddleware extends GetMiddleware {
  
   @override
  RouteSettings? redirect(String? route) {

// final AuthController authController = Get.find<AuthController>();

//     final user = authController.user.value;

//     print('FROM MIDDLEWARE ----------');
//     print(user.userDetails?.toJson());
//     print(user.course?.toJson());
//     print(user.course?.campus?.toJson());
//     print('FROM MIDDLEWAREsddd ----------');

  
//     if (user.userDetails == null ||
//         user.userDetails?.firstName == null ||
//         user.userDetails?.lastName == null ||
//         user.userDetails?.fullAddress == null ||
//         user.userDetails?.birthday == null ||
//         user.course?.id == null) {
        
     
//       // return const RouteSettings(name: '/update-user-details');
//     }

//     // Return null if no redirection is needed
//     return null;
//   }
return  null;
  }
  
}
