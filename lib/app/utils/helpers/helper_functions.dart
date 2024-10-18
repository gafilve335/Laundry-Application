import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:laundry_mobile/app/data/services/mqtt_service.dart'
    as mqtt_service;
import 'package:laundry_mobile/app/utils/constants/colors.dart';

class THelperFunctions {
  static String getPayloadText(mqtt_service.ConnectionState state) {
    switch (state) {
      case mqtt_service.ConnectionState.connected:
        return 'Connected'.toUpperCase();
      case mqtt_service.ConnectionState.disconnected:
        return 'Disconnected'.toUpperCase();
      case mqtt_service.ConnectionState.connectionFailed:
        return 'Connection failed'.toUpperCase();
      case mqtt_service.ConnectionState.initialized:
        return 'Initialized'.toUpperCase();
      case mqtt_service.ConnectionState.reconnectionFailed:
        return 'Reconnection failed'.toUpperCase();
      case mqtt_service.ConnectionState.payloadAvailable:
        return 'Payload available'.toUpperCase();
      case mqtt_service.ConnectionState.occupied:
        return 'Occupied'.toUpperCase();
      case mqtt_service.ConnectionState.vacant:
        return 'Vacant'.toUpperCase();
      default:
        return 'Unknown'.toUpperCase();
    }
  }

  static Color getPayloadColor(mqtt_service.ConnectionState state) {
    switch (state) {
      case mqtt_service.ConnectionState.connected:
        return TColors.info;
      case mqtt_service.ConnectionState.disconnected:
        return TColors.error;
      case mqtt_service.ConnectionState.connectionFailed:
        return TColors.error;
      case mqtt_service.ConnectionState.initialized:
        return TColors.info;
      case mqtt_service.ConnectionState.reconnectionFailed:
        return TColors.error;
      case mqtt_service.ConnectionState.payloadAvailable:
        return TColors.info;
      case mqtt_service.ConnectionState.occupied:
        return TColors.warning;
      case mqtt_service.ConnectionState.vacant:
        return TColors.success;
      default:
        return TColors.info;
    }
  }

  static Color? getColor(String value) {
    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static double screenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static double screenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static String getFormattedDate(DateTime date,
      {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static String getFormattedTransaction(DateTime date,
      {String format = 'dd MMM yyyy HH:mm'}) {
    return DateFormat(format).format(date);
  }
}
