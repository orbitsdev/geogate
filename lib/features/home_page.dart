import 'package:flutter/material.dart';
import 'package:geogate/core/shared/widgets/online_image.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for the header
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 120.0,
            backgroundColor: Palette.PRIMARY,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // User profile image
                  GestureDetector(
                    onTap: () => Get.toNamed('/user-details'),
                    child: ClipOval(
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: OnlineImage(
                          imageUrl: authController.user.value.image ?? '',
                          borderRadius: BorderRadius.circular(25),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Greeting and user name
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${authController.user.value.image}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        Text(
                          "Good Morning,",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                        ),
                        Text(
                          authController.user.value.userDetails?.fullName ??
                              "User",
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              background: Container(
                decoration:  BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Palette.DARK_PRIMARY, Palette.PRIMARY],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          // Sliver for the main content
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Welcome to the Home Page!',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.TEXT_DARK,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
