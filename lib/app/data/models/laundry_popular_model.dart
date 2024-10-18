import 'package:cloud_firestore/cloud_firestore.dart';

class LaundryPopularModel {
  String? id;
  String name;
  String address;
  String imageUrl;
  double rating;
  double destinationLat;
  double destinationLon;
  String titleMapLauncher;
  String targetScreen;
  bool active;

  LaundryPopularModel({
    this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.rating,
    required this.targetScreen,
    required this.active,
    required this.destinationLat,
    required this.destinationLon,
    required this.titleMapLauncher,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'imageUrl': imageUrl,
      'rating': rating,
      'targetScreen': targetScreen,
      'Active': active,
      'destinationLat': destinationLat,
      'destinationLon': destinationLon,
      'titleMapLauncher': titleMapLauncher
    };
  }

  factory LaundryPopularModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    return LaundryPopularModel(
      id: snapshot.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      rating: double.parse((data['rating'] ?? 0.0).toString()),
      imageUrl: data['imageUrl'] ?? '',
      targetScreen: data['targetScreen'] ?? '',
      active: data['Active'] ?? false,
      destinationLat: double.parse((data['destinationLat'] ?? 0.0).toString()),
      destinationLon: double.parse((data['destinationLon'] ?? 0.0).toString()),
      titleMapLauncher: data['titleMapLauncher'] ?? '',
    );
  }
}
