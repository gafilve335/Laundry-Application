import 'package:flutter/material.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQrAppBar extends StatelessWidget {
  const ScanQrAppBar({
    super.key,
    required this.cameraController,
    required this.isDark,
  });

  final MobileScannerController cameraController;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: const IconThemeData(color: TColors.primary),
      backgroundColor: isDark ? TColors.black : TColors.white,
      automaticallyImplyLeading: true,
      actions: [
        IconButton(
          icon: ValueListenableBuilder(
            valueListenable: cameraController.torchState,
            builder: (context, state, child) {
              if (state == TorchState.off) {
                return const Icon(Icons.flash_off, color: TColors.primary);
              } else if (state == TorchState.on) {
                return const Icon(Icons.flash_on, color: Colors.yellow);
              } else {
                return const Icon(Icons.flash_off, color: TColors.primary);
              }
            },
          ),
          onPressed: () => cameraController.toggleTorch(),
        ),
        IconButton(
          color: isDark ? TColors.light : TColors.primary,
          icon: ValueListenableBuilder(
            valueListenable: cameraController.cameraFacingState,
            builder: (context, state, child) {
              IconData icon = Icons.camera_front;
              if (state == CameraFacing.back) {
                icon = Icons.camera_rear;
              }
              return Icon(
                icon,
                color: TColors.primary,
              );
            },
          ),
          onPressed: () => cameraController.switchCamera(),
        ),
      ],
      title: Text(
        'Payment Scaner'.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(letterSpacing: 3.0),
      ),
    );
  }
}
