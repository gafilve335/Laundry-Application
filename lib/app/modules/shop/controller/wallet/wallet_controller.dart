// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:laundry_mobile/app/data/models/transaction_model.dart';
// import 'package:laundry_mobile/app/data/repositories/transaction/transaction_repository.dart';
// import 'package:laundry_mobile/app/utils/helpers/helpers_snackbar.dart';
// import 'package:laundry_mobile/app/utils/log/logger.dart';
// import 'package:laundry_mobile/app/modules/shop/controller/profile/profile_controller.dart';

// class WalletController extends GetxController {
//   static WalletController get instance => Get.find();
//   final RxList<OrderTransactionModel> transaction =
//       <OrderTransactionModel>[].obs;

//   final editPoint = TextEditingController();
//   final isLoading = false.obs;
//   @override
//   void onInit() {
//     fetchUserTransaction();
//     super.onInit();
//   }

//   Future<List<OrderTransactionModel>> fetchUserTransaction() async {
//     try {
//       isLoading.value = true;
//       final transactionRepo = Get.put(TransactionRepository());
//       final userTransaction = await transactionRepo.fetchUserTransactionList();

//       transaction.assignAll(userTransaction);
//       await ProfileController.instance.fetcUserRecode();
//       return userTransaction;
//     } catch (e) {
//       HelperShackBar.errorSnackBar(title: 'ERROR_TRANSACTION');
//       if (kDebugMode) {
//         TLoggerHelper.error(
//             'An error occurred while fetching data  from the database : $e');
//       }
//       return [];
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
