import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class HelperShackBar extends GetxController {

  static successSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.textWhite,
      backgroundColor: TColors.success,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(LineAwesomeIcons.check_circle, color: TColors.textWhite),
    );
  }

  static warningSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.textWhite,
      backgroundColor: TColors.warning,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(LineAwesomeIcons.exclamation_circle,
          color: TColors.textWhite),
    );
  }

  static errorSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: TColors.textWhite,
      backgroundColor: TColors.error,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(LineAwesomeIcons.times_circle, color: TColors.textWhite),
    );
  }

  static modernSnackBar({required title, message}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      colorText: TColors.textWhite,
      backgroundColor: TColors.info,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
    );
  }
}
