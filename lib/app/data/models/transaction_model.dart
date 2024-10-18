import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class OrderTransactionModel {
  final String name;
  final String userId;
  final double price;
  final String transactionType;
  final DateTime transactionDate;

  OrderTransactionModel({
    required this.name,
    this.userId = '',
    required this.price,
    required this.transactionType,
    required this.transactionDate,
  });

  String get formattedOrderDate =>
      THelperFunctions.getFormattedTransaction(transactionDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'price': price,
      'transactionType': transactionType,
      'transactionDate': transactionDate,
    };
  }

  factory OrderTransactionModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderTransactionModel(
      name: data['name'] ?? '',
      price: (data['price'] ?? ''),
      transactionDate: (data['transactionDate'] as Timestamp).toDate(),
      transactionType: data['transactionType'] as String,
    );
  }
}
