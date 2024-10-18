import 'dart:convert';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:mqtt_client/mqtt_client.dart';

enum ConnectionState {
  initialized,
  connected,
  disconnected,
  connectionFailed,
  reconnectionFailed,
  payloadAvailable,
  occupied,
  vacant,
}

class MqttService extends GetxController {
  // ฟังก์ชันสำหรับเชื่อมต่อกับ MQTT
  Future<void> connectToMQTT(
      ProductCardModel product, RxMap<String, ConnectionState> payloads) async {
    final MqttClient mqttClient = product.mqttClient;

    try {
      mqttClient.keepAlivePeriod = 60;
      await mqttClient.connect();

      // ตรวจสอบการเชื่อมต่อสำเร็จหรือไม่
      if (mqttClient.connectionStatus?.state == MqttConnectionState.connected) {
        payloads[product.topic] = ConnectionState.connected;
        await _subscribeToTopic(product, payloads);
      } else {
        _handleConnectionFailure(product, payloads);
      }
    } catch (e) {
      _handleConnectionFailure(product, payloads);
    }
  }

  // ฟังก์ชันสำหรับสมัครรับข้อมูลจาก topic
  Future<void> _subscribeToTopic(
      ProductCardModel product, RxMap<String, ConnectionState> payloads) async {
    try {
      final MqttClient mqttClient = product.mqttClient;

      mqttClient.subscribe(product.topic, MqttQos.atLeastOnce);

      mqttClient.updates
          ?.listen((List<MqttReceivedMessage<MqttMessage>> event) {
        _processMessage(event, product, payloads);
      });
    } catch (e) {
      payloads[product.topic] = ConnectionState.connectionFailed;
    }
  }

  // ฟังก์ชันสำหรับประมวลผลข้อความที่ได้รับจาก MQTT
  void _processMessage(List<MqttReceivedMessage<MqttMessage>> event,
      ProductCardModel product, RxMap<String, ConnectionState> payloads) {
    final MqttPublishMessage message = event[0].payload as MqttPublishMessage;
    final String payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);

    if (payload.isNotEmpty) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(payload);
        _updatePayloadStatus(jsonData, product, payloads);
      } catch (e) {
        payloads[product.topic] =
            ConnectionState.payloadAvailable; // จัดการกรณี payload มีปัญหา
      }
    } else {
      payloads[product.topic] = ConnectionState.payloadAvailable;
    }
  }

  // ฟังก์ชันสำหรับอัปเดตสถานะของ payload ตามข้อมูล JSON
  void _updatePayloadStatus(Map<String, dynamic> jsonData,
      ProductCardModel product, RxMap<String, ConnectionState> payloads) {
    final String type = jsonData['type'] ?? '';
    final dynamic value = jsonData['value'];

    if (type == 'WasherStatus') {
      payloads[product.topic] =
          (value == 'ON') ? ConnectionState.occupied : ConnectionState.vacant;
    } else {
      // จัดการกรณีที่มีข้อมูลประเภทอื่น
      payloads[product.topic] = ConnectionState.payloadAvailable;
    }
  }

  // ฟังก์ชันสำหรับจัดการกรณีที่การเชื่อมต่อล้มเหลว
  void _handleConnectionFailure(
      ProductCardModel product, RxMap<String, ConnectionState> payloads) {
    payloads[product.topic] = ConnectionState.connectionFailed;
    product.mqttClient.disconnect();
  }

  // ฟังก์ชันสำหรับตัดการเชื่อมต่อ
  void disconnectFromMQTT(ProductCardModel product) {
    final MqttClient mqttClient = product.mqttClient;
    if (mqttClient.connectionStatus?.state == MqttConnectionState.connected) {
      mqttClient.disconnect();
    }
  }
}
