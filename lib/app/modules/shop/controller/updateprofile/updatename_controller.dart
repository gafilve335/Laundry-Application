import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/navigation_menu.dart';

class UpdatenameController extends GetxController {
  static UpdatenameController get instance => Get.find();

  // Chang Name
  final firstName = TextEditingController();
  final lastname = TextEditingController();

  // Chang Username
  final userName = TextEditingController();

  // chang Phone
  final phone = TextEditingController();

  // Chang Email
  final email = TextEditingController();

  final profileController = ProfileController.instance;
  final userRepository = Get.put(UserRepository());

  // final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> updateUserNameFormkey = GlobalKey<FormState>();

  @override
  void onInit() {
    initializeNames();
    initializeUserName();
    initializePhone();
    initializeEmail();
    super.onInit();
  }

  Future<void> initializeNames() async {
    firstName.text = profileController.user.value.firstName;
    lastname.text = profileController.user.value.lastName;
  }

  Future<void> initializeUserName() async {
    userName.text = profileController.user.value.userName;
  }

  Future<void> initializeEmail() async {
    email.text = profileController.user.value.email;
  }

  Future<void> initializePhone() async {
    phone.text = profileController.user.value.phoneNumber;
  }

  Future<void> updateName() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (!updateUserNameFormkey.currentState!.validate()) {
        return;
      }

      Map<String, dynamic> name = {
        'FirstName': firstName.text.trim(),
        'LastName': lastname.text.trim()
      };
      await userRepository.updateSingleFiled(name);

      profileController.user.value.firstName = firstName.text.trim();
      profileController.user.value.lastName = lastname.text.trim();
      Get.offAll(() => const NavigationMenu());
      HelperShackBar.successSnackBar(
          title: 'Congratulation', message: 'Profile Record has been Updated');
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_UPDATENAME', message: e.toString());
    }
  }

  Future<void> updateUserName() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (!updateUserNameFormkey.currentState!.validate()) {
        return;
      }

      Map<String, dynamic> username = {
        'UserName': userName.text.trim(),
      };
      await userRepository.updateSingleFiled(username);

      profileController.user.value.userName = userName.text.trim();
      Get.offAll(() => const NavigationMenu());
      HelperShackBar.successSnackBar(
          title: 'Congratulation', message: 'Profile Record has been Updated');
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_UPDATEUSERNAME', message: e.toString());
    }
  }

  Future<void> updatePhone() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      if (!updateUserNameFormkey.currentState!.validate()) {
        return;
      }

      Map<String, dynamic> phoneNo = {
        'PhoneNumber': phone.text.trim(),
      };
      await userRepository.updateSingleFiled(phoneNo);

      profileController.user.value.phoneNumber = firstName.text.trim();
      Get.offAll(() => const NavigationMenu());
      HelperShackBar.successSnackBar(
          title: 'Congratulation', message: 'Profile Record has been Updated');
    } catch (e) {
      HelperShackBar.errorSnackBar(title: 'ERROR_PHONE', message: e.toString());
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }

      await AuthenticationRepository.instance.updateEmail(newEmail);
    } catch (e) {
      TLoggerHelper.error(e.toString());
      HelperShackBar.errorSnackBar(
          title: 'ERROR_UPDATEEMAIL', message: e.toString());
    }
  }
}
