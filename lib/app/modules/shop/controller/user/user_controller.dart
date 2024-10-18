import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/user_model.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/constants/enums.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  RxBool loading = false.obs;
  final userType = Rx<AppRole?>(null);
  final RxList<UserModel> users = <UserModel>[].obs;
  final UserRepository userRepository = Get.put(UserRepository());

  // Text editing controllers for input fields
  final TextEditingController fullName = TextEditingController();
  final TextEditingController userName = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController points = TextEditingController();
  final TextEditingController addPoints = TextEditingController();
  final GlobalKey<FormState> updateAdminUserProfile = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAllUsers();
  }

  // Initialize data in form fields when editing user data
  void init(UserModel user) {
    fullName.text = user.fullName;
    userName.text = user.userName;
    phoneNumber.text = user.phoneNumber;
    points.text = user.points.toString();
    userType.value = user.role;
  }

  // Function to add points to a user for the current session
  Future<void> addUserPoints(double pointsToAdd) async {
    if (!await _checkNetworkConnection()) return;

    try {
      await _updatePoints(pointsToAdd);
      await ProfileController.instance.fetcUserRecode();
      HelperShackBar.successSnackBar(
          title: "UPDATE", message: "Points added successfully.");
    } catch (e) {
      _handleError(e, 'ERROR_ADDPOINT_ORCODE');
    }
  }

  // Function to allow admin to add points to a specific user
  Future<void> adminAddUserPoints(double pointsToAdd, String userID) async {
    if (!await _checkNetworkConnection()) return;

    try {
      await userRepository.updateAdminSingleFiled(userID, {
        'Points': FieldValue.increment(pointsToAdd),
      });
      await fetchAllUsers();
      HelperShackBar.successSnackBar(
        title: "UPDATE",
        message: "Points updated successfully.",
      );
    } catch (e) {
      _handleError(e, 'ERROR_ADDPOINT_ORCODE');
    }
  }

  // Fetch all users for the admin panel
  Future<void> fetchAllUsers() async {
    loading.value = true;
    try {
      final usersList = await userRepository.getAllUsers();
      users.assignAll(usersList);
    } catch (e) {
      HelperShackBar.errorSnackBar(
        title: 'Something went wrong.',
        message: e.toString(),
      );
    } finally {
      loading.value = false;
    }
  }

  // Update user details (admin panel)
  Future<void> updateUserAdmin(UserModel user) async {
    if (!await _checkNetworkConnection()) return;

    if (_hasUserDataChanged(user)) {
      try {
        TFullScreenLoader.popUpCircular(); // Show loader

        await _updateUserDetails(user);
        await ProfileController.instance.fetcUserRecode();

        HelperShackBar.successSnackBar(title: "Update User Form Success");
      } catch (e) {
        _handleError(e, 'Error updating user');
      } finally {
        TFullScreenLoader.stopLoading(); // Stop loader
      }
    }
  }

  // Check if the network connection is available
  Future<bool> _checkNetworkConnection() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      HelperShackBar.errorSnackBar(
        title: 'Network Error',
        message: 'No internet connection.',
      );
    }
    return isConnected;
  }

  // Check if the user data has changed
  bool _hasUserDataChanged(UserModel user) {
    return user.userName != userName.text.trim() ||
        user.role != userType.value ||
        user.phoneNumber != phoneNumber.text.trim() ||
        (double.tryParse(points.text) != null &&
            user.points != double.parse(points.text.trim()));
  }

  // Update user points
  Future<void> _updatePoints(double pointsToAdd) async {
    await userRepository.updateSingleFiled({
      'Points': FieldValue.increment(pointsToAdd),
    });
  }

  // Update user details in Firestore
  Future<void> _updateUserDetails(UserModel user) async {
    user.userName = userName.text.trim();
    user.phoneNumber = phoneNumber.text.trim();
    user.role = userType.value ?? AppRole.user;
    user.points = double.tryParse(points.text.trim()) ?? 0;

    await userRepository.updateUserDetails(user);
  }

  // Handle errors and log them
  void _handleError(dynamic e, String errorTitle) {
    TLoggerHelper.error(e.toString());
    HelperShackBar.errorSnackBar(
      title: errorTitle,
      message: e.toString(),
    );
  }
}
