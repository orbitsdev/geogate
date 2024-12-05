import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

class FullScreenQr extends StatelessWidget {
  final String qrValue;
  const FullScreenQr({
    Key? key,
    required this.qrValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back(); // Navigate back
          },
          icon: const Icon(Icons.close),
        ),
        title: const Text('QR Code'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // QR Code
            QrImageView(
              data: qrValue,
              version: QrVersions.auto,
              size: 300.0,
              backgroundColor: Colors.white,
            ),
            const Gap(16),
            // Optional: Subtitle
            Text(
              'Scan this QR Code for attendance',
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
