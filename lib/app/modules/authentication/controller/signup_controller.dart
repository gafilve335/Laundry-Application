import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // --Checkbox showPassword & privacyPolicy
  final showPassword = false.obs; //ตัวแปรสังเกตุ การแสดงรหัสผ่าน
  final privacyPolicy = true.obs; //ตัวแปรสังเกตุ การยอมรับข้อตกลงการใช้บริการ

  // --Text Filed Controller
  final email = TextEditingController(); // ตัวแปรเก็บข้อมูลอีเมล์
  final firstName = TextEditingController(); // ตัวแปรเก็บข้อมูลชื่อ
  final lastname = TextEditingController(); // ตัวแปรเก็บข้อมูลนามสกุล
  final username = TextEditingController(); // ตัวแปรเก็บข้อมูลยูเซอร์เนม
  final password = TextEditingController(); // ตัวแปรเก็บข้อมูลรหัสผ่าน
  final phoneNumber =
      TextEditingController(); // ตัวแปรเก็บข้อมูลหมายเลขโทรศัพท์

  // -- //Form key for fome variable
  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  Future<void> signup() async {
    try {
      debugPrint("Sign Up Process");

      // ตรวจสอบการเชื่อมต่อ
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        HelperShackBar.errorSnackBar(
            title: 'No Connection',
            message: 'Please check your internet connection.');
        return;
      }

      // ตรวจสอบคีย์
      if (!signupFormKey.currentState!.validate()) {
        return;
      }

      // ตรวจสอบการยอมรับข้อตกลงการใช้บริการ
      if (!privacyPolicy.value) {
        HelperShackBar.warningSnackBar(
            title: 'Accept Privacy Policy',
            message:
                'To create an account, you must read and accept the Privacy Policy & Terms of Use');
        return;
      }

      // เรียกใช้อินสแตนซ์ AuthenticationRepository เพื่อสร้างบัญชี
      final userCredential = await AuthenticationRepository.instance
          .registerWithEmailAndPassword(
              email.text.trim(), password.text.trim());

      // แทนค่าข้อมูลลง UserModel
      final newUser = UserModel(
        id: userCredential.user!.uid,
        firstName: firstName.text.trim(),
        lastName: lastname.text.trim(),
        userName: username.text.trim(),
        email: email.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        role: AppRole.user,
        createdAt: DateTime.now(),
        profilePicture: '',
      );

      // สร้างอินสแตนซ์ UserRepository
      final userRepository = Get.put(UserRepository());
      // เรียกใช้อินสแตนซ์ saveUserRecord เพื่อบันทึกข้อมูล
      await userRepository.saveUserRecord(newUser);

      debugPrint("Navigating to MailverificationView");
      // นำทางไปที่หน้ายืนยันอีเมล
      Get.offAllNamed(AppScreens.mailVerification);

      // แสดง SnackBar ว่าสร้างบัญชีสำเร็จ
      HelperShackBar.successSnackBar(
          title: 'Congratulations',
          message: 'Your account has been created! Verify email to continue.');
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_SIGNUP', message: e.toString());
      TLoggerHelper.error("$e");
    }
  }
}
