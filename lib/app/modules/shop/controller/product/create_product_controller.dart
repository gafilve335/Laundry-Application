import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/data/repositories/product/product_repository.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class CreateProductController extends GetxController {
  static CreateProductController get instance => Get.find();
  final firestorage = Get.put(TFirebaseStorageService());
  final imageURL = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final isbuzzer = false.obs;
  final selectedProvince = ''.obs;
  final RxString targetScreen = AppScreens.allAppScreenItems[0].obs;
  final wMode = Rx<WasherMode?>(null);
  final mqttQos = Rx<CustomMqttQos?>(null);
  final createproduct = GlobalKey<FormState>();
  final selectedImage = Rx<XFile?>(null);

  // Text editing controllers for input fields
  TextEditingController branch = TextEditingController();
  TextEditingController clientId = TextEditingController();
  TextEditingController discount = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
  TextEditingController machineName = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController serverUrl = TextEditingController();
  TextEditingController topic = TextEditingController();
  TextEditingController ldr = TextEditingController();

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

  Future<void> uploadImageProduct(String selectedImagePath) async {
    await _withLoading(() async {
      final imageData = await File(selectedImagePath).readAsBytes();
      final String imageUrl = await firestorage.uploadImageData(
        'Product',
        imageData,
        'product${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      if (imageUrl.isNotEmpty) imageURL.value = imageUrl;
    });
  }

  Future<void> createProduct() async {
    try {
      // Start Loading
      TFullScreenLoader.popUpCircular();

      if (!await NetworkManager.instance.isConnected() ||
          !createproduct.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Get selected image path
      final selectedImagePath = selectedImage.value!.path;
      await uploadImageProduct(selectedImagePath);

      final newRecord = _createProductDetails();
      newRecord.id =
          await ProductCardRepository.instance.createProduct(newRecord);

      ProductCardController.instance.fetcAllProduct();
      ProductCardController.instance.fetchProductCard();

      imageURL.value = "";

      Get.back();

      TFullScreenLoader.stopLoading();
      HelperShackBar.successSnackBar(
        title: 'Congratulations',
        message: 'New Record has been added.',
      );
    } catch (e) {
      TFullScreenLoader.stopLoading();
      HelperShackBar.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  ProductCardModel _createProductDetails() {
    return ProductCardModel(
      id: '',
      branch: branch.text,
      name: machineName.text,
      clientId: clientId.text,
      serverUri: serverUrl.text,
      topic: topic.text,
      discount: double.tryParse(discount.text.trim()) ?? 0,
      price: double.tryParse(price.text.trim()) ?? 0,
      active: isActive.value,
      imageUrl: imageURL.value,
      targetScreen: targetScreen.value,
      mode: wMode.value ?? WasherMode.mode1,
      qos: mqttQos.value ?? CustomMqttQos.atLeastOnce,
      buzzer: isbuzzer.value,
      ldr: int.tryParse(ldr.text.trim()) ?? 500,
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

  void generateRandomClientId() {
    final random = Random();
    const int length = 8;
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final randomString = List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
    clientId.text = 'laundry24_$randomString';
  }
}
