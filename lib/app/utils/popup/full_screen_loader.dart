import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/loaders/animation_loader.dart';
import 'package:laundry_mobile/app/common/widgets/loaders/circular_loader.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          color: THelperFunctions.isDarkMode(Get.context!)
              ? TColors.dark
              : TColors.white,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 250),
              TAnimationLoaderWidget(text: text, animation: animation),
            ],
          ),
        ),
      ),
    );
  }

  static void popUpCircular() {
    Get.defaultDialog(
      title: '',
      onWillPop: () async => false,
      content: const TCircularLoader(),
      backgroundColor: Colors.transparent,
    );
  }

  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
