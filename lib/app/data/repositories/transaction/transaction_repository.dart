import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:laundry_mobile/app/data/models/transaction_model.dart';
import 'package:laundry_mobile/app/data/repositories/authentication/authentication_repository.dart';
import 'package:laundry_mobile/app/utils/log/logger.dart';

class TransactionRepository extends GetxController {
  static TransactionRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<OrderTransactionModel>> fetchUserTransactionList() async {
    try {
      final userId = AuthenticationRepository.instance.authUser?.uid;
      if (userId == null || userId.isEmpty) {
        throw Exception('User ID is empty or null');
      }
      final result = await _db
          .collection('Users')
          .doc(userId)
          .collection('Transaction')
          .orderBy('transactionDate', descending: true)
          .get();
      return result.docs
          .map((documentSnapshot) =>
              OrderTransactionModel.fromSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      TLoggerHelper.error('Error fetching user orders: $e');
      rethrow;
    }
  }

  Future<void> save(OrderTransactionModel transaction, String userId) async {
    try {
      await _db
          .collection('Users')
          .doc(userId)
          .collection('Transaction')
          .add(transaction.toJson());
    } catch (e) {
      throw 'something went wrong while saveing Order Infomation. Try again later';
    }
  }
}
