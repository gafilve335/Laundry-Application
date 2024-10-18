import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/banner_model.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/banner/banner_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';
import '../../../../data/repositories/banners/banners_repository.dart';
import '../../../../utils/helpers/network_manager.dart';

class CreateBannerController extends GetxController {
  static CreateBannerController get instance => Get.find();
  final firestorage = Get.put(TFirebaseStorageService());

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString targetScreen = AppScreens.allAppScreenItems[0].obs;
  final formKey = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);

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
      loading.value = true;
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
    } finally {
      loading.value = false;
    }
  }

  Future<void> createBanner() async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      // Check Internet Connectivity
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

      // Get selected image path
      final selectedImagePath = selectedImage.value!.path;

      // Call uploadImageBanner to upload image
      await uploadImageBanner(selectedImagePath);

      // Map Data
      final newRecord = BannerModel(
        id: '',
        active: isActive.value,
        imageUrl: imageURL.value,
        targetScreen: targetScreen.value,
      );

      // Call Repository to Create New Banner and update Id
      newRecord.id = await BannerRepository.instance.createBanner(newRecord);

      BannerController.instance.fetcAllBanners();
      BannerController.instance.fetcBanners();

      imageURL.value = "";

      Get.back();

      // Remove Loader
      TFullScreenLoader.stopLoading();

      // Success Message & Redirect
      HelperShackBar.successSnackBar(
        title: 'Congratulations',
        message: 'New Record has been added.',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      HelperShackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}
