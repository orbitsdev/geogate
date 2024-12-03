import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/styles/style.dart';
import 'package:geogate/core/shared/widgets/offline_image.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.DARK_PRIMARY,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Gap(Get.size.height * 0.02),
              // Logo at the top using OfflineImage
              OfflineImage(
                path: 'assets/images/logo.png',
                borderRadius: BorderRadius.circular(12),
                fit: BoxFit.contain,
              ),
              const Gap(24), // Spacing between logo and form
              Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 34,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    Text(
                      'LOGIN',
                      style: Get.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold,color: Colors.white),
                    ),
                    const Gap(32),
                    GetBuilder<AuthController>(builder: (controller) {
                      return SizedBox(
                        height: 50,
                        width: Get.size.width,
                        child: ElevatedButton.icon(
                          style: ELEVATED_BUTTON_SOCIALITE_STYLE,
                          onPressed: () {
                            controller.signInWithGoogle();
                          },
                          icon: SvgPicture.asset(
                            'assets/images/google-logo.svg',
                            height: 24,
                            width: 24,
                            semanticsLabel: 'Google Logo',
                          ),
                          label: Text(
                            'Continue with Google',
                            style: Get.textTheme.bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}
