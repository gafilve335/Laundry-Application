import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/data/repositories/popular/popular_repository.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';
import '../../../../utils/helpers/network_manager.dart';

class CreatePopularController extends GetxController {
  static CreatePopularController get instance => Get.find();
  final firestorage = Get.put(TFirebaseStorageService());

  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final RxString targetScreen = AppScreens.allAppScreenItems[0].obs;
  final createPopularFormKey = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);

  // Text editing controllers for input fields
  TextEditingController laundryName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController mapLauncher = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController destibationLat = TextEditingController();
  TextEditingController destibationLon = TextEditingController();

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

  Future<void> uploadImagePopular(String selectedImagePath) async {
    await _withLoading(() async {
      final Uint8List imageData = await File(selectedImagePath).readAsBytes();
      final String imageUrl = await firestorage.uploadImageData(
        'Popular',
        imageData,
        'popular_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      if (imageUrl.isNotEmpty) imageURL.value = imageUrl;
    });
  }

  Future<void> createPopular() async {
    _withLoading(() async {
      try {
        // Start Loading
        TFullScreenLoader.popUpCircular();

        if (!await NetworkManager.instance.isConnected() ||
            !createPopularFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
        }

        final selectedImagePath = selectedImage.value!.path;
        await uploadImagePopular(selectedImagePath);

        final newRecord = _createPopularDetails();
        newRecord.id = await PopularRepository.instance.createBanner(newRecord);

        LaundryPopularController.instance.fetcAllPopular();
        LaundryPopularController.instance.fetcLaundryPopular();

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
    });
  }

  LaundryPopularModel _createPopularDetails() {
    return LaundryPopularModel(
      id: '',
      name: laundryName.text,
      rating: double.tryParse(rating.text.trim()) ?? 0,
      titleMapLauncher: mapLauncher.text,
      active: isActive.value,
      imageUrl: imageURL.value,
      targetScreen: targetScreen.value,
      address: city.text,
      destinationLat: double.tryParse(destibationLat.text.trim()) ?? 0,
      destinationLon: double.tryParse(destibationLon.text.trim()) ?? 0,
    );
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    try {
      loading.value = true;
      await action();
    } finally {
      loading.value = false;
    }
  }
}
