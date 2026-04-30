import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String? id;
  String? image;
  String? description;
  String? category;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? latitude;
  String? longitude;
  String? userId;
  String? userFullName;

  Post({
    this.id,
    this.image,
    this.description,
    this.category,
    this.createdAt,
    this.updatedAt,
    this.latitude,
    this.longitude,
    this.userId,
    this.userFullName,
  });

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      id: map['id'],
      image: map['image'],
      description: map['description'],
      category: map['category'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      userId: map['userId'],
      userFullName: map['userfullName'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'image': image,
      'description': description,
      'category': category,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
      'userFullName': userFullName,
    };
  }
}
