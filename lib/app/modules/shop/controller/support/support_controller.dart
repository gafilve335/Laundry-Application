import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/support_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/support/support_repository.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class SupportController extends GetxController {
  static SupportController get instance => Get.find();

  final RxList<SupportModel> supportData = <SupportModel>[].obs;
  final supportRepo = Get.put(SupportRepository());
  final support = TextEditingController();
  final saveReport = Get.put(SupportRepository());
  var brand = ''.obs;
  var id = ''.obs;
  var platform = ''.obs;
  var model = ''.obs;
  var fingerprint = ''.obs;
  var userID = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDeviceInformation();
    fecthReport();
  }

  Future<void> fetchDeviceInformation() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    try {
      if (GetPlatform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        platform.value = 'Android';
        brand.value = androidInfo.brand;
        id.value = androidInfo.id;
        model.value = androidInfo.model;
        fingerprint.value = androidInfo.fingerprint;
      }
    } catch (e) {
      debugPrint('Failed to get device info: $e');
    }
  }

  Future<List<SupportModel>> fecthReport() async {
    try {
      final userid = AuthenticationRepository.instance.authUser?.uid;
      if (userid == null || userid.isEmpty) return [];

      final supportDetail = await supportRepo.getReports();
      supportData.addAll(supportDetail);
      return supportDetail;
    } catch (e) {
      HelperShackBar.errorSnackBar(title: "");
      return [];
    }
  }

  Future<void> processReport() async {
    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your Report', TImages.loading);

      // User check
      final userid = AuthenticationRepository.instance.authUser?.uid;
      if (userid == null || userid.isEmpty) return;

      final report = SupportModel(
        userId: userid,
        brand: brand.value,
        id: id.value,
        model: model.value,
        fingerprint: fingerprint.value,
        report: support.text,
        reportDate: DateTime.now(),
      );

      // Save Transaction
      await saveReport.saveReport(report);
      support.clear();
      HelperShackBar.successSnackBar(
          title: 'Successful', message: 'Report successfully submitted.');
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_PROCESS_REPORT',
          message: 'Report error, please try again.');
      TLoggerHelper.error('$e');
    } finally {
      await Future.delayed(const Duration(seconds: 2));
      TFullScreenLoader.stopLoading();
    }
  }
}
