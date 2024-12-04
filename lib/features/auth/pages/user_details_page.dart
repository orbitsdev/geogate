import 'package:flutter/material.dart';
import 'package:geogate/core/shared/widgets/online_image.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.PRIMARY,
        title: const Text(
          'User Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => AuthController.controller.fetchAndUpdateUserDetails(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header Card
                     // User Image
          Column(children: [
              Center(
              child: Container(
                width: 90,
                height: 90,
                child: OnlineImage(
                  imageUrl: authController.user.value.image ?? '',
                  borderRadius: BorderRadius.circular(50),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(16),

            // User Name
            Text(
              '${authController.user.value.userDetails?.firstName ?? ''} '
              '${authController.user.value.userDetails?.lastName ?? ''}',
              style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(8),

            // Email
            Text(
              authController.user.value.email ?? 'No email available',
              style: Get.textTheme.bodyMedium?.copyWith(color: Palette.TEXT_DARK),
              textAlign: TextAlign.center,
            ),
          ],),
              const Gap(16),

              // Course Section
              if (authController.user.value.course != null)
                _buildCourseCard(),

              // Campus Section
              if (authController.user.value.course?.campus != null)
                _buildCampusCard(),

              const Gap(24),

              // Logout Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.RED,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => authController.logout(),
                  child: const Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // User Header Card
  Widget _buildUserHeaderCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // User Image
            ClipOval(
              child: Container(
                width: 60,
                height: 60,
                child: OnlineImage(
                  imageUrl: authController.user.value.image ?? '',
                  borderRadius: BorderRadius.circular(50),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(16),
            // User Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${authController.user.value.userDetails?.firstName ?? ''} ${authController.user.value.userDetails?.lastName ?? ''}',
                    style: Get.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const Gap(4),
                  Text(
                    authController.user.value.email ?? 'No email available',
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Palette.TEXT_DARK),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Course Card
  Widget _buildCourseCard() {
    final course = authController.user.value.course!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course Details',
              style: Get.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'Course Code: ${course.courseCode ?? ''}',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              'Course Description: ${course.courseDescription ?? ''}',
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  // Campus Card
  Widget _buildCampusCard() {
    final campus = authController.user.value.course?.campus!;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Campus Details',
              style: Get.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Gap(8),
            Text(
              'Name: ${campus?.name ?? ''}',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              'Latitude: ${campus?.latitude ?? 'N/A'}',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              'Longitude: ${campus?.longitude ?? 'N/A'}',
              style: Get.textTheme.bodyMedium,
            ),
            Text(
              'Radius: ${campus?.radius ?? 'N/A'}',
              style: Get.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
