import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

///เซอร์วิสของ FireStorge
class TFirebaseStorageService extends GetxController {
  static TFirebaseStorageService get instance => Get.find();

  final _firebaseStorage = FirebaseStorage.instance;

  /// อัปโหลดข้อมูลรูปภาพจาก assets ไปยัง Firebase Storage
  /// คืนค่าเป็น Uint8List ที่บรรจุข้อมูลรูปภาพ
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      // โหลดข้อมูลจาก path ที่ส่งเข้ามา
      final byteData = await rootBundle.load(path);
      //แปลงข้อมูลให้อยุ่ในรูปแบบ Uint8List และ return ออกไปประมวลผลต่อ
      final imageData = byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes);
      return imageData;
    } catch (e) {
      // แคชข้อผิดพลาด
      throw 'Error loading image data: $e';
    }
  }

  /// อัปโหลดข้อมูลรูปภาพ ไปยัง Firebase Storage
  /// return เป็น Url ของรูปภาพที่อัพโหลด
  Future<String> uploadImageData(
      String path, Uint8List image, String name) async {
    try {
      final ref = _firebaseStorage.ref(path).child(name);
      await ref.putData(image);
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Handle exceptions gracefully
      if (e is FirebaseException) {
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Platform Exception: ${e.message}';
      } else {
        throw 'Something went wrong! Please try again.';
      }
    }
  }

  /// Uploads image file to Firebase Storage
  /// Returns the download URL of the uploaded image.
  Future<String> uploadImageFile(String path, XFile image) async {
    try {
      final ref = _firebaseStorage.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } catch (e) {
      // Handle exceptions gracefully
      if (e is FirebaseException) {
        throw 'Firebase Exception: ${e.message}';
      } else if (e is SocketException) {
        throw 'Network Error: ${e.message}';
      } else if (e is PlatformException) {
        throw 'Platform Exception: ${e.message}';
      } else {
        throw 'Something went wrong! Please try again.';
      }
    }
  }

  Future<void> deleteFileFromStorage(String imageUrl) async {
    try {
      Reference ref = _firebaseStorage.refFromURL(imageUrl);

      await ref.delete();

      if (kDebugMode) print('File deleted successfully.');
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        if (kDebugMode) print('The file does not exist in Firebase Storage.');
      } else {
        throw e.message!;
      }
    } on SocketException catch (e) {
      throw e.message;
    } on PlatformException catch (e) {
      throw e.message!;
    } catch (e) {
      throw e.toString();
    }
  }
}
