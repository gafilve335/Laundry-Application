import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/data/repositories/product/product_repository.dart';
import 'package:laundry_mobile/app/data/services/mqtt_service.dart'
    as mqtt_service;
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:mqtt_client/mqtt_client.dart';

class ProductCardController extends GetxController with WidgetsBindingObserver {
  static ProductCardController get instance => Get.find();
  final productRepo = Get.put(ProductCardRepository());
  final _mqttService =
      Get.put(mqtt_service.MqttService()); // ใช้บริการ MqttService
  final RxBool isLoading = false.obs;
  final RxBool mqttStatusLoading = false.obs;
  final allProductLoading = false.obs;
  final RxList<ProductCardModel> product = <ProductCardModel>[].obs;
  final RxList<ProductCardModel> allproduct = <ProductCardModel>[].obs;
  final RxMap<String, mqtt_service.ConnectionState> payloads =
      <String, mqtt_service.ConnectionState>{}.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchProductCard();
    fetcAllProduct();
    connectAllProductsToMQTT(); // เชื่อมต่อ MQTT สำหรับผลิตภัณฑ์ทั้งหมด
  }

  @override
  void onClose() {
    super.onClose();
    disconnectAllProductsFromMQTT(); // ยกเลิกการเชื่อมต่อเมื่อ controller ปิด
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  // ติดตามสถานะแอพพลิเคชัน
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      connectAllProductsToMQTT(); // เชื่อมต่อใหม่เมื่อกลับมาทำงานอีกครั้ง
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      disconnectAllProductsFromMQTT(); // ยกเลิกการเชื่อมต่อเมื่อแอปหยุดชั่วคราว
    }
  }

  void connectAllProductsToMQTT() {
    for (final productItem in product) {
      if (productItem.mqttClient.connectionStatus?.state !=
          MqttConnectionState.connected) {
        _mqttService.connectToMQTT(productItem, payloads);
      }
    }
  }

  void disconnectAllProductsFromMQTT() {
    for (final productItem in product) {
      if (productItem.mqttClient.connectionStatus?.state ==
          MqttConnectionState.connected) {
        productItem.mqttClient.disconnect();
      }
    }
  }

  Future<void> fetchProductCard() async {
    try {
      isLoading.value = true;
      final productCard = await productRepo.fecthProductCard();
      product.assignAll(productCard);
      connectAllProductsToMQTT();
    } catch (e) {
      HelperShackBar.errorSnackBar(
        title: 'ERROR_DATABASE_HOME',
        message: 'An error occurred while fetching product card data: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetcAllProduct() async {
    try {
      allProductLoading.value = true;
      final popular = await productRepo.getAllProduct();
      allproduct.assignAll(popular);
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_ALLBANNER',
          message: 'An error occurred while fetching data from the database');
    } finally {
      allProductLoading.value = false;
    }
  }

  Future<void> deleteProduct(String popularId) async {
    try {
      await productRepo.deleteProduct(popularId);
      await fetcAllProduct();
      await fetchProductCard();
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_DELETE_BANNER',
          message: 'An error occurred while deleting data from the database');
    }
  }

  bool checkIfProductIsDiscounted(ProductCardModel productItem) {
    return productItem.discount != 0;
  }
}
