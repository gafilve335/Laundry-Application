import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/form/success_screen.dart';
import 'package:laundry_mobile/app/data/models/order_model.dart';
import 'package:laundry_mobile/app/data/models/transaction_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/order/order_repository.dart';
import 'package:laundry_mobile/app/data/repositories/transaction/transaction_repository.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/checkout/checkout_controller.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:network_info_plus/network_info_plus.dart';

class QrcodeController extends GetxController {
  var isScanCompleted = false.obs;
  var scannedData = ''.obs;
  final checkOut = Get.find<CheckOutController>();
  final orderRepository = Get.put(OrderRepository());
  final transactionRepo = Get.put(TransactionRepository());
  final userRepository = Get.put(UserRepository());
  final Map arguments = Get.arguments;
  final MobileScannerController cameraController =
      MobileScannerController(formats: [
    BarcodeFormat.qrCode,
  ]);
  MqttServerClient? mqttClient;

  @override
  void onInit() {
    super.onInit();
    cameraController.start();
  }

  @override
  void dispose() {
    cameraController.dispose();
    mqttClient?.disconnect();
    super.dispose();
  }

  Future<void> onScan(BarcodeCapture capture) async {
    if (!isScanCompleted.value) {
      isScanCompleted.value = true;

      for (final barcode in capture.barcodes) {
        final rawValue = barcode.rawValue;
        if (rawValue != null) {
          await processOrder(checkOut.priceAfterDiscount.value, rawValue);
        } else {
          _showErrorSnackbar('Invalid QR Code. Please try again.');
        }
      }
    }
  }

  Future<void> processOrder(double totalAmount, String rawValue) async {
    final productItem = Get.arguments['index'];
    if (!await _checkNetworkConnection()) return;

    final userid = AuthenticationRepository.instance.authUser?.uid;
    if (userid == null || userid.isEmpty) {
      _showErrorSnackbar('User not signed in. Please sign in and try again.');
      return;
    }

    if (rawValue != productItem.name) {
      _showErrorSnackbar('Incorrect machine selected. Please try again.');
      return;
    }

    try {
      TFullScreenLoader.openLoadingDialog(
          'Processing your order', TImages.penciAnimation);

      final order = _createOrderModel(productItem, userid);
      await orderRepository.addOrder(order, userid);

      final transaction =
          _createTransactionModel(productItem, userid, totalAmount);
      await transactionRepo.save(transaction, userid);

      await _sendMqttCommand(productItem, totalAmount, userid);
    } catch (e) {
      TLoggerHelper.error('processOrder Error :: $e');
      _showErrorSnackbar(
          'Failed to process the order. Please contact support.');
    } finally {
      TFullScreenLoader.stopLoading();
      mqttClient?.disconnect();
    }
  }

  OrderModel _createOrderModel(productItem, String userid) {
    return OrderModel(
      name: productItem.name,
      id: UniqueKey().toString(),
      userId: userid,
      branch: productItem.branch,
      price: productItem.price,
      discount: productItem.discount,
      totalAmount: checkOut.priceAfterDiscount.value,
      orderDate: DateTime.now(),
    );
  }

  OrderTransactionModel _createTransactionModel(
      productItem, String userid, double totalAmount) {
    return OrderTransactionModel(
      name: productItem.name,
      userId: userid,
      price: totalAmount,
      transactionType: 'payment',
      transactionDate: DateTime.now(),
    );
  }

  Future<void> _sendMqttCommand(
      productItem, double totalAmount, String userid) async {
    mqttClient = MqttServerClient(productItem.serverUri, productItem.clientId);

    try {
      await mqttClient?.connect();

      final wifiIP = await _getWifiIP();
      final jsonMessage = json.encode({
        'type': 'ESP32CMD',
        'value': 'TURN_ON_MACHINE',
        'IP': wifiIP,
      });

      await _publishMqttMessage(productItem, jsonMessage);
      await _waitForMqttConfirmation(productItem, totalAmount);
    } catch (e) {
      _showErrorSnackbar('Failed to send MQTT command: $e');
    }
  }

  Future<void> _publishMqttMessage(productItem, String jsonMessage) async {
    final builder = MqttClientPayloadBuilder();
    builder.addString(jsonMessage);

    mqttClient?.publishMessage(
      productItem.topic,
      MqttQos.exactlyOnce,
      builder.payload!,
    );

    mqttClient?.subscribe(productItem.topic, MqttQos.exactlyOnce);
  }

  Future<void> _waitForMqttConfirmation(productItem, double totalAmount) async {
    const timeout = Duration(seconds: 15);
    bool receivedConfirmation = false;

    final subscription = mqttClient?.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage?>>? c) async {
      final MqttPublishMessage message = c![0].payload as MqttPublishMessage;
      final payloadString =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);

      final response = json.decode(payloadString);
      if (response['type'] == 'VERIFY' && response['value'] == 'SUCCESS') {
        receivedConfirmation = true;
        await deductUserPoints(totalAmount);
        Get.off(() => SuccessScreen(
              image: TImages.successfullyRegisterAnimation,
              title: 'Payment was successful.',
              subtitle: 'If the Washer does not work, please contact support.',
              onPressed: () => Get.offAllNamed(AppScreens.navigationMenu),
            ));
      }
    });

    await Future.any([
      Future.delayed(timeout, () {
        if (!receivedConfirmation) {
          subscription?.cancel();
          _showErrorSnackbar('No response from the machine. Please try again.');
        }
      }),
      Future(() async {
        while (!receivedConfirmation) {
          await Future.delayed(const Duration(milliseconds: 100));
        }
      })
    ]);
  }

  Future<void> deductUserPoints(double pointsToDeduct) async {
    if (!await _checkNetworkConnection()) return;

    try {
      final updatePoint = {'Points': FieldValue.increment(-pointsToDeduct)};
      await userRepository.updateSingleFiled(updatePoint);
    } catch (e) {
      _showErrorSnackbar(e.toString());
    }
  }

  Future<bool> _checkNetworkConnection() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      _showErrorSnackbar(
          'No internet connection. Please check your connection.');
      return false;
    }
    return true;
  }

  Future<String?> _getWifiIP() async {
    final info = NetworkInfo();
    return await info.getWifiIP();
  }

  void _showErrorSnackbar(String message) {
    HelperShackBar.errorSnackBar(
      title: 'ERROR',
      message: message,
    );
  }
}
