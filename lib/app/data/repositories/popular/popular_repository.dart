import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/laundry_popular_model.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_exceptions.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_platform_exception.dart';
import 'package:laundry_mobile/app/utils/exceptions/format_exceptions.dart';

class PopularRepository extends GetxController {
  static PopularRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<LaundryPopularModel>> fecthLaundryPopula() async {
    try {
      final result = await _db
          .collection('Popular')
          .where('Active', isEqualTo: true)
          .get();
      return result.docs
          .map((documentSnapshot) =>
              LaundryPopularModel.fromSnapshot(documentSnapshot))
          .toList();
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again ';
    }
  }

  // Get all banners from Firestore
  Future<List<LaundryPopularModel>> getAllPopular() async {
    try {
      final snapshot = await _db.collection("Popular").get();
      final result = snapshot.docs
          .map((e) => LaundryPopularModel.fromSnapshot(e))
          .toList();
      return result;
    } on FirebaseException catch (e) {
      throw e.message!;
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw 'Something Went Wrong! Please try again.';
    }
  }

  // Create a new banner in Firestore
  Future<String> createBanner(LaundryPopularModel banner) async {
    try {
      final result = await _db.collection("Popular").add(banner.toJson());
      return result.id;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updatePopular(LaundryPopularModel popular) async {
    try {
      await _db.collection("Popular").doc(popular.id).update(popular.toJson());
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Delete a popular from Firestore
  Future<void> deletePopular(String popularId) async {
    try {
      // Delete the banner with the specified ID from Firestore
      await _db.collection("Popular").doc(popularId).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
