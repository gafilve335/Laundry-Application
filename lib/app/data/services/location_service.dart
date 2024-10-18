import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationService extends GetxService {
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // ตรวจสอบว่า Location Services ถูกเปิดใช้งานหรือไม่
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
          'ERROR_NETWORK_LOCATION :: Location services are disabled.');
    }

    // ตรวจสอบและขออนุญาตการใช้ Location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
            'ERROR_NETWORK_LOCATION :: Location permissions are denied.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'ERROR_NETWORK_LOCATION :: Location permissions are permanently denied, we cannot request permissions.');
    }
    // ดึงตำแหน่งปัจจุบัน
    return await getCurrentLocation();
  }

  Future<Position> getCurrentLocation() async {
    try {
      return await Geolocator.getCurrentPosition();
    } catch (e) {
      debugPrint('Error fetching location: $e');
      throw Exception('ERROR_NETWORK_LOCATION :: fetching location $e');
    }
  }
}

class DistanceCalculatorService extends GetxService {
  final double destinationLat;
  final double destinationLon;

  DistanceCalculatorService(this.destinationLat, this.destinationLon);

  Future<double> calculateDistance() async {
    try {
      // ดึงตำแหน่งปัจจุบันจาก LocationService
      Position currentPosition = await LocationService().determinePosition();

      // คำนวณระยะทางระหว่างตำแหน่งปัจจุบันกับจุดหมาย
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        destinationLat,
        destinationLon,
      );

      return distance / 1000.0; // แปลงจากเมตรเป็นกิโลเมตร
    } catch (e) {
      debugPrint('Error calculating distance: $e');
      throw Exception('ERROR_NETWORK_LOCATION :: calculating distance $e');
    }
  }
}
