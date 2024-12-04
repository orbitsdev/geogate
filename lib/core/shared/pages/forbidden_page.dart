import 'package:flutter/material.dart';
import 'package:geogate/core/helpers/path.dart';
import 'package:geogate/core/shared/widgets/local_image_widget.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';

import 'package:get/get.dart';

class ForbiddenPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: Get.size.height),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                 
                 
                  const SizedBox(height: 16),
                  // Display the Forbidden Image
                  LocalImage(
                    height: 300,
                    imageUrl: imagePath('forbidden.png'),
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 24),
                  // Error Message
                  Text(
                    '403 Forbidden Access',
                    style: Get.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // "Switch Account" Button
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () {
                  //       // Get.to(() => SwitchPositionPage());
                  //     },
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: Palette.ORANGE, // Button color
                  //       padding: const EdgeInsets.symmetric(vertical: 16),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(8),
                  //       ),
                  //     ),
                  //     child: Text(
                  //       'Update User Details',
                  //       style: Get.textTheme.bodyLarge!.copyWith(
                  //         color: Colors.white,
                  //         fontSize: 16,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 8),
                  Text(
                    'Or',
                    style: Get.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        AuthController.controller.logout();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.PRIMARY, // Button color
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Logout',
                        style: Get.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
