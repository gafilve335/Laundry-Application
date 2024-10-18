import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/data/repositories/popular/popular_repository.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/popular/popular_controller.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class EditPopularController extends GetxController {
  static EditPopularController get instance => Get.find();

  final targetScreen = ''.obs;
  final firestorage = Get.put(TFirebaseStorageService());
  final editPopularFormKey = GlobalKey<FormState>();
  final imageURL = ''.obs;
  final loading = false.obs;
  final selectedImage = Rx<XFile?>(null);
  final isActive = false.obs;
  final repository = Get.put(PopularRepository());

  // Text editing controllers for input fields
  TextEditingController laundryName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController mapLauncher = TextEditingController();
  TextEditingController rating = TextEditingController();
  TextEditingController destibationLat = TextEditingController();
  TextEditingController destibationLon = TextEditingController();

  /// Init Data
  void init(LaundryPopularModel popular) {
    laundryName.text = popular.name;
    city.text = popular.address;
    mapLauncher.text = popular.titleMapLauncher;
    destibationLat.text = popular.destinationLat.toString();
    destibationLon.text = popular.destinationLon.toString();
    rating.text = popular.rating.toString();
    imageURL.value = popular.imageUrl;
    isActive.value = popular.active;
    targetScreen.value = popular.targetScreen;
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

  Future<void> updatePopular(LaundryPopularModel popular) async {
    await _withLoading(() async {
      try {
        TFullScreenLoader.popUpCircular();

        if (!await NetworkManager.instance.isConnected() ||
            !editPopularFormKey.currentState!.validate()) {
          TFullScreenLoader.stopLoading();
          return;
        }

        if (selectedImage.value != null) {
          await firestorage.deleteFileFromStorage(popular.imageUrl);
          final selectedImagePath = selectedImage.value!.path;
          await uploadImagePopular(selectedImagePath);
        }

        if (shouldUpdatePopular(popular)) {
          _updatePopularDetails(popular);
          await repository.updatePopular(popular);
        }

        LaundryPopularController.instance.fetcAllPopular();
        LaundryPopularController.instance.fetcLaundryPopular();

        TFullScreenLoader.stopLoading();

        HelperShackBar.successSnackBar(
            title: 'Congratulations', message: 'Your Record has been updated.');
      } catch (e) {
        TFullScreenLoader.stopLoading();
        TLoggerHelper.error('$e');
        HelperShackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
      }
    });
  }

  bool shouldUpdatePopular(LaundryPopularModel popular) {
    return popular.imageUrl != imageURL.value ||
        popular.targetScreen != targetScreen.value ||
        popular.active != isActive.value ||
        popular.name != laundryName.text ||
        double.tryParse(destibationLat.text) != null &&
            popular.destinationLat != double.parse(destibationLat.text) ||
        double.tryParse(destibationLon.text) != null &&
            popular.destinationLon != double.parse(destibationLon.text) ||
        double.tryParse(rating.text) != null &&
            popular.rating != double.parse(rating.text) ||
        popular.address != city.text;
  }

  void _updatePopularDetails(LaundryPopularModel popular) {
    popular.imageUrl = imageURL.value;
    popular.targetScreen = targetScreen.value;
    popular.active = isActive.value;
    popular.name = laundryName.text;
    popular.destinationLat = double.parse(destibationLat.text);
    popular.destinationLon = double.parse(destibationLon.text);
    popular.rating = double.parse(rating.text);
    popular.address = city.text;
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
