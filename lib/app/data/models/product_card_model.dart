import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class ProductCardModel {
  String? id;
  String name;
  double price;
  double discount;
  String imageUrl;
  String branch;
  String serverUri;
  String clientId;
  String topic;
  String targetScreen;
  MqttServerClient mqttClient;
  bool active;
  WasherMode mode;
  CustomMqttQos qos;
  bool buzzer;
  int ldr;

  ProductCardModel({
    this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.imageUrl,
    required this.branch,
    required this.targetScreen,
    required this.clientId,
    required this.serverUri,
    required this.topic,
    required this.active,
    required this.mode,
    required this.qos,
    required this.buzzer,
    required this.ldr,
  }) : mqttClient = MqttServerClient(serverUri, clientId) {
    mqttClient.logging(on: false);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'discount': discount,
      'imageUrl': imageUrl,
      'branch': branch,
      'targetScreen': targetScreen,
      'Active': active,
      'clientId': clientId,
      'serverUri': serverUri,
      'topic': topic,
      'mode': mode.index, // Save the enum index for storage
      'qos': qos.index,
      'buzzer': buzzer,
      'ldr': ldr,
    };
  }

  factory ProductCardModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return ProductCardModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      price: double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
      discount: double.tryParse(data['discount']?.toString() ?? '0.0') ?? 0.0,
      imageUrl: data['imageUrl'] ?? '',
      branch: data['branch'] ?? '',
      targetScreen: data['targetScreen'] ?? '',
      clientId: data['clientId'] ?? '',
      serverUri: data['serverUri'] ?? '',
      topic: data['topic'] ?? '',
      active: data['Active'] ?? false,
      mode: WasherMode.values[data['mode'] ?? 0],
      qos: CustomMqttQos.values[data['qos'] ?? 0],
      buzzer: data['buzzer'] ?? false,
      ldr: data['ldr'] ?? 500,
    );
  }
}
