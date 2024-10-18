import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/data/repositories/product/product_repository.dart';
import 'package:laundry_mobile/app/data/services/firebase_storage_service.dart';
import 'package:laundry_mobile/app/modules/shop/controller/product/product_controller.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/helpers/pricing_calculator.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:http/http.dart' as http;

class EditProductController extends GetxController {
  static EditProductController get instance => Get.find();
  final repository = Get.put(ProductCardRepository());
  final firestorage = Get.put(TFirebaseStorageService());
  final localStorage = GetStorage();

  final imageURL = ''.obs;
  final targetScreen = ''.obs;
  final loading = false.obs;
  final isActive = false.obs;
  final isbuzzer = false.obs;
  final selectedProvince = ''.obs;
  final hardwareConfig = false.obs;
  final mqttConfig = false.obs;
  final mqttQos = Rx<CustomMqttQos?>(null);
  final wMode = Rx<WasherMode?>(null);
  final selectedImage = Rx<XFile?>(null);
  final editProductFormkey = GlobalKey<FormState>();

  // Text editing controllers for input fields
  final branch = TextEditingController();
  final clientId = TextEditingController();
  final discount = TextEditingController();
  final imageUrl = TextEditingController();
  final machineName = TextEditingController();
  final price = TextEditingController();
  final serverUrl = TextEditingController();
  final topic = TextEditingController();
  final ldr = TextEditingController();

  /// Init Data
  void init(ProductCardModel product) {
    branch.text = product.branch;
    clientId.text = product.clientId;
    discount.text = product.discount.toString();
    price.text = product.price.toString();
    serverUrl.text = product.serverUri;
    topic.text = product.topic;
    machineName.text = product.name;
    imageURL.value = product.imageUrl;
    isActive.value = product.active;
    targetScreen.value = product.targetScreen;
    wMode.value = product.mode;
    mqttQos.value = product.qos;
    isbuzzer.value = product.buzzer;
    ldr.text = product.ldr.toString();

    // ดึงค่าจาก local
    hardwareConfig.value = localStorage.read('hardwareConfig') ?? true;
    mqttConfig.value = localStorage.read('mqttConfig') ?? true;
  }

  void updateHardwareConfig(bool value) {
    _updateLocalStorage('hardwareConfig', value, hardwareConfig);
  }

  void updateMqttConfig(bool value) {
    _updateLocalStorage('mqttConfig', value, mqttConfig);
  }

  void generateRandomClientId() {
    clientId.text = 'laundry24_${_generateRandomString(8)}';
  }

