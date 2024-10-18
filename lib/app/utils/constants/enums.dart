import 'package:mqtt_client/mqtt_client.dart';

enum AppRole { admin, user }

enum WasherMode { mode1, mode2, mode3, mode4 }

enum TransactionType { buy, recharge }

enum ImageType { asset, network, memory, file }

enum CustomMqttQos {
  atMostOnce,
  atLeastOnce,
  exactlyOnce,
}

MqttQos convertToMqttQos(CustomMqttQos customQos) {
  switch (customQos) {
    case CustomMqttQos.atMostOnce:
      return MqttQos.atMostOnce;
    case CustomMqttQos.atLeastOnce:
      return MqttQos.atLeastOnce;
    case CustomMqttQos.exactlyOnce:
      return MqttQos.exactlyOnce;
    default:
      return MqttQos.atMostOnce;
  }
}

