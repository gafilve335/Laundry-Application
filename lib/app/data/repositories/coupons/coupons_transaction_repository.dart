import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/coupons_transaction_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class CouponsTransactionRepository extends GetxController {
  static CouponsTransactionRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<CouponsTransactionModel>>
      fetchUserCouponsTransactionList() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID is empty or null');
      }
      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('RedeemedCoupons')
          .orderBy('redeemedDate', descending: true)
          .get();
      return result.docs
          .map((documentSnapshot) =>
              CouponsTransactionModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error fetching user CouponsTransaction: $e');
      rethrow;
    }
  }

  Future<void> save(CouponsTransactionModel transaction, String userId) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('RedeemedCoupons')
          .add(transaction.toJson());
    } catch (e) {
      throw 'something went wrong while saveing Order Infomation. Try again later';
    }
  }
}
