import 'package:flutter/material.dart';
import 'package:geogate/features/monitor/controller/monitoring_controller.dart';
import 'package:get/get.dart';

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Negate isOutside to determine isInside
      final isInside = !MonitoringController.controller.isOutside.value;

      return Column(
        mainAxisSize: MainAxisSize.min, // Keeps the widget compact
        children: [
          // Circle Dot
          Container(
            width: 10, // Slightly larger for better visibility
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isInside ? Colors.green : Colors.red,
              boxShadow: [
                BoxShadow(
                  color: (isInside ? Colors.green : Colors.red).withOpacity(0.5),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(height: 2), // Spacing between dot and text
          // Status Text
          Text(
            isInside ? "In-Range" : "Out-Of-Range",
            style: TextStyle(
              fontSize: 10, // Slightly larger for better readability
              color: isInside ? Colors.green : Colors.red, // Matches dot color
            ),
          ),
        ],
      );
    });
  }
}