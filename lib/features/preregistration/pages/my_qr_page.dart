import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/theme/palette.dart';

class MyQRCodePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous page
    final arguments = Get.arguments;
    final qrData = arguments['qrData']; // The data used to generate the QR
    final event = arguments['event']; // Event details, if needed
    final schedule = arguments['schedule']; // Schedule details, if needed

    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
        title: Text('My QR Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Purpose of the QR Code
            Text(
              'This QR Code is used for attendance purposes.',
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Palette.TEXT_DARK,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(16),
            // QR Code
            Center(
              child: QrImageView(
                data: qrData,
                version: QrVersions.auto,
                size: 300.0,
                backgroundColor: Colors.white,
              ),
            ),
            const Gap(16),
            // Event and Schedule Info
            Text(
              'Event: ${event.eventDescription ?? "Unknown"}',
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(8),
            Text(
              'Schedule: ${schedule.startTime ?? "N/A"} - ${schedule.endTime ?? "N/A"}',
              style: Get.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
