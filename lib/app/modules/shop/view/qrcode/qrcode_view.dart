import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/appbar/appbar.dart';
import 'package:laundry_mobile/app/modules/shop/view/qrcode/widgets/scan_qrcode_overlay.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../controller/qrcode/qrcode_controller.dart';

class QrcodeView extends StatelessWidget {
  const QrcodeView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(QrcodeController());
    return Scaffold(
      appBar: const TAppBar(
        title: Text('PAYMENT SCANNER'),
        showBackArrow: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Place the QR Code in the area",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Scanning will start automatically",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MobileScanner(
                      controller: controller.cameraController,
                      onDetect: (capture) => controller.onScan(capture),
                    ),
                    const QRScannerOverlay(
                      overlayColour: TColors.light,
                    ),
                  ],
                ),
              ),
            ),
            const Expanded(
              child: Column(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
