import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class OrderModel {
  final String name;
  final String id;
  final String userId;
  final String branch;
  final double price;
  final String coupons;
  final double discount;
  final double totalAmount;
  final DateTime orderDate;
  final String paymentMethod;

  OrderModel({
    required this.name,
    required this.id,
    this.userId = '',
    required this.branch,
    required this.price,
    this.coupons = 'NOT OPEN',
    required this.discount,
    required this.totalAmount,
    required this.orderDate,
    this.paymentMethod = 'Pay with Points',
  });

  String get formattedOrderDate => THelperFunctions.getFormattedDate(orderDate);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'userId': userId,
      'branch': branch,
      'price': price,
      'coupons': coupons,
      'discount': discount,
      'totalAmount': totalAmount,
      'orderDate': orderDate,
      'paymentMethod': paymentMethod,
    };
  }

  factory OrderModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return OrderModel(
      name: data['name'] as String,
      id: data['id'] as String,
      userId: data['userId'] as String,
      branch: data['branch'] as String,
      price: data['price'] as double,
      coupons: data['coupons'] as String,
      discount: data['discount'] as double,
      totalAmount: data['totalAmount'] as double, // แก้เป็น 'totalAmount'
      orderDate: (data['orderDate'] as Timestamp).toDate(),
      paymentMethod: data['paymentMethod'] as String,
    );
  }
}
