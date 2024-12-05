import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';
import 'package:geogate/core/theme/palette.dart';
import 'package:geogate/features/event/model/event_schedule.dart';

class EventScheduleCard extends StatelessWidget {
  final EventSchedule schedule;
  final bool isActive;

  const EventScheduleCard({
    Key? key,
    required this.schedule,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
         gradient: isActive
      ?  LinearGradient(
          colors: [
            Palette.GREEN3, // Start color
            Palette.PRIMARY, // End color
          ],
          begin: Alignment.topLeft, // Gradient starts from top-left
          end: Alignment.bottomRight, // Gradient ends at bottom-right
        )
      : LinearGradient(
          colors: [
            Colors.grey.shade200,
            Colors.grey.shade300,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${schedule.scheduleDate} ',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: isActive ? Colors.white : Colors.black54,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  '${schedule.startTime} - ${schedule.endTime}',
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: isActive ? Colors.white : Colors.black54,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                if (isActive)
                  Text(
                    'Active Schedule',
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
          if (schedule.isActive == true)
            HeroIcon(
              HeroIcons.checkCircle,
              color: Colors.white,
              size: 24,
            ),
        ],
      ),
    );
  }
}
