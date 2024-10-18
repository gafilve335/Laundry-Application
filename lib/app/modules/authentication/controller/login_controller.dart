import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/constants/image_strings.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class LoginController extends GetxController {
// --Variables
  final rememberMe = false.obs; //ตัวแปรสังเกตุ การจดจำบัญชี
  final showPassword = true.obs; // ตัวแปรสังเกตุ การแสดงรหัสผ่าน
  final localStorage = GetStorage(); //ตัวแปรการเก็บข้อมูลแบบ Local

  final email = TextEditingController(); //ตัวแปรเก็บข้อมูลอีเมล์
  final password = TextEditingController(); //ตัวแปรเก็บข้อมูลรหัสผ่าน

  GlobalKey<FormState> loginFormkey = GlobalKey<FormState>(); //คีย์ฟอร์มล็อคอิน
  final profileController =
      Get.put(ProfileController()); //สร้างอินสแตนซ์ของ ProfileController

  @override
  void onInit() {
    //อ่านข้อมูล Email ที่เก็บไว้ใน Local Storage Key "REMEMBER_ME_EMAIL"
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? '';
    //อ่านข้อมูล Paswword ที่เก็บไว้ใน Local Storage Key "REMEMBER_ME_PASSWORD"
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? '';
    super.onInit();
  }

  // ล็อคอินด้วยอีเมล์และรหัสผ่าน
  Future<void> login() async {
    try {
      // แสดง Loading
      TFullScreenLoader.openLoadingDialog(
          'We aer processing your information...', TImages.docerAnimation);

      // เรียกใช้อินสแตนซ์ของ NetworkManager
      final isConnected = await NetworkManager.instance.isConnected();

      // ตรวจสอบการเชื่อมต่อ
      if (!isConnected) {
        //เมื่อเชื่อมต่อไม่สำเร็จให้ปิด Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      // ตรวจสอบคีย์ว่าตรงหรือไม่
      if (!loginFormkey.currentState!.validate()) {
        //ถ้าคีย์ไม่ตรงให้ปิด Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      // ตรวจสอบ rememberMe true or false
      if (rememberMe.value) {
        //ถ้าค่าเป็น true ให้เขียนข้อมูลลง Localstorage ตาม key ที่กำหนดไว้
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }
      //เรียกใช้อินสแตนซ์ของ AuthenticationRepository send email && password เพื่อทำการ Login
      await AuthenticationRepository.instance
          .loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      // ปิด Loading
      TFullScreenLoader.stopLoading();

      //Redirect Screen
      AuthenticationRepository.instance.screenRedirect();

      //หากเกิดข้อผิดพลาดให้แคชข้อผิดพลาดออกมา
    } catch (e) {
      //ปิดLoading
      TFullScreenLoader.stopLoading();

      //โชว์ข้อผิดพลาดบนหน้าจอผู้ใช้งาน
      HelperShackBar.errorSnackBar(
          title: 'ERROR_LOGIN_EMAIL_AND_PASSWORD', message: e.toString());
      TLoggerHelper.error("$e");
    }
  }

  // ล็อคอินด้วย Google
  Future<void> googleSignIn() async {
    try {
      // แสดง Loading
      TFullScreenLoader.openLoadingDialog(
          'Logging your in...', TImages.docerAnimation);

      // เรียกใช้อินสแตนซ์ของ NetworkManager
      final isConnected = await NetworkManager.instance.isConnected();

      if (!isConnected) {
        //เมื่อเชื่อมต่อไม่สำเร็จให้ปิด Loading
        TFullScreenLoader.stopLoading();
        return;
      }

      // เรียกใช้อินสแตนซ์ Google Signin Authentication
      final userCredentials =
          await AuthenticationRepository.instance.signInWithGoogle();

      // บันทึกข้อมูลผู้ใช้งานลง Firebase
      await profileController.saveUserRecord(userCredentials);

      // ปิด Loading
      TFullScreenLoader.stopLoading();

      //Redirect Screen
      AuthenticationRepository.instance.screenRedirect();

      //หากเกิดข้อผิดพลาดให้แคชข้อผิดพลาดออกมา
    } catch (e) {
      //ปิด Loading
      TFullScreenLoader.stopLoading();
      //โชว์ข้อผิดพลาดบนหน้าจอผู้ใช้งาน
      HelperShackBar.errorSnackBar(
          title: 'ERROR_GOOGLESIGIN_LOGIN', message: e.toString());
    }
  }
}
