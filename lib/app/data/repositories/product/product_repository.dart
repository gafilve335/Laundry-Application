import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/product_card_model.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_exceptions.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_platform_exception.dart';
import 'package:laundry_mobile/app/utils/exceptions/format_exceptions.dart';

class ProductCardRepository extends GetxController {
  static ProductCardRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<ProductCardModel>> fecthProductCard() async {
    try {
      final result = await _db
          .collection('Productcard')
          .where('Active', isEqualTo: true)
          .get();

      // Print data to console
      // for (var documentSnapshot in result.docs) {
      //   TLoggerHelper.debug(jsonEncode(documentSnapshot.data()));
      // }

      return result.docs
          .map((documentSnapshot) =>
              ProductCardModel.fromSnapshot(documentSnapshot))
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
  Future<List<ProductCardModel>> getAllProduct() async {
    try {
      final snapshot = await _db.collection("Productcard").get();
      final result =
          snapshot.docs.map((e) => ProductCardModel.fromSnapshot(e)).toList();
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
  Future<String> createProduct(ProductCardModel product) async {
    try {
      final result = await _db.collection("Productcard").add(product.toJson());
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

  Future<void> updateProduct(ProductCardModel popular) async {
    try {
      await _db
          .collection("Productcard")
          .doc(popular.id)
          .update(popular.toJson());
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
  Future<void> deleteProduct(String productId) async {
    try {
      // Delete the banner with the specified ID from Firestore
      await _db.collection("Productcard").doc(productId).delete();
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
