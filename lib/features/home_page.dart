import 'package:flutter/material.dart';
import 'package:geogate/core/helpers/functions.dart';
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
      body: RefreshIndicator(
        onRefresh: () async {
          // Trigger the fetch and update function
          await authController.fetchAndUpdateUserDetails();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
          slivers: [
            // SliverAppBar for the header
            SliverAppBar(
              automaticallyImplyLeading: false,
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
                            "${getGreeting()}",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                          Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            authController.user.value.userDetails?.lastName ??
                                "User",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
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
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Palette.DARK_PRIMARY, Palette.PRIMARY],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),

            
          ],
        ),
      ),
    );
  }
}
