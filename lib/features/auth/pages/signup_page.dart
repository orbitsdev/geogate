import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocation/core/constant/style.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:gradient_elevated_button/gradient_elevated_button.dart';

class SignupPage extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.PRIMARY,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Ensure keyboard dismisses only if not focused on a form field
            // if (FocusScope.of(context).hasPrimaryFocus) {
            //   FocusScope.of(context).unfocus();
            // }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 22, vertical: 34),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14)),
                  child: Column(
                    children: [
                      Text(
                        'SIGN UP',
                        style: Get.textTheme.displaySmall
                            ?.copyWith(fontWeight: FontWeight.bold, height: 0),
                      ),
                      Gap(16),
                      RichText(
                        text: TextSpan(
                          text: 'Already Have an account? ',
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Palette.BLACK_SIMI),
                          children: [
                            TextSpan(
                              text: ' Login',
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  color: Palette.PRIMARY,
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.back();
                                },
                            ),
                          ],
                        ),
                      ),
                      Gap(32),
                      FormBuilder(
                        key: controller.signupFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('First name', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            FormBuilderTextField(
                              initialValue: 'Angila',
                              name: 'first_name',
                              decoration: _inputDecoration('Enter your first name'),
                              validator: FormBuilderValidators.required(),
                            ),
                            const Gap(16),
                            Text('Last name', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            FormBuilderTextField(
                              initialValue: 'Tirado',
                              name: 'last_name',
                              decoration: _inputDecoration('Enter your last name'),
                              validator: FormBuilderValidators.required(),
                            ),
                            const Gap(16),
                            Text('Email', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            FormBuilderTextField(
                              initialValue: '@gmail.com',
                              name: 'email',
                              decoration: _inputDecoration('Enter your email'),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(),
                                FormBuilderValidators.email(),
                              ]),
                            ),
                            const Gap(16),
                            Text('Password', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            Obx(() => FormBuilderTextField(
                                  initialValue: 'password',
                                  name: 'password',
                                  obscureText:
                                      controller.obscurePassword.value,
                                  decoration:
                                      _inputDecoration('Enter your password')
                                          .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(controller.obscurePassword.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: controller.togglePasswordSignup,
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6),
                                  ]),
                                )),
                            const Gap(16),
                            Text('Confirm Password', style: Get.textTheme.bodyMedium),
                            const Gap(2),
                            Obx(() => FormBuilderTextField(
                                  initialValue: 'password',
                                  name: 'password_confirmation',
                                  obscureText:
                                      controller.obscureConfirm.value,
                                  decoration: _inputDecoration(
                                          'Confirm your password')
                                      .copyWith(
                                    suffixIcon: IconButton(
                                      icon: Icon(controller.obscureConfirm.value
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed:
                                          controller.togglePasswordConfirm,
                                    ),
                                  ),
                                  validator: FormBuilderValidators.compose([
                                    FormBuilderValidators.required(),
                                    FormBuilderValidators.minLength(6),
                                  ]),
                                )),
                            const Gap(32),
                            Obx(() => SizedBox(
                                  height: 50,
                                  width: Get.size.width,
                                  child: GradientElevatedButton(
                                    onPressed: controller.isSignupLoading.value
                                        ? null
                                        : () => controller.register(),
                                    style: GRADIENT_ELEVATED_BUTTON_STYLE,
                                    child: controller.isSignupLoading.value
                                        ? CircularProgressIndicator(
                                            color: Colors.white)
                                        : Text(
                                            'Sign Up',
                                            style: Get.textTheme.bodyLarge
                                                ?.copyWith(color: Colors.white),
                                          ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Input decoration helper
  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Palette.LIGHT_BACKGROUND,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(12),
      ),
      hintText: hintText,
    );
  }
}
