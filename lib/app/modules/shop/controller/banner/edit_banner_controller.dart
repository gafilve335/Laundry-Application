import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/banner_model.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';
import '../../../../data/repositories/banners/banners_repository.dart';
import '../../../../utils/helpers/network_manager.dart';

class EditBannerController extends GetxController {
  static EditBannerController get instance => Get.find();
  final firestorage = Get.put(TFirebaseStorageService());

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final targetScreen = ''.obs;
  final selectedImage = Rx<XFile?>(null);
  final formKey = GlobalKey<FormState>();
  final repository = Get.put(BannerRepository());

  /// Init Data
  void init(BannerModel banner) {
    imageURL.value = banner.imageUrl;
    isActive.value = banner.active;
    targetScreen.value = banner.targetScreen;
  }

  Future<void> pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null) {
      selectedImage.value = image;
    }
  }

  Future<void> uploadImageBanner(String selectedImagePath) async {
    try {
      final Uint8List imageData = await File(selectedImagePath).readAsBytes();
      final String imageUrl = await firestorage.uploadImageData(
        'Banners',
        imageData,
        'banner_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      if (imageUrl.isNotEmpty) {
        imageURL.value = imageUrl;
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error uploading image: $e');
      }
    }
  }

  /// Register new Banner
  Future<void> updateBanner(BannerModel banner) async {
    try {
      loading.value = true;
      // Start Loading
      TFullScreenLoader.popUpCircular();

      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //TLoggerHelper.debug('$imageURL');

      if (selectedImage.value != null) {
        // Delete old file
        await firestorage.deleteFileFromStorage(banner.imageUrl);

        // Get selected image path
        final selectedImagePath = selectedImage.value!.path;

        // Call uploadImageBanner to upload image
        await uploadImageBanner(selectedImagePath);
      }

      if (banner.imageUrl != imageURL.value ||
          banner.targetScreen != targetScreen.value ||
          banner.active != isActive.value) {
        // Map Data
        banner.imageUrl = imageURL.value;
        banner.targetScreen = targetScreen.value;
        banner.active = isActive.value;

        await repository.updateBanner(banner);
      }

      BannerController.instance.fetcAllBanners();
      BannerController.instance.fetcBanners();

      TFullScreenLoader.stopLoading();
      loading.value = true;

      // Get.back();

      HelperShackBar.successSnackBar(
          title: 'Congratulations', message: 'Your Record has been updated.');
    } catch (e) {
      TFullScreenLoader.stopLoading();
      HelperShackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
