import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/coupons_model.dart';
import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class CouponsRepository extends GetxController {
  final _db = FirebaseFirestore.instance;

  Future<CouponsModel?> getCouponDataByCode(String couponCode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> couponQuery = await _db
          .collection('Coupons')
          .where('code', isEqualTo: couponCode)
          .get();

      if (couponQuery.docs.isNotEmpty) {
        return CouponsModel.fromJson(couponQuery.docs.first.data());
      } else {
        HelperShackBar.errorSnackBar(
            title: 'ERROR_PROCESS_COUPONS',
            message: 'This coupon code does not exist.');
        TLoggerHelper.error('Coupon with code $couponCode not found.');
        return null;
      }
    } catch (e) {
      throw Exception('Error getting coupon data: $e');
    }
  }

  Future<bool> doesCouponExist(String couponCode) async {
    try {
      QuerySnapshot<Map<String, dynamic>> couponQuery = await _db
          .collection('Coupons')
          .where('code', isEqualTo: couponCode)
          .get();

      return couponQuery.docs.isNotEmpty;
    } catch (e) {
      TLoggerHelper.error('Error checking if coupon exists: $e');
      throw Exception('Error checking coupon existence: $e');
    }
  }

  Future<bool> updateCouponStatus(String couponCode, bool isActive) async {
    try {
      // ค้นหาเอกสารคูปองที่ตรงกับ couponCode
      final couponQuery = await _db
          .collection('Coupons')
          .where('code', isEqualTo: couponCode)
          .limit(1)
          .get();

      if (couponQuery.docs.isNotEmpty) {
        final docId = couponQuery.docs.first.id;
        await _db.collection('Coupons').doc(docId).update({'active': isActive});
        return true; // การอัปเดตสำเร็จ
      } else {
        return false; // ไม่พบเอกสารคูปองที่ตรงกับ couponCode
      }
    } catch (e) {
      throw Exception('Error updating coupon status: $e');
    }
  }

  Future<void> createCoupons(CouponsModel coupons, String userId) async {
    try {
      await _db.collection('Coupons').add(coupons.toJson());
    } catch (e) {
      throw 'something went wrong while saveing Order Infomation. Try again later';
    }
  }
}