  Future<void> pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 1024,
      maxWidth: 1024,
    );
    if (image != null) selectedImage.value = image;
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

  Future<void> updateProduct(ProductCardModel product) async {
    await _withLoading(() async {
      TFullScreenLoader.popUpCircular();

      if (!await NetworkManager.instance.isConnected() ||
          !editProductFormkey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      if (selectedImage.value != null) {
        await firestorage.deleteFileFromStorage(product.imageUrl);
        await uploadImageProduct(selectedImage.value!.path);
      }

      if (mqttConfig.value) await publishMqttConfig(product);
      if (shouldUpdateProduct(product)) {
        _updateProductDetails(product);
        await repository.updateProduct(product);
      }

      if (hardwareConfig.value) await publishHardwareConfig(product);
      await publishMqttMessage(product);

      await ProductCardController.instance.fetchProductCard();
      await ProductCardController.instance.fetcAllProduct();

      TFullScreenLoader.stopLoading();
      HelperShackBar.successSnackBar(
          title: 'Congratulations', message: 'Your Record has been updated.');
    });
  }

  bool shouldUpdateProduct(ProductCardModel product) {
    return product.imageUrl != imageURL.value ||
        product.targetScreen != targetScreen.value ||
        product.active != isActive.value ||
        product.name != machineName.text ||
        product.branch != branch.text ||
        product.clientId != clientId.text ||
        product.serverUri != serverUrl.text ||
        product.topic != topic.text ||
        product.price != double.parse(price.text) ||
        product.discount != double.parse(discount.text) ||
        product.mode != wMode.value ||
        product.qos != mqttQos.value ||
        product.buzzer != isbuzzer.value ||
        product.ldr != int.parse(ldr.text);
  }

  // ฟังก์ชันช่วยในการจัดการ MQTT Config
  Future<void> publishMqttMessage(ProductCardModel product) async {
    await _publishMqttPayload(product, {
      'type': 'ESP32CMD',
      'value':
          'SET_PRICE_${TPricingCalculator.calculatePriceAfterDiscount(product.price, product.discount)}',
    });
  }

  Future<void> publishMqttConfig(ProductCardModel product) async {
    await _publishMqttPayload(product, {
      'type': 'ESP32CMD',
      'value': 'SET_MQTT_CONFIG',
      'server': serverUrl.text,
      'topic': topic.text,
      'port': '1883',
    });
  }

  Future<void> publishHardwareConfig(ProductCardModel product) async {
    await _publishMqttPayload(product, {
      'type': 'ESP32CMD',
      'value': 'HARDWARE_CONFIG',
      'mode': wMode.value.toString(),
      'buzzer': isbuzzer.value ? 'true' : 'false',
      'light': ldr.text,
      'encode': machineName.text
    });
  }

  Future<void> sendMQTTConfig() async {
    final data = {
      'type': 'ESP32CMD',
      'value': 'SET_MQTT_CONFIG',
      'server': serverUrl.text,
      'topic': topic.text,
      'port': '1883'
    };
    await _sendHttpPost('http://esp32.local/post', data);
  }

  void _updateProductDetails(ProductCardModel product) {
    product.imageUrl = imageURL.value;
    product.targetScreen = targetScreen.value;
    product.active = isActive.value;
    product.name = machineName.text;
    product.branch = branch.text;
    product.clientId = clientId.text;
    product.serverUri = serverUrl.text;
    product.topic = topic.text;
    product.price = double.parse(price.text);
    product.discount = double.parse(discount.text);
    product.mode = wMode.value ?? WasherMode.mode1;
    product.qos = mqttQos.value ?? CustomMqttQos.atLeastOnce;
    product.buzzer = isbuzzer.value;
    product.ldr = int.parse(ldr.text);
  }

  Future<void> _publishMqttPayload(
      ProductCardModel product, Map<String, dynamic> jsonMessage) async {
    final mqttClient = MqttServerClient(product.serverUri, product.clientId);
    try {
      await mqttClient.connect();
      final jsonString = json.encode(jsonMessage);
      final builder = MqttClientPayloadBuilder()..addString(jsonString);
      mqttClient.publishMessage(
          product.topic,
          convertToMqttQos(mqttQos.value ?? CustomMqttQos.atLeastOnce),
          builder.payload!);
    } catch (e) {
      if (kDebugMode) debugPrint('MQTT Connection Error: $e');
    } finally {
      mqttClient.disconnect();
    }
  }

  Future<void> _sendHttpPost(String url, Map<String, dynamic> data) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data));
      if (response.statusCode == 200) {
        HelperShackBar.successSnackBar(
            title: "HTTP::RESPONE_SUCCESS", message: "PAIR A DEVICE");
      } else {
        HelperShackBar.errorSnackBar(
            title: "HTTP::RESPONE_ERROR",
            message: "PAIR A DEVICE_ERROR_${response.statusCode}");
      }
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: "HTTP::RESPONE_ERROR", message: "PAIR A DEVICE_ERROR_$e");
    }
  }

  void _updateLocalStorage(String key, bool value, RxBool observable) {
    observable.value = value;
    localStorage.write(key, value);
  }

  Future<void> _withLoading(Future<void> Function() action) async {
    try {
      loading.value = true;
      await action();
    } finally {
      loading.value = false;
    }
  }

  String _generateRandomString(int length) {
    const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List.generate(
            length, (index) => characters[random.nextInt(characters.length)])
        .join();
  }
}
