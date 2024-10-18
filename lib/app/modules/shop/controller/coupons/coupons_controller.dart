import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/coupons_model.dart';
import 'package:laundry_mobile/app/data/models/coupons_transaction_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/data/repositories/coupons/coupons_repository.dart';
import 'package:laundry_mobile/app/data/repositories/coupons/coupons_transaction_repository.dart';
import 'package:laundry_mobile/app/data/repositories/user/user_repository.dart';
import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';
import 'package:laundry_mobile/app/utils/helpers/network_manager.dart';
import 'package:laundry_mobile/app/utils/popup/full_screen_loader.dart';

class CouponsController extends GetxController {
  static CouponsController get instance => Get.find<CouponsController>();
  final isLoading = false.obs;

  // Text controllers for input fields
  final TextEditingController coupons = TextEditingController();
  final TextEditingController couponsCreate = TextEditingController();
  final TextEditingController points = TextEditingController();

  //
  // Text controllers for input fields Muticoupons
  final TextEditingController couponCountController = TextEditingController();
  final TextEditingController mutipoints = TextEditingController();

  // Repositories
  final UserRepository userRepository = Get.put(UserRepository());
  final CouponsRepository couponsRepository = Get.put(CouponsRepository());
  final CouponsTransactionRepository couponsTransactionRepo =
      Get.put(CouponsTransactionRepository());

  // List to store coupon transactions
  final RxList<CouponsTransactionModel> couponsTransaction =
      <CouponsTransactionModel>[].obs;

  @override
  void onInit() {
    fetchUserCouponsTransaction();
    super.onInit();
  }

  void generateRandomCouponCode() {
    const length = 14;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    String randomCode =
        List.generate(length, (index) => chars[random.nextInt(chars.length)])
            .join();
    couponsCreate.text = randomCode;
  }

  Future<void> addUserPoints(int pointsToAdd) async {
    if (pointsToAdd <= 0) return; // Validate points

    try {
      if (!await _checkNetworkConnection()) return;

      final Map<String, dynamic> updatePoint = {
        'Points': FieldValue.increment(pointsToAdd),
      };

      await userRepository.updateSingleFiled(updatePoint);
      HelperShackBar.successSnackBar(
        title: 'Success',
        message: 'Points added successfully.',
      );
    } catch (e) {
      _handleError('Error adding points', e);
    }
  }

