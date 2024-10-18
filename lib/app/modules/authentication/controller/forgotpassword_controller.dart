import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/modules/authentication/view/fogotpassword/widgets/forgotpassword_done.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

//ลืมรหัสผ่าน
class ForgotpasswordController extends GetxController {
  final email = TextEditingController(); //ตัวแปรเก็บข้อมูลอีเมล์
  //คีย์ฟอร์มลืมรหัสผ่าน
  GlobalKey<FormState> resetpasswordFormKey = GlobalKey<FormState>();

  // ลืมรหัสผ่าน
  sendPasswordResetEmail() async {
    try {
      // แสดง Loading
      TFullScreenLoader.openLoadingDialog(
          'Processing your request...', TImages.docerAnimation);

      //เรียกใช้อินสแตนซ์ NetworkManager
      final isConnected = await NetworkManager.instance.isConnected();

      //ตรวจสอบการเชื่อมต่อ
      if (!isConnected) {
        //เมื่อเชื่อมต่อไม่สำเร็จ
        //ปิด Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      //ตรวจสอบข้อมูล
      if (!resetpasswordFormKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //เรียกใช้อินสแตนซ์ AuthenticationRepository เพื่อส่งอีมเล์รีเซตรหัสผ่านตามที่ผู้ใช้กำหนด
      await AuthenticationRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //ปิด Loading
      TFullScreenLoader.stopLoading();

      //แสดง SnackBar ว่าส่งอีเมลืสำเร็จ
      HelperShackBar.successSnackBar(
          title: 'FORGOTPASSWORD_EMAIL_SEND',
          message: 'Email Link Sent to Reset your password'.tr);

      //Redirect
      Get.to(() => const ForgorPasswordDone());
    } catch (e) {
      //หากมีข้อผิดพลาดให้แคชออกมาแสดงบนหน้าจอผู้ใช้งาน
      HelperShackBar.errorSnackBar(title: 'tOhSnap', message: e.toString());
    }
  }
}
