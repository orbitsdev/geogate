import 'package:flutter/material.dart';
import 'package:geogate/core/shared/widgets/online_image.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/auth/pages/update_user_details.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => AuthController.controller.fetchAndUpdateUserDetails(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          physics: const AlwaysScrollableScrollPhysics(),
          child: GetBuilder<AuthController>(
            builder: (controller) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Header Card
                         // User Image
              Column(children: [
                 Center(
  child: Stack(
    alignment: Alignment.center,
    children: [
      // Profile Picture Container
      Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: OnlineImage(
            imageUrl: authController.user.value.image ?? '',
            fit: BoxFit.cover,
          ),
        ),
      ),
      // Edit Button Icon
      Positioned(
        bottom: 0,
        right: 0,
        child: GestureDetector(
          onTap: () {
            // Navigate to UpdateDetailsPage
            Get.to(() => UpdateUserDetailsPage());
          },
          child: CircleAvatar(
            backgroundColor: Palette.GREEN3,
            radius: 15,
            child: Icon(
              Icons.edit,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
      ),
    ],
  ),
),

                const Gap(16),
              
                // User Name
                Text(
                  '${controller.user.value.userDetails?.firstName ?? ''} '
                  '${controller.user.value.userDetails?.lastName ?? ''}',
                  style: Get.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const Gap(8),
              
                // Email
                Text(
                  controller.user.value.email ?? 'No email available',
                  style: Get.textTheme.bodyMedium?.copyWith(color: Palette.TEXT_DARK),
                  textAlign: TextAlign.center,
                ),
              ],),
                  const Gap(16),
              
                  // Course Section
                  if (controller.user.value.userDetails?.course != null)
                    _buildCourseCard(),
                  const Gap(8),
                  // Campus Section
                  if (controller.user.value.userDetails?.course?.campus != null)
                    _buildCampusCard(),
              
                  const Gap(24),
              
                  // Logout Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.GREEN3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => controller.logout(),
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
              );
            }
          ),
        ),
      ),
    );
  }

  // User Header Card
  Widget _buildUserHeaderCard() {
    return Card(
     elevation: 0,
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
    final course = authController.user.value.userDetails?.course!;
    return Card(
      color: Palette.GREEN1,
     elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(width: Get.size.width,),
            Text(
              'Course Details',
              style: Get.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold,color: Palette.GREEN3),
            ),
            const Gap(8),
            Text(
              'Course Code: ${course?.courseCode ?? ''}',
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Course Description: ${course?.courseDescription ?? ''}',
              style: Get.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  // Campus Card
  Widget _buildCampusCard() {
    final campus = authController.user.value.userDetails?.course?.campus!;
    return Card(
    color: Palette.GREEN1,
     elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Container(width: Get.size.width,),
            Text(
              'Campus Details',
              style: Get.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold,color:  Palette.GREEN3),
            ),
            const Gap(8),
            Text(
              'Name: ${campus?.name ?? ''}',
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Latitude: ${campus?.latitude ?? 'N/A'}',
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Longitude: ${campus?.longitude ?? 'N/A'}',
              style: Get.textTheme.bodySmall,
            ),
            Text(
              'Radius: ${campus?.radius ?? 'N/A'}',
              style: Get.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
