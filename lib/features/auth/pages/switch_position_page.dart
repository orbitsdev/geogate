import 'package:flutter/material.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:get/get.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';

class SwitchPositionPage extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.FBG,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text(
          'Switch Position',
          style: Get.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Palette.PRIMARY,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            Text(
              'Choose Your Position',
              style: Get.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Switch your login to another position. Tap on a position to select it.',
              style: Get.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GetBuilder<AuthController>(
                builder: (controller) {
                  final user = controller.user.value;
                  final positions = user.councilPositions ?? [];
                  final selectedPositionId = controller.selectedPositionId;

                  return ListView.builder(
                    itemCount: positions.length,
                    itemBuilder: (context, index) {
                      final position = positions[index];
                      final isActive = user.defaultPosition?.id == position.id;
                      final isSelected = selectedPositionId == position.id;

                      return GestureDetector(
                        onTap: () {
                          // Set the selected position
                          controller.setSelectedPosition(position);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isActive
                                ? Palette.PRIMARY.withOpacity(0.1)
                                : isSelected
                                    ? Palette.PRIMARY
                                    : Colors.white,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    position.position ?? 'Unknown Position',
                                    style: Get.textTheme.bodyLarge!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? Colors.white
                                          : isActive
                                              ? Palette.PRIMARY
                                              : Palette.BLACK,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    position.councilName ?? 'Unknown Council',
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      color: isSelected || isActive
                                          ? Colors.white
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  if (isActive)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        'Current',
                                        style: Get.textTheme.bodySmall!.copyWith(
                                          color: Palette.PRIMARY,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              if (isSelected)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Palette.LIGH_BACKGROUND_GREEN,
                                    size: 24,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            GetBuilder<AuthController>(
              builder: (controller) {
                final selectedPositionId = controller.selectedPositionId;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedPositionId != null
                        ? () => controller.confirmAndSwitchPosition()
                        : null, // Disable if no position is selected
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedPositionId != null
                          ? Palette.PRIMARY
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm Switch Account',
                      style: Get.textTheme.bodyLarge!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
