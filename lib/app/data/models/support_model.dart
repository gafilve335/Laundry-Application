import 'package:cloud_firestore/cloud_firestore.dart';

class SupportModel {
  final String userId;
  final String brand;
  final String id;
  final String model;
  final String fingerprint;
  final String report;
  final DateTime reportDate;

  SupportModel({
    this.userId = '',
    required this.brand,
    required this.id,
    required this.model,
    required this.fingerprint,
    required this.report,
    required this.reportDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'brand': brand,
      'id': id,
      'model': model,
      'fingerprint': fingerprint,
      'report': report,
      'reportDate': reportDate
    };
  }

  factory SupportModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return SupportModel(
      userId: data['userId'] as String,
      brand: data['brand'] as String,
      id: data['id'] as String,
      model: data['model'] as String,
      fingerprint: data['fingerprint'] as String,
      report: data['report'] as String,
      reportDate: (data['reportDate'] as Timestamp).toDate(),
    );
  }
}
