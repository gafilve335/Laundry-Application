import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class CouponsTransactionModel {
  final String userId;
  final String code;
  int points;
  final DateTime redeemedDate;

  CouponsTransactionModel({
    required this.userId,
    required this.code,
    required this.points,
    required this.redeemedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'code': code,
      'points': points,
      'redeemedDate': redeemedDate,
    };
  }

  String get formattedRedeemedDate =>
      THelperFunctions.getFormattedTransaction(redeemedDate);

  factory CouponsTransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CouponsTransactionModel(
      userId: data['userId'] as String,
      code: data['code'] as String,
      points: (data['points'] as int),
      redeemedDate: (data['redeemedDate'] as Timestamp).toDate(),
    );
  }
}
