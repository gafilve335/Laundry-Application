import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  String? id;
  String imageUrl;
  String targetScreen;
  bool active;

  BannerModel({
    this.id,
    required this.imageUrl,
    required this.targetScreen,
    required this.active,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'targetScreen': targetScreen,
      'Active': active,
    };
  }

  factory BannerModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return BannerModel(
      id: snapshot.id,
      imageUrl: data['imageUrl'] ?? '',
      targetScreen: data['targetScreen'] ?? '',
      active: data['Active'] ?? false,
    );
  }
}
