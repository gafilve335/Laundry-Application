import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:laundry_mobile/app/utils/helpers/helper_functions.dart';

class CouponsModel {
  final String userId;
  bool active;
  final String code;
  int points;
  final DateTime couponsDate;

  CouponsModel({
    required this.userId,
    required this.active,
    required this.code,
    required this.points,
    required this.couponsDate,
  });

  String get formattedCouponsDate =>
      THelperFunctions.getFormattedDate(couponsDate);

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'code': code,
      'points': points,
      'couponsDate': Timestamp.fromDate(couponsDate),
      'active': active
    };
  }

  factory CouponsModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return CouponsModel(
      userId: data['userId'] as String,
      active: data['active'] as bool,
      code: data['code'] as String,
      points: data['points'] as int,
      couponsDate: (data['couponsDate'] as Timestamp).toDate(),
    );
  }

  factory CouponsModel.fromJson(Map<String, dynamic> json) {
    DateTime couponsDate;
    if (json['couponsDate'] is String) {
      couponsDate = DateTime.parse(json['couponsDate']);
    } else if (json['couponsDate'] is Timestamp) {
      couponsDate = (json['couponsDate'] as Timestamp).toDate();
    } else {
      throw ArgumentError('Invalid format for couponsDate');
    }

    return CouponsModel(
      userId: json['userId'] as String,
      active: json['active'] as bool,
      code: json['code'] as String,
      points: json['points'] as int,
      couponsDate: couponsDate,
    );
  }
}
