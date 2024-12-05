import 'package:flutter/material.dart';
import 'package:geogate/features/preregistration/controller/preregistration_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:geogate/core/theme/palette.dart';

class QRDisplayPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve arguments passed from the previous page
    final arguments = Get.arguments;
    final qrData = arguments['qrData']; // The data used to generate the QR
    final event = arguments['event']; // Event details, if needed
    final schedule = arguments['schedule']; // Schedule details, if needed
    final isPreRegistered = arguments['isPreRegistered'] ?? false;
    final controller = Get.find<PreRegistrationController>();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.close),
        ),
        title: Text('Your QR Code'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gap(Get.size.height * 0.05),
            // Purpose of the QR Code
            Text(
              'This QR Code is used for attendance purposes.',
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Palette.GREEN2,
              ),
              textAlign: TextAlign.center,
            ),
            const Gap(24),
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
            const Gap(32),
            // Submit Button
            SizedBox(
              width: Get.size.width,
              child: ElevatedButton(
                onPressed: () async {
                  await controller.submitPreRegistrationWithQR(qrData);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.GREEN3,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isPreRegistered ? 'Update QR' : 'Register QR',
                  style: Get.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
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
