import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:geogate/core/shared/modal/modal.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';

class DeviceController extends GetxController {

  static DeviceController controller = Get.find();
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();


 Map<String, dynamic> deviceData = {};

  Future<Map<String, dynamic>> getDeviceInfo() async {
    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else {
        Modal.showToast(msg: 'Unsupported platform.');
        deviceData = {};
      }
    } on PlatformException {
      Modal.showToast(msg: 'Error retrieving device info.');
      deviceData = {};
    }
    return deviceData;
  }

Map<String, dynamic> readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch ?? 'Unknown',
    'version.sdkInt': build.version.sdkInt ?? 'Unknown',
    'version.release': build.version.release ?? 'Unknown',
    'version.previewSdkInt': build.version.previewSdkInt?.toString() ?? 'N/A',
    'version.incremental': build.version.incremental ?? 'Unknown',
    'version.codename': build.version.codename ?? 'Unknown',
    'version.baseOS': build.version.baseOS ?? 'Unknown',
    'board': build.board ?? 'Unknown',
    'bootloader': build.bootloader ?? 'Unknown',
    'brand': build.brand ?? 'Unknown',
    'device': build.device ?? 'Unknown',
    'display': build.display ?? 'Unknown',
    'fingerprint': build.fingerprint ?? 'Unknown',
    'hardware': build.hardware ?? 'Unknown',
    'host': build.host ?? 'Unknown',
    'id': build.id ?? 'Unknown',
    'manufacturer': build.manufacturer ?? 'Unknown',
    'model': build.model ?? 'Unknown',
    'product': build.product ?? 'Unknown',
    'supported32BitAbis': build.supported32BitAbis?.join(', ') ?? 'N/A',
    'supported64BitAbis': build.supported64BitAbis?.join(', ') ?? 'N/A',
    'supportedAbis': build.supportedAbis?.join(', ') ?? 'N/A',
    'tags': build.tags ?? 'Unknown',
    'type': build.type ?? 'Unknown',
    'isPhysicalDevice': build.isPhysicalDevice ?? false,
    'systemFeatures': build.systemFeatures?.join(', ') ?? 'N/A',
    'serialNumber': build.serialNumber ?? 'Unknown',
    'isLowRamDevice': build.isLowRamDevice ?? false,
  };
}

}
