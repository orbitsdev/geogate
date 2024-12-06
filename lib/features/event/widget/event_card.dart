import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:geogate/core/shared/widgets/ripple_container.dart';
import 'package:geogate/features/event/widget/event_schedule_card.dart';
import 'package:geogate/features/location/controller/my_location_controller.dart';
import 'package:geogate/features/location/pages/my_location_page.dart';
import 'package:geogate/features/preregistration/pages/pre_registration_page.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/event/model/event.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onView;

  const EventCard({
    Key? key,
    required this.event,
    required this.onView,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Palette.GREEN3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      margin: const EdgeInsets.only(bottom: 24),
      child: Stack(
        children: [
          // Background SVG Image
          Positioned(
            top: 8,
            right: 8,
            child: SizedBox(
              height: 120,
              width: 120,
            child: SvgPicture.asset(
                'assets/images/event.svg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Date Section
              Row(
                children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${event.startDate}',
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Palette.GREEN3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const Gap(16),
              // Event Description Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Event Description
                    Text(
                      event.eventDescription ?? 'Unknown Event',
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Palette.DARK_PRIMARY,
                      ),
                    ),
                    const Gap(8),
                    // Coordinates Section with Background
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16,),
                      decoration: BoxDecoration(
                        color: Palette.GREEN1,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${event.campus?.name}',
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Palette.GREEN3,
                                  ),
                                ),
                                Gap(4),
                                Text(
                                  'Coordinates',
                                  style: Get.textTheme.bodySmall!.copyWith(
                                    color: Palette.GREEN3,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                const Gap(6),
                                Text(
                                  'Latitude: ${event.campus?.latitude}',
                                  style: Get.textTheme.bodySmall,
                                ),
                                const Gap(2),
                                Text(
                                  'Lotitude:${event.campus?.longitude}',
                                  style: Get.textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                          RippleContainer(
                            onTap: onView,
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: Palette.GREEN3,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: HeroIcon(
                                  HeroIcons.mapPin,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Divider(),
                    // Event Schedules Section
                    if (event.eventSchedules != null && event.eventSchedules!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Schedules:',
                            style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Palette.DARK_PRIMARY,
                            ),
                          ),
                          const Gap(8),
                          // List of Schedules
                         Column(
  children: event.eventSchedules!.map((schedule) {
    return RippleContainer(
      onTap: () {
        if (schedule.isActive == true) {
          if (schedule.hasAttendance != null && schedule.hasAttendance?.id != null) {
            // Show bottom sheet with options
            Modal.showEventOptions(
              onPreRegistration: () {
                Get.to(
                  () => const MakePreRegistrationPage(),
                  arguments: {
                    'event': event,
                    'event_schedule': schedule,
                  },
                );
              },
              onMonitorLocation: () {
                Get.to(
                  () =>  MyLocationPage(),
                  arguments: {
                    'event': event,
                    'event_schedule': schedule,
                  },
                );
              },
            );
          }else{
            Get.to(
                  () => const MakePreRegistrationPage(),
                  arguments: {
                    'event': event,
                    'event_schedule': schedule,
                  },
                );
          }
        } else {
          Modal.showToast(
            msg: 'You can only navigate to events with an active schedule.',
            color: Palette.GREEN3,
          );
        }
      },
      child: EventScheduleCard(
        schedule: schedule,
        isActive: schedule.id == event.activeSchedule?.id,
      ),
    );
  }).toList(),
)

                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
