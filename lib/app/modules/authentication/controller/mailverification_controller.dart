import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/common/widgets/form/success_screen.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/constants/text_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';

class MailverificationController extends GetxController {
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  // -- ส่งหรือส่งอีกครั้ง Email Verification
  sendEmailVerification() async {
    try {
      // เรียกใช้อินสแตนซ์ของ AuthenticationRepository
      await AuthenticationRepository.instance.sendEmailverification();
    } catch (e) {
      // TLoggerHelper.error(ConsoleColor.apply(
      //     ConsoleColor.green, 'Error sending verification email: $e'));
      //หากมีข้อผิดพลาดให้แคชบนหน้าจอผู้ใช้งาน
      HelperShackBar.errorSnackBar(
          title: 'ERROR_MAILVERIFY', message: e.toString());
    }
  }

  /// -- ตั้งเวลาเช็คว่าการยืนยันตัวตนเสร็จสิ้นแล้วจะ Redirect อัตโนมัติ
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      // ตั้งเวลาให้เช็คว่ายืนยันอีเมล์สำเร็จหรือไม่ ทุก 1 วินาที
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        //ถ้ายืนยันอีมเมล์สำเร็จให้ลบ Timer
        timer.cancel();
        // Get.off ปิดเฉพาะหน้านี้ และ route ไปหน้า SuccessScreen
        Get.off(() => SuccessScreen(
            image: TImages.successfullyRegisterAnimation,
            title: TTexts.yourAccountCreatedTitle,
            subtitle: TTexts.yourAccountCreatedSubTitle,
            // เมื่อกดปุ่มจะ Redirect ไปหน้าที่กำหนดไว้
            onPressed: () =>
                AuthenticationRepository.instance.screenRedirect()));
      }
    });
  }

  /// -- Manually Check if Verification Completed then Redirect
  manuallyCheckEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => SuccessScreen(
          image: TImages.successfullyRegisterAnimation,
          title: TTexts.yourAccountCreatedTitle,
          subtitle: TTexts.yourAccountCreatedSubTitle,
          onPressed: () => AuthenticationRepository.instance.screenRedirect()));
    }
  }
}
