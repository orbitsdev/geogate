
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/styles/style.dart';
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
          padding: EdgeInsets.only(
            left: 8,
            right: 8,
            bottom: 60.0,
          ),
          child: Column(
            children: [
              Gap(Get.size.height * 0.02),
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 34,
                  bottom: 30,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [

                    Text(
                      'LOGIN',
                      style: Get.textTheme.titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
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
                          icon: Container(
                            child: SvgPicture.asset(
                              height: 24,
                              width: 24,
                              'assets/images/google-logo.svg', // Added ".svg" extension
                              semanticsLabel:
                                  'Google Logo', // Adjusted semantics label
                            ),
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
