import 'package:flutter/material.dart';
import 'package:geolocation/features/auth/model/council_position.dart';
import 'package:get/get.dart';
import 'package:geolocation/core/theme/palette.dart';
import 'package:geolocation/features/auth/controller/auth_controller.dart';
import 'package:geolocation/features/auth/model/user.dart';

class SwitchUserPage extends StatelessWidget {
  const SwitchUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Switch User',
          style: Get.textTheme.titleLarge!.copyWith(color: Colors.white),
        ),
        backgroundColor: Palette.PRIMARY,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Current User Section
          GetBuilder<AuthController>(
            builder: (controller) => _buildCurrentUserSection(controller.user.value),
          ),
          Divider(),
          // Council Positions Section
          Expanded(
            child: GetBuilder<AuthController>(
              builder: (controller) {
                final councilPositions = controller.user.value.councilPositions ?? [];
                final selectedPositionId = controller.selectedPositionId;

                return ListView.builder(
                  itemCount: councilPositions.length,
                  itemBuilder: (context, index) {
                    final position = councilPositions[index];
                    final isActive = controller.user.value.defaultPosition?.id == position.id;
                    final isSelected = selectedPositionId == position.id;

                    return _buildPositionTile(
                      position: position,
                      isActive: isActive,
                      isSelected: isSelected,
                      onTap: () => controller.setSelectedPosition(position),
                    );
                  },
                );
              },
            ),
          ),
          // Confirm Switch Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GetBuilder<AuthController>(
              builder: (controller) {
                final selectedPositionId = controller.selectedPositionId;
                return ElevatedButton(
                  onPressed: selectedPositionId != null
                      ? () => controller.confirmAndSwitchPosition()
                      : null, // Disable if no position is selected
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Palette.PRIMARY,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Switch to Selected Position',
                    style: Get.textTheme.bodyLarge,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Build Current User Section
  Widget _buildCurrentUserSection(User user) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(user.image ?? ''),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.fullName ?? 'Full Name',
                style: Get.textTheme.bodyLarge,
              ),
              const SizedBox(height: 4),
              Text(
                user.email ?? 'email@example.com',
                style: Get.textTheme.bodyMedium!.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.PRIMARY,
                  foregroundColor: Colors.white,
                ),
                child: const Text('My Account'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Build Position Tile
  Widget _buildPositionTile({
    required CouncilPosition position,
    required bool isActive,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: isActive ? Palette.PRIMARY : Colors.grey[300],
        child: Icon(
          isActive ? Icons.check : Icons.person_outline,
          color: Colors.white,
        ),
      ),
      title: Text(
        position.position ?? 'Unknown Position',
        style: Get.textTheme.bodyMedium,
      ),
      subtitle: Text(
        position.councilName ?? 'Unknown Council',
        style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
      ),
      trailing: isActive
          ? Text(
              'Current',
              style: Get.textTheme.bodySmall!.copyWith(color: Palette.PRIMARY, fontWeight: FontWeight.bold),
            )
          : isSelected
              ? Icon(Icons.radio_button_checked, color: Palette.PRIMARY)
              : Icon(Icons.radio_button_unchecked, color: Colors.grey),
      onTap: isActive ? null : onTap,
    );
  }
}
