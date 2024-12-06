import 'package:flutter/material.dart';
import 'package:geogate/core/helpers/functions.dart';
import 'package:geogate/core/shared/widgets/online_image.dart';
import 'package:geogate/core/shared/widgets/status_indicator.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/auth/controller/auth_controller.dart';
import 'package:geogate/features/event/controller/event_controller.dart';
import 'package:geogate/features/event/pages/event_details_page.dart';
import 'package:geogate/features/event/widget/event_card.dart';
import 'package:geogate/features/monitor/controller/monitoring_controller.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = Get.find<AuthController>();
  final EventController eventController = Get.find<EventController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      eventController.getActiveEvent();
    });
  }

  void initialzieData() async {
     await eventController.getActiveEvent();
       await MonitoringController.controller.startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await eventController.refreshData();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                authController.user.value.userDetails?.lastName ?? "User",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
       // Space before the StatusIndicator
        // Status Indicator
        const StatusIndicator(),
         const SizedBox(width: 8), 
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

            // Live Event Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Event Now !',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Palette.TEXT_DARK,
                            ),
                      ),
                    ),
                    const Gap(16),
                    Obx(
                      () => eventController.isLoading.value
                          ? Center(child: CircularProgressIndicator())
                          : eventController.activeEvent.value.id == null
                              ? Center(
                                  child: Text(
                                    'No Active Event',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(color: Palette.TEXT_LIGHT),
                                  ),
                                )
                              : EventCard(event: eventController.activeEvent.value, onView: (){
                                Get.to(()=> EventDetailsPage());
                              },),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
