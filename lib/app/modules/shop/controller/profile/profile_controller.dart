import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/modules/shop/view/profile/widgets/profile_re_authenticate.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/routes/app_routes.dart';
import 'package:laundry_mobile/app/utils/constants/colors.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/constants/sizes.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormkey = GlobalKey<FormState>();
  final userRepository = Get.put(UserRepository());

  @override
  void onInit() {
    super.onInit();
    fetcUserRecode();
  }

  Future<void> fetcUserRecode() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord(UserCredential? userCredential) async {
    try {
      // Refresh User Record
      await fetcUserRecode();

      if (user.value.id!.isEmpty) {
        if (userCredential != null) {
          final nameParts =
              UserModel.nameParts(userCredential.user!.displayName ?? '');
          final username = UserModel.genarateUsername(
              userCredential.user!.displayName ?? '');

          final newUser = UserModel(
            id: userCredential.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join('') : '',
            userName: username,
            email: userCredential.user!.email ?? '',
            phoneNumber: userCredential.user!.phoneNumber ?? '',
            profilePicture: userCredential.user!.photoURL ?? '',
            role: AppRole.user,
            createdAt: DateTime.now(),
          );

          await userRepository.saveUserRecord(newUser);
        }
      }
    } catch (e) {
      HelperShackBar.errorSnackBar(
          title: 'ERROR_DATABASE_PROFILE',
          message: 'Something went wrong while saving information');
    }
  }

  void deleteAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Delete Account',
        titleStyle: const TextStyle(color: TColors.black),
        backgroundColor: TColors.white,
        middleTextStyle: const TextStyle(color: TColors.black),
        middleText:
            'Are you sure you want to delete youre account permanently? This acction is not reversible and all of your data will be removed permanently',
        confirm: ElevatedButton(
          onPressed: () async => deleteUserAccount(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text(
              'Delete',
            ),
          ),
        ),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: TColors.black),
            )));
  }

  void logoutAccountWarningPopup() {
    Get.defaultDialog(
        contentPadding: const EdgeInsets.all(TSizes.md),
        title: 'Logout',
        titleStyle: const TextStyle(color: TColors.black),
        backgroundColor: TColors.white,
        middleTextStyle: const TextStyle(color: TColors.black),
        middleText: 'Do you want to log out?',
        confirm: ElevatedButton(
          onPressed: () async => AuthenticationRepository.instance.logout(),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: TSizes.lg),
            child: Text(
              'Logout',
            ),
          ),
        ),
        cancel: OutlinedButton(
            onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: TColors.black),
            )));
  }

  void deleteUserAccount() async {
    try {
      final autn = AuthenticationRepository.instance;
      final provider =
          autn.authUser!.providerData.map((e) => e.providerId).first;
      if (provider.isNotEmpty) {
        if (provider == 'google.com') {
          await autn.signInWithGoogle();
          await autn.deleteAccount();
          Get.offNamed(AppScreens.login);
        } else if (provider == 'password') {
          Get.to(() => const ReAuthLoginForm());
        }
      }
    } catch (e) {
      HelperShackBar.warningSnackBar(
          title: 'ERROR_DATABASE_DELETE_USER_PROFILE!', message: e.toString());
    }
  }

  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        return;
      }
      if (!reAuthFormkey.currentState!.validate()) {
        return;
      }
      await AuthenticationRepository.instance.deleteAccount();
      Get.offAllNamed(AppScreens.login);
    } catch (e) {
      HelperShackBar.warningSnackBar(
          title: 'ERROR_REAUTHEN_PROFILE', message: e.toString());
    }
  }

  uploadUserProfilePicture() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxHeight: 512,
        maxWidth: 512);
    if (image != null) {
      try {
        imageUploading.value = true;
        // Upload image
        final imageUrl =
            await userRepository.uploadImage('Users/Images/Profile/', image);

        // Update user image Record
        Map<String, dynamic> json = {'ProfilePicture': imageUrl};
        await userRepository.updateSingleFiled(json);
        user.value.profilePicture = imageUrl;
        user.refresh();
        HelperShackBar.successSnackBar(
            title: 'Congratulations',
            message: 'Your Profile Image has benn updated!');
      } catch (e) {
        HelperShackBar.errorSnackBar(
            title: 'ERROR_DATABASE_UPLOADUSERPROFILE_PROFILE',
            message: 'Something went Wrong: $e');
      } finally {
        imageUploading.value = false;
      }
    }
  }
}
