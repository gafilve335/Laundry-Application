import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_exceptions.dart';
import 'package:laundry_mobile/app/utils/exceptions/firebase_platform_exception.dart';
import 'package:laundry_mobile/app/utils/exceptions/format_exceptions.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  ///[SaveUserRecord] --> Function to save user data to firestore
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection("Users").doc(user.id).set(user.toJson());
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

  ///[FetchUserDetails] --> Function Fetch user data details
  Future<UserModel> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
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

  Future<void> updateUserDetails(UserModel updateUser) async {
    try {
      if (updateUser.id == null) {
        throw ArgumentError('User ID cannot be null');
      }
      // TLoggerHelper.debug('Updating user with ID: ${updateUser.id}');
      // TLoggerHelper.debug('User data: ${updateUser.toJson()}');
      await _db
          .collection("Users")
          .doc(updateUser.id)
          .update(updateUser.toJson());
    } on FirebaseException catch (e) {
      TLoggerHelper.error('Firebase error: ${e.message}');
      throw 'Firebase Error: ${e.message}';
    } on FormatException catch (e) {
      TLoggerHelper.error('Format error: ${e.message}');
      throw 'Format Error: ${e.message}';
    } on PlatformException catch (e) {
      TLoggerHelper.error('Platform error: ${e.message}');
      throw 'Platform Error: ${e.message}';
    } catch (e) {
      TLoggerHelper.error('Unknown error: $e');
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<void> adminUpdateUserDetails(
      String userId, Map<String, dynamic> updates) async {
    try {
      await _db.collection("Users").doc(userId).update(updates);
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// Function to fetch user details based on user ID.
  Future<UserModel> fetchAdminDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser!.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final querySnapshot =
          await _db.collection("Users").orderBy('FirstName').get();
      return querySnapshot.docs
          .map((doc) => UserModel.fromSnapshot(doc))
          .toList();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something Went Wrong: $e');
      throw 'Something Went Wrong: $e';
    }
  }

  Future<void> updateSingleFiled(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .update(json);
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(' throw Something went wrong. Please try again $e');
      throw 'Something went wrong. Please try again $e';
    }
  }

  Future<void> updateAdminSingleFiled(
      String userID, Map<String, dynamic> json) async {
    try {
      await _db.collection("Users").doc(userID).update(json);
    } on TFirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const FormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      TLoggerHelper.error(' throw Something went wrong. Please try again $e');
      throw 'Something went wrong. Please try again $e';
    }
  }

  Future<void> removeUserRecord(String userId) async {
    try {
      QuerySnapshot orderSnapshot =
          await _db.collection('Users').doc(userId).collection('Orders').get();

      for (DocumentSnapshot doc in orderSnapshot.docs) {
        await doc.reference.delete();
      }

      await _db
          .collection('Users')
          .doc(userId)
          .collection('Orders')
          .doc('orders')
          .delete();

      await _db.collection("Users").doc(userId).delete();
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

  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
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
}
