import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/support_model.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_exceptions.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_platform_exception.dart';

class SupportRepository extends GetxController {
  final _db = FirebaseFirestore.instance;

  ///[SaveUserRecord] --> Function to save user data to firestore
  Future<void> saveReport(SupportModel support) async {
    try {
      await _db.collection("Support").add(support.toJson());
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

  /// [getReports] --> Function to fetch all support reports from Firestore
  Future<List<SupportModel>> getReports() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection("Support").get();
      return querySnapshot.docs
          .map((doc) => SupportModel.fromSnapshot(
              doc)) // Use fromSnapshot for consistency
          .toList();
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong while fetching reports. Please try again.';
    }
  }
}