  Future<List<CouponsTransactionModel>> fetchUserCouponsTransaction() async {
    try {
      isLoading.value = true;
      final userCouponsTransaction =
          await couponsTransactionRepo.fetchUserCouponsTransactionList();
      couponsTransaction.assignAll(userCouponsTransaction);
      return userCouponsTransaction;
    } catch (e) {
      _handleError('Failed to fetch coupon transactions', e);
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> processCreateCoupons() async {
    final String? userid = await _getCurrentUserId();
    if (userid == null) return;

    if (!_validateInput(couponsCreate.text, points.text)) return;

    try {
      TFullScreenLoader.popUpCircular(); // Show Loader

      final int parsedPoints = int.tryParse(points.text.trim()) ?? 0;
      if (parsedPoints <= 0) {
        _showErrorSnackBar('Points should be a positive integer.');
        return;
      }

      if (await couponsRepository.doesCouponExist(couponsCreate.text.trim())) {
        _showErrorSnackBar('Coupon with this code already exists.');
        return;
      }

      final createCoupons = CouponsModel(
        userId: userid,
        active: true,
        code: couponsCreate.text.trim(),
        points: parsedPoints,
        couponsDate: DateTime.now(),
      );

      await couponsRepository.createCoupons(createCoupons, userid);
      HelperShackBar.successSnackBar(
        title: 'Successful',
        message: 'Coupon created successfully.',
      );
    } catch (e) {
      _handleError('Error creating coupons', e);
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  // เพิ่มฟังก์ชันสำหรับสร้างคูปองหลายใบ
  Future<void> createMultipleCoupons(int count, int pointsPerCoupon) async {
    final String? userid = await _getCurrentUserId();
    if (userid == null) return;

    try {
      TFullScreenLoader.popUpCircular(); // Show Loader

      List<CouponsModel> couponsList = [];

      for (int i = 0; i < count; i++) {
        String couponCode = _generateRandomCode();

        // ตรวจสอบว่ามีคูปองนี้อยู่ในระบบหรือไม่
        final couponExists =
            await couponsRepository.doesCouponExist(couponCode);
        if (couponExists) {
          i--; // หากคูปองซ้ำให้ลองสร้างใหม่
          continue;
        }

        // สร้างโมเดลคูปองใหม่
        final createCoupons = CouponsModel(
          userId: userid,
          active: true,
          code: couponCode,
          points: pointsPerCoupon,
          couponsDate: DateTime.now(),
        );

        couponsList.add(createCoupons); // เก็บคูปองที่สร้างลงใน List
      }

      // บันทึกคูปองทั้งหมดใน Firestore
      for (var coupon in couponsList) {
        await couponsRepository.createCoupons(coupon, userid);
      }

      HelperShackBar.successSnackBar(
        title: 'Successful',
        message: '$count coupons created successfully.',
      );
    } catch (e) {
      _handleError('Error creating multiple coupons', e);
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  Future<void> processCoupons(String couponCode) async {
    if (couponCode.trim().isEmpty) {
      _showErrorSnackBar('Coupon code cannot be empty.');
      return;
    }

    try {
      TFullScreenLoader.popUpCircular(); // Show Loader

      final String? userid = await _getCurrentUserId();
      if (userid == null) return;

      final CouponsModel? coupons =
          await couponsRepository.getCouponDataByCode(couponCode);

      if (coupons == null) {
        _showErrorSnackBar('Coupon not found.');
        return;
      }

      if (!coupons.active) {
        _showErrorSnackBar('This coupon has already been used.');
        return;
      }

      await addUserPoints(coupons.points);

      final transaction = CouponsTransactionModel(
        userId: userid,
        code: coupons.code,
        points: coupons.points,
        redeemedDate: DateTime.now(),
      );

      await couponsTransactionRepo.save(transaction, userid);

      if (!await couponsRepository.updateCouponStatus(couponCode, false)) {
        _showErrorSnackBar('Failed to update coupon status. Please try again.');
        return;
      }

      await fetchUserCouponsTransaction();
      await ProfileController.instance.fetcUserRecode();

      HelperShackBar.successSnackBar(
        title: 'Successful',
        message: 'Point replenishment successful.',
      );
    } catch (e) {
      _handleError('Error processing coupon', e);
    } finally {
      TFullScreenLoader.stopLoading();
    }
  }

  // ฟังก์ชันสร้างโค้ดคูปองแบบสุ่ม
  String _generateRandomCode() {
    const length = 14;
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();
    return List.generate(length, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  Future<bool> _checkNetworkConnection() async {
    final isConnected = await NetworkManager.instance.isConnected();
    if (!isConnected) {
      _showErrorSnackBar('Please check your internet connection.');
    }
    return isConnected;
  }

  bool _validateInput(String couponCode, String pointsText) {
    if (couponCode.trim().isEmpty || pointsText.trim().isEmpty) {
      _showErrorSnackBar('Coupon code and points cannot be empty.');
      return false;
    }
    return true;
  }

  Future<String?> _getCurrentUserId() async {
    final userid = AuthenticationRepository.instance.authUser?.uid;
    if (userid == null || userid.isEmpty) {
      _showErrorSnackBar('User ID is not available. Please log in again.');
      return null;
    }
    return userid;
  }

  void _handleError(String message, dynamic error) {
    HelperShackBar.errorSnackBar(
      title: message,
      message: error.toString(),
    );
    TLoggerHelper.error('$message: $error');
  }

  void _showErrorSnackBar(String message) {
    HelperShackBar.errorSnackBar(
      title: 'Input Error',
      message: message,
    );
  }
}
