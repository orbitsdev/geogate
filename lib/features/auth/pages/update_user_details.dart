import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/auth/pages/user_details_page.dart';
import 'package:geogate/features/course/controller/course_controller.dart';
import 'package:get/get.dart';

class UpdateUserDetailsPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final CourseController courseController = Get.find<CourseController>();

  @override
  Widget build(BuildContext context) {
    // Fetch available courses if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (courseController.availableCourses.isEmpty) {
        courseController.fetchAvailableCourse();
      }
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Complete Your Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => UserDetailsPage()); // Navigate to the User Details Page
            },
            icon: const Icon(Icons.person, color: Colors.white),
            tooltip: 'View User Details',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => courseController.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: FormBuilder(
            key: authController.formKey,
            child: Column(
              children: [
                const SizedBox(height: 24),
                _buildTextField(
                  'First Name',
                  'first_name',
                  authController.user.value.userDetails?.firstName ?? '',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Last Name',
                  'last_name',
                  authController.user.value.userDetails?.lastName ?? '',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Full Address',
                  'full_address',
                  authController.user.value.userDetails?.fullAddress ?? '',
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  'Birthday',
                  'birthday',
                  authController.user.value.userDetails?.birthday ?? '',
                  isDate: true,
                ),
                const SizedBox(height: 16),
                GetBuilder<CourseController>(
                  builder: (courseController) {
                    if (courseController.isFetchingCourse.value) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (courseController.availableCourses.isEmpty) {
                      return Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: const Center(
                          child: Text('No courses available.\nPull down to refresh.'),
                        ),
                      );
                    }

                    return FormBuilderDropdown<int>(
  name: 'course_id',
  decoration: InputDecoration(
    labelText: 'Select Course',
    filled: true,
    fillColor: Palette.LIGHT_BACKGROUND,
    contentPadding: const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  initialValue: authController.user.value.userDetails?.courseId,
  validator: FormBuilderValidators.compose([
    FormBuilderValidators.required(),
  ]),
  items: courseController.availableCourses
      .map(
        (course) => DropdownMenuItem<int>(
          value: course.id,
          child: Text(
            course.courseDescription ?? '',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      )
      .toList(),
  selectedItemBuilder: (BuildContext context) {
    return courseController.availableCourses
        .map(
          (course) => Container(
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                course.courseDescription ?? '',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          ),
        )
        .toList();
  },
);


                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.PRIMARY,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => authController.updateUserDetails(),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String name,
    String initialValue, {
    bool isDate = false,
  }) {
    return FormBuilderTextField(
      name: name,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Palette.LIGHT_BACKGROUND,
        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
      readOnly: isDate,
      onTap: isDate
          ? () async {
              DateTime? pickedDate = await showDatePicker(
                context: Get.context!,
                initialDate: DateTime.now(),
                firstDate: DateTime(1900),
                lastDate: DateTime(2100),
              );
              if (pickedDate != null) {
                authController.formKey.currentState?.fields[name]?.didChange(
                      pickedDate.toIso8601String().split('T').first,
                    );
              }
            }
          : null,
    );
  }
}
